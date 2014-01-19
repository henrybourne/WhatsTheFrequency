//
//  HFBOscillator.mm
//  Frequency
//
//  Created by Henry Bourne on 07/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import "HFBOscillator.h"

#pragma mark AudioUnit Callback
OSStatus oscillatorRenderer(void                        *inRefCon,
                            AudioUnitRenderActionFlags 	*ioActionFlags,
                            const AudioTimeStamp 		*inTimeStamp,
                            UInt32 						inBusNumber,
                            UInt32 						inNumberFrames,
                            AudioBufferList             *ioData)

{
    
    // Get the tone parameters out of the view controller
	HFBOscillator *oscillator = (__bridge HFBOscillator *)(inRefCon);
    
    double amplitude = [oscillator.amplitude doubleValue];
	double theta = [oscillator.theta doubleValue];
	double theta_increment = 2.0 * M_PI * [oscillator.frequency doubleValue] / [oscillator.sampleRate doubleValue];
    
	// This is a mono tone generator so we only need the first buffer
	const int channel = 0;
	Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
	
	// Generate the samples
	for (int frame = 0; frame < inNumberFrames; frame++)
	{
        switch (oscillator.oscState)
        {
            case kOscStateIdle:
                amplitude = 0.f;
                break;
                
            case kOscStateFadeIn:
                if (oscillator.fadePosition < oscillator.fadeDuration)
                {
                    amplitude = [oscillator.fadeCoefficients[oscillator.fadePosition] doubleValue];
                    oscillator.fadePosition++;
                }
                else
                {
                    oscillator.fadePosition = oscillator.fadeDuration - 1;
                    oscillator.oscState = kOscStateSustaining;
                }
                break;
                
            case kOscStateSustaining:
                amplitude = oscillator.maxAmplitude;
                break;
                
            case kOscStateFadeOut:
                if (oscillator.fadePosition >= 0)
                {
                    amplitude = [oscillator.fadeCoefficients[oscillator.fadePosition] doubleValue];
                    oscillator.fadePosition--;
                }
                else
                {
                    oscillator.fadePosition = 0;
                    oscillator.oscState = kOscStateIdle;
                }
                break;
                
            default:
                break;
        }
        
        // Generate the sample for this frame
		buffer[frame] = sin(theta) * amplitude;
        
		theta += theta_increment;
		if (theta > 2.0 * M_PI)
		{
			theta -= 2.0 * M_PI;
		}
	}
	
	// Store the theta back in the view controller
	oscillator.theta = [NSNumber numberWithDouble:theta];
    oscillator.amplitude = [NSNumber numberWithDouble:amplitude];
    
	return noErr;
}


#pragma mark Implementation

@implementation HFBOscillator

- (id)init
{
    if (self = [super init])
    {
        self.frequency   = @1000;
        self.sampleRate  = @44100;
        self.fadeDuration = 8000;
        self.fadePosition = 0;
        self.amplitude = 0;
        self.maxAmplitude = 0.5f;
        self.oscState = kOscStateIdle;
        [self calculateFadeCoefficients];
    }
    return self;
}

- (id)initWithPureTone
{
    self = [self init];
    
    self.oscType = kOscTypePureTone;
    [self setUpAudioUnit];
    return self;
}

- (id)initWithPinkNoise
{
    self = [self init];
    
    self.oscType = kOscTypePinkNoise;
    [self setUpAudioUnit];
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
        .mSampleRate        = [self.sampleRate intValue],
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
    
    // select which oscillator to use as callback
//    switch (self.oscType) {
//        case kOscTypePureTone:
//            callback.inputProc = &pureToneGenerator;
//            break;
//            
//        case kOscTypePinkNoise:
//            callback.inputProc = &pinkNoiseGenerator;
//            break;
//            
//        default:
//            break;
//    }
    
    
//    AURenderCallbackStruct callback = {
//        // This is the function that will be called by the framework to produce samples
//        .inputProc        = &toneGenerator;,
//        // This is a pointer to some object we might want to use in the aforementioned function
//        .inputProcRefCon  = (__bridge void *)(self)
//    };
    
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

- (void)calculateFadeCoefficients
{
    self.fadeCoefficients = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.fadeDuration; i++)
    {
        double currentCoeff = (i * self.maxAmplitude) / self.fadeDuration;
        [self.fadeCoefficients addObject:[NSNumber numberWithDouble:currentCoeff]];
    }
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

- (void)startFrequency:(int)freq
{
    NSLog(@"Oscillator Start");
    self.frequency = [NSNumber numberWithInt:freq];
    
    if ([self.playbackTimer isValid])
    {
        [self.playbackTimer invalidate];
    }
    self.playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stopFrequencyWithTimer:) userInfo:nil repeats:NO];
    self.oscState = kOscStateFadeIn;
}

- (void)stopAudioUnit
{
    AudioOutputUnitStop(audioComponent);
    AudioUnitUninitialize(audioComponent);
    AudioComponentInstanceDispose(audioComponent);
    audioComponent = nil;
}


//AudioOutputUnitStop(audioComponent);
//AudioUnitUninitialize(audioComponent);
//AudioComponentInstanceDispose(audioComponent);
//audioComponent = nil;


@end
