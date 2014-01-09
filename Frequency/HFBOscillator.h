//
//  HFBOscillator.h
//  Frequency
//
//  Created by Henry Bourne on 07/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

@interface HFBOscillator : NSObject
{
	AudioComponentInstance audioComponent;
}

@property NSNumber *sampleRate;
@property NSNumber *frequency;
@property NSNumber *theta;
@property NSTimer *playbackTimer;
@property BOOL isPlaying;

- (void)stopFrequency;
- (void)startFrequency:(int)freq;

@end
