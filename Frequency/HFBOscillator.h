//
//  HFBOscillator.h
//  Frequency
//
//  Created by Henry Bourne on 07/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

typedef enum {
    kOscStateIdle,
    kOscStateFadeIn,
    kOscStateSustaining,
    kOscStateFadeOut
} OscState;

typedef enum {
    kOscTypePureTone,
    kOscTypePinkNoise
} OscType;


@interface HFBOscillator : NSObject
{
	AudioComponentInstance audioComponent;
}

@property OscType oscType;
@property NSNumber *sampleRate;
@property NSNumber *frequency;
@property NSNumber *theta;
@property NSNumber *amplitude;
@property NSTimer *playbackTimer;
@property OscState oscState;
@property NSMutableArray *fadeCoefficients;
@property int fadeDuration;
@property int fadePosition;
@property double maxAmplitude;

// Don't use init, use one of these instead
- (id)initWithPureTone;
- (id)initWithPinkNoise;

- (void)stopFrequency;
- (void)startFrequency:(int)freq;
- (void)stopAudioUnit;

@end
