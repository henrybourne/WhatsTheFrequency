//
//  HFBOscillator.m
//  Frequency
//
//  Created by Henry Bourne on 07/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import "HFBOscillator.h"

static unsigned long sGetNextRandomNumber()
{
	static unsigned long randSeed = 22222;  /* Change this for different random sequences. */
	randSeed = (randSeed * 196314165) + 907633515;
	return randSeed;
}



#pragma mark AudioUnit Callback
OSStatus oscillatorRenderer(void                        *inRefCon,
                            AudioUnitRenderActionFlags 	*ioActionFlags,
                            const AudioTimeStamp 		*inTimeStamp,
                            UInt32 						inBusNumber,
                            UInt32 						inNumberFrames,
                            AudioBufferList             *ioData)

{
    
    // Get access to the view controller for all the generator variables
	HFBOscillator *osc = (__bridge HFBOscillator *)(inRefCon);

	// This is a mono tone generator so we only need the first buffer
	Float32 *buffer = (Float32 *)ioData->mBuffers[0].mData;
	
	// Generate the samples
	for (int frame = 0; frame < inNumberFrames; frame++)
	{
        // First calculate the amplitude if fading in or out
        switch (osc.oscState)
        {
            case kOscStateIdle:
                osc.fadeAmplitude = 0.f;
                break;
                
            case kOscStateFadeIn:
                if (osc.fadePosition < osc.fadeDuration)
                {
                    osc.fadeAmplitude = [osc.fadeCoefficients[osc.fadePosition] doubleValue];
                    osc.fadePosition++;
                }
                else
                {
                    osc.fadePosition = osc.fadeDuration - 1;
                    osc.oscState = kOscStateSustaining;
                }
                break;
                
            case kOscStateSustaining:
                osc.fadeAmplitude = osc.maxAmplitude;
                break;
                
            case kOscStateFadeOut:
                if (osc.fadePosition >= 0)
                {
                    osc.fadeAmplitude = [osc.fadeCoefficients[osc.fadePosition] doubleValue];
                    osc.fadePosition--;
                }
                else
                {
                    osc.fadePosition = 0;
                    osc.oscState = kOscStateIdle;
                }
                break;
                
            default:
                break;
        }
        
        if (osc.oscType == kOscTypePureTone)
        {
            // Generate pure tone output
            buffer[frame] = sin(osc.toneTheta) * osc.fadeAmplitude;
            
            osc.toneTheta += osc.toneThetaIncrement;
            if (osc.toneTheta > 2.0 * M_PI)
            {
                osc.toneTheta -= 2.0 * M_PI;
            }
        }
        else if (osc.oscType == kOscTypePinkNoise)
        {
            // Generate filtered noise output
            // ------ White noise
            //osc.noiseFilterX = ((long)sGetNextRandomNumber()) * (float)(1.0f / LONG_MAX) * osc.fadeAmplitude;
            
            // ------ Pink Noise
            // Increment and mask index
            osc.pinkIndex = (osc.pinkIndex + 1) & osc.pinkIndexMask;
            
            // If index is zero, don't update any random values
            if (osc.pinkIndex) {
                int numZeros = 0;
                int n = osc.pinkIndex;
                
                // Determine how many trailing zeros in pinkIndex
                // this will hang if n == 0 so test first
                while((n & 1) == 0) {
                    n = n >> 1;
                    numZeros++;
                }
                
                // Replace the indexed rows random value
                // Subtract and add back to pinkRunningSum instead of adding all
                // the random values together. only one changes each time
                osc.pinkRunningSum -= [[osc.pinkRows objectAtIndex:numZeros] longValue];
                long newRandom = ((long)sGetNextRandomNumber()) >> kPinkRandomShift;
                osc.pinkRunningSum += newRandom;
                [osc.pinkRows replaceObjectAtIndex:numZeros withObject:[NSNumber numberWithLong:newRandom]];
            }
            
            // Add extra white noise value
            long newRandom = ((long)sGetNextRandomNumber()) >> kPinkRandomShift;
//            NSLog(@"OSC kPinkRandomShift: %lu", kPinkRandomShift);
//            NSLog(@"OSC newRandom: %lu", newRandom);
            long sum = osc.pinkRunningSum + newRandom;
//            NSLog(@"OSC sum: %lu", kPinkRandomShift);
            
            // Scale to range of -1.0 to 0.999 and factor in volume
            osc.noiseFilterX = osc.pinkScalar * sum * osc.fadeAmplitude;
//            NSLog(@"OSC osc.noiseFilterX: %f osc.pinkScalar: %f osc.fadeAmplitude: %f", osc.noiseFilterX, osc.pinkScalar, osc.fadeAmplitude);
            
    
            // ---- Apply Filter
            // number y = b0*x + b1*xmem1 + b2*xmem2 - a1*ymem1 - a2*ymem2;
            osc.noiseFilterY = (osc.noiseb0*osc.noiseFilterX) + (osc.noiseb1*osc.noiseFilterXmem1) + (osc.noiseb2*osc.noiseFilterXmem2) - (osc.noisea1*osc.noiseFilterYmem1) - (osc.noisea2*osc.noiseFilterYmem2);
            
            buffer[frame] = osc.noiseFilterY;
            
            // step values for next loop
            osc.noiseFilterXmem2 = osc.noiseFilterXmem1;
            osc.noiseFilterXmem1 = osc.noiseFilterX;
            osc.noiseFilterYmem2 = osc.noiseFilterYmem1;
            osc.noiseFilterYmem1 = osc.noiseFilterY;
        }
	}
	
	return noErr;
}


#pragma mark Implementation

@implementation HFBOscillator

+ (HFBOscillator *)sharedOscillator
{
    static HFBOscillator *sharedOscillator = nil;
    if (!sharedOscillator)
        sharedOscillator = [[super allocWithZone:nil] init];
    return sharedOscillator;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedOscillator];
}

- (id)init
{
    if (self = [super init])
    {
        self.frequency      = 1000;
        self.sampleRate     = 44100;
        self.fadeDuration   = 6000;
        self.fadePosition   = 0;
        self.fadeAmplitude  = 0.0f;
        self.maxAmplitude   = 0.4f;
        self.oscState       = kOscStateIdle;
        int numRows         = 5;
        self.pinkRows       = [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, nil];
        self.pinkIndex      = 0;
        self.pinkIndexMask  = (1 << numRows) - 1;
        // Calculate max possible signed random value. extra 1 for white noise always added
        long pmax           = (numRows + 1) * (1 << (kPinkRandomBits-1));
        self.pinkScalar     = 1.0f / pmax;
        self.pinkRunningSum = 0;

        
        [self calculateFadeCoefficients];
        [self setUpAudioUnit];
    }
    return self;
}

- (void)setUpAudioUnit
{
    AudioComponent outputComponent;
    OSStatus status;
    int enableIO = 1;
    
    AudioComponentDescription desc = {
        .componentType          = kAudioUnitType_Output,
        .componentSubType       = kAudioUnitSubType_RemoteIO,
        .componentManufacturer  = kAudioUnitManufacturer_Apple,
        .componentFlags         = 0,
        .componentFlagsMask     = 0
    };
    
    outputComponent = AudioComponentFindNext(NULL, &desc);
    NSAssert(outputComponent, @"Can't find default output", NULL);
    
    status = AudioComponentInstanceNew(outputComponent, &audioComponent);
    NSAssert(audioComponent, @"Error creating unit: %i", (int)status);
    
    status = AudioUnitSetProperty(audioComponent,
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Output,
                                  0,
                                  &enableIO,
                                  sizeof(enableIO));
    
    NSAssert(audioComponent, @"Error enabling output: %i", (int)status);
    
    const int four_bytes_per_float = 4;
	const int eight_bits_per_byte = 8;
	AudioStreamBasicDescription format = {
        .mSampleRate        = self.sampleRate,
        .mBytesPerPacket    = four_bytes_per_float,
        .mFramesPerPacket   = 1,
        .mBytesPerFrame     = four_bytes_per_float,
        .mChannelsPerFrame  = 1,
        .mBitsPerChannel    = four_bytes_per_float * eight_bits_per_byte,
        .mReserved          = 0,
        .mFormatID          = kAudioFormatLinearPCM,
        .mFormatFlags       = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved
    };
    
    status = AudioUnitSetProperty(audioComponent,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Input,
                                  0,
                                  &format,
                                  sizeof(AudioStreamBasicDescription));
    
    NSAssert(status == noErr, @"Error setting stream format: %i", (int)status);
    
    AURenderCallbackStruct callback = {
        // This is the function that will be called by the framework to produce samples
        .inputProc        = &oscillatorRenderer,
        // This is a pointer to some object we might want to use in the aforementioned function
        .inputProcRefCon  = (__bridge void *)(self)
    };
    
    status = AudioUnitSetProperty(audioComponent,
                                  kAudioUnitProperty_SetRenderCallback,
                                  kAudioUnitScope_Global,
                                  0,
                                  &callback,
                                  sizeof(AURenderCallbackStruct));
    
    NSAssert(status == noErr, @"Error setting callback: %i", (int)status);
    
    status = AudioUnitInitialize(audioComponent);
    NSAssert(status == noErr, @"Error initializing unit: %i", (int)status);
    
    status = AudioOutputUnitStart(audioComponent);
    NSAssert(status == noErr, @"Error starting unit: %i", (int)status);
}

- (void)stopAudioUnit
{
    AudioOutputUnitStop(audioComponent);
    AudioUnitUninitialize(audioComponent);
    AudioComponentInstanceDispose(audioComponent);
    audioComponent = nil;
}

- (void)calculateFadeCoefficients
{
    self.fadeCoefficients = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.fadeDuration; i++)
    {
        double currentCoeff = (i * self.maxAmplitude) / self.fadeDuration;
        [self.fadeCoefficients addObject:[NSNumber numberWithDouble:currentCoeff]];
    }
}

- (void)startFrequency:(int)freq withBandwidth:(Bandwidth)bw
{
    NSLog(@"Oscillator Start");
    self.frequency = freq;
    
    // Set up tone variables
	self.toneThetaIncrement = 2.0 * M_PI * self.frequency/self.sampleRate;
    
    // Set up noise variables
    self.noiseCenterFrequency = freq;
    if (bw == kBandwidthOctave)
    {
        self.noiseBandwidth = 1;
    }
    else if (bw == kBandwidthThirdOctave)
    {
        self.noiseBandwidth = 0.3;
    }
    // Calculate filtered noise variables
    // w0    = 2*pi*f0/Fs
    // c     = cos(w0)
    // s     = sin(w0)
    // alpha = s*sinh( ln(2)/2 * BW * w0/s )
    self.noisew0    = 2*M_PI*self.noiseCenterFrequency/self.sampleRate;
    self.noisec     = cos(self.noisew0);
    self.noises     = sin(self.noisew0);
    self.noisealpha = self.noises*sinh(log(2)/2 * self.noiseBandwidth * self.noisew0/self.noises);
    // Calculate filter coeffients
    // b0 =   alpha
    // b1 =   0
    // b2 =  -alpha
    // a0 =   1 + alpha
    // a1 =  -2*cos(w0)
    // a2 =   1 - alpha
    self.noiseb0 =  self.noisealpha;
    self.noiseb1 =  0;
    self.noiseb2 =  -self.noisealpha;
    self.noisea0 =  1 + self.noisealpha;
    self.noisea1 =  -2*self.noisec;
    self.noisea2 =  1 - self.noisealpha;
    // Normalize coefficients
    // b0 /= a0
    // b1 /= a0
    // b2 /= a0
    // a1 /= a0
    // a2 /= a0
    self.noiseb0 /= self.noisea0;
    self.noiseb1 /= self.noisea0;
    self.noiseb2 /= self.noisea0;
    self.noisea1 /= self.noisea0;
    self.noisea2 /= self.noisea0;
    
    
    if ([self.playbackTimer isValid])
    {
        [self.playbackTimer invalidate];
    }
    self.playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stopFrequencyWithTimer:) userInfo:nil repeats:NO];
    self.oscState = kOscStateFadeIn;
}

- (void)stopFrequencyWithTimer:(NSTimer *)timer
{
    [self stopFrequency];
}

- (void)stopFrequency
{
    NSLog(@"Oscillator Stop");
    self.oscState = kOscStateFadeOut;
}

@end