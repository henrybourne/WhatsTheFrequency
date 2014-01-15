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
    kOscStateSustaining,
    kOscStateFadeIn,
    kOscStateFadeOut,
    kOscStateIdle
} OscState;

@interface HFBOscillator : NSObject
{
	AudioComponentInstance audioComponent;
}

@property NSNumber *sampleRate;
@property NSNumber *frequency;
@property NSNumber *theta;
@property NSTimer *playbackTimer;
@property BOOL isPlaying;
@property OscState oscState;
@property NSMutableArray *fadeInCoefficients;
@property NSMutableArray *fadeOutCoefficients;
@property int fadeInDuration;                   // in samples
@property int fadeOutDuration;                  // in samples
@property int fadeInPosition;
@property int fadeOutPosition;
@property double maxAmplitude;

- (void)stopFrequency;
- (void)startFrequency:(int)freq;

@end
