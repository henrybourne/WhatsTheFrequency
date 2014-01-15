//
//  HFBOscillator.m
//  Frequency
//
//  Created by Henry Bourne on 07/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import "HFBOscillator.h"



OSStatus createTone(void                        *inRefCon,
                    AudioUnitRenderActionFlags 	*ioActionFlags,
                    const AudioTimeStamp 		*inTimeStamp,
                    UInt32 						inBusNumber,
                    UInt32 						inNumberFrames,
                    AudioBufferList             *ioData)

{
    
    // Get the tone parameters out of the view controller
	HFBOscillator *oscillator = (__bridge HFBOscillator *)(inRefCon);
    
	double theta = [oscillator.theta doubleValue];
	double theta_increment = 2.0 * M_PI * [oscillator.frequency doubleValue] / [oscillator.sampleRate doubleValue];
    
	// This is a mono tone generator so we only need the first buffer
	const int channel = 0;
	//SInt32 *buffer = ioData->mBuffers[channel].mData;
	Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
    //int *buffer = ioData->mBuffers[0].mData;
	
	// Generate the samples
	for (int frame = 0; frame < inNumberFrames; frame++)
	{
        // Set amplitude for fade in or out
        double amplitude = 0.0f;
        
        switch (oscillator.oscState)
        {
            case kOscStateIdle:
                amplitude = 0.0f;
                break;
                
            case kOscStateFadeIn:
                if (oscillator.fadeInPosition < oscillator.fadeInDuration)
                {
                    amplitude = [oscillator.fadeInCoefficients[oscillator.fadeInPosition] doubleValue];
                    oscillator.fadeInPosition++;
                }
                else
                {
                    oscillator.fadeInPosition = 0;
                    oscillator.oscState = kOscStateSustaining;
                }
                break;
                
            case kOscStateFadeOut:
                if (oscillator.fadeOutPosition < oscillator.fadeOutDuration)
                {
                    amplitude = [oscillator.fadeOutCoefficients[oscillator.fadeOutPosition] doubleValue];
                    oscillator.fadeOutPosition++;
                }
                else
                {
                    oscillator.fadeOutPosition = 0;
                    oscillator.oscState = kOscStateIdle;
                }
                break;
                
            case kOscStateSustaining:
                amplitude = oscillator.maxAmplitude;
                break;
                
            default:
                break;
        }
//        
//        NSLog(@"Oscillator amplitude: %f", amplitude);
//        NSLog(@"Oscillator fadeInPosition: %i", oscillator.fadeInPosition);
//        NSLog(@"Oscillator fadeOutPosition: %i", oscillator.fadeOutPosition);
        
		buffer[frame] = sin(theta) * amplitude;
		
		theta += theta_increment;
		if (theta > 2.0 * M_PI)
		{
			theta -= 2.0 * M_PI;
		}
	}
	
	// Store the theta back in the view controller
	oscillator.theta = [NSNumber numberWithDouble:theta];
    
	return noErr;
}


@implementation HFBOscillator

- (id)init
{
    if (self = [super init])
    {
        self.frequency   = @1000;
        self.sampleRate  = @44100;
        self.fadeInDuration = 2000;
        self.fadeOutDuration = 2000;
        self.fadeInPosition = 0;
        self.fadeOutPosition = 0;
        self.maxAmplitude = 0.85f;
        self.oscState = kOscStateIdle;
        
        
        [self calculateFadeInArray];
        [self calculateFadeOutArray];
        
        [self setUpAudioUnit];
        
        OSStatus status = AudioUnitInitialize(audioComponent);
        NSAssert(status == noErr, @"Error initializing unit: %li", status);
        
        status = AudioOutputUnitStart(audioComponent);
        NSAssert(status == noErr, @"Error starting unit: %li", status);
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
    NSAssert(audioComponent, @"Error creating unit: %li", status);
    
    status = AudioUnitSetProperty(audioComponent,
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Output,
                                  0,
                                  &enableIO,
                                  sizeof(enableIO));
    
    NSAssert(audioComponent, @"Error enabling output: %li", status);
    
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
    
    NSAssert(status == noErr, @"Error setting stream format: %li", status);
    
    AURenderCallbackStruct callback = {
        // This is the function that will be called by the framework to produce samples
        .inputProc        = &createTone,
        // This is a pointer to some object we might want to use in the aforementioned function
        .inputProcRefCon  = (__bridge void *)(self)
    };
    
    status = AudioUnitSetProperty(audioComponent,
                                  kAudioUnitProperty_SetRenderCallback,
                                  kAudioUnitScope_Global,
                                  0,
                                  &callback,
                                  sizeof(AURenderCallbackStruct));
    
    NSAssert(status == noErr, @"Error setting callback: %li", status);
    
}

- (void)calculateFadeInArray
{
    self.fadeInCoefficients = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.fadeInDuration; i++)
    {
        double currentCoeff = (i * self.maxAmplitude) / self.fadeInDuration;
        [self.fadeInCoefficients addObject:[NSNumber numberWithDouble:currentCoeff]];
    }
    NSLog(@"[HFBOscillator calculateFadeInArray] %@", self.fadeInCoefficients);
}

- (void)calculateFadeOutArray
{
    self.fadeOutCoefficients = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.fadeOutDuration; i++)
    {
        // y(x) = y1 + x * (y2 – y1) / length
        double currentCoeff = self.maxAmplitude + i * (0 - self.maxAmplitude) / self.fadeOutDuration;
        [self.fadeOutCoefficients addObject:[NSNumber numberWithDouble:currentCoeff]];
    }
    NSLog(@"[HFBOscillator calculateFadeOutArray] %@", self.fadeOutCoefficients);
}

- (void)stopFrequencyWithTimer:(NSTimer *)timer
{
    [self stopFrequency];
}

- (void)stopFrequency
{
//    if ((audioComponent) && (self.isPlaying == YES))
//	{
//        NSLog(@"Oscillator Stop");
//		//AudioOutputUnitStop(audioComponent);
//        self.isPlaying = NO;
//        self.oscState = kOscStateFadeOut;
//    }
    
    NSLog(@"Oscillator Stop");
    self.isPlaying = NO;
    self.oscState = kOscStateIdle;
}

- (void)startFrequency:(int)freq
{
    NSLog(@"Oscillator Start");
    self.frequency = [NSNumber numberWithInt:freq];
    
    if (self.isPlaying == NO)
    {
        self.theta = @0;
        //OSStatus status = AudioOutputUnitStart(audioComponent);
        //NSAssert(status == noErr, @"Error starting unit: %li", status);
    }
    
    if ([self.playbackTimer isValid])
    {
        [self.playbackTimer invalidate];
    }
    self.playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stopFrequencyWithTimer:) userInfo:nil repeats:NO];

    self.isPlaying = YES;
    self.oscState = kOscStateFadeIn;
}

//
//AudioUnitUninitialize(audioComponent);
//AudioComponentInstanceDispose(audioComponent);
//audioComponent = nil;


@end
