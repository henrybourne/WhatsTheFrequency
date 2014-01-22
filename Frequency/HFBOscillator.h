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

typedef enum {
    kBandwidthOctave,
    kBandwidthThirdOctave
} Bandwidth;

#define kPinkMaxRandomRows		32
#define kPinkRandomBits			30
#define kPinkRandomShift		((sizeof(long)*8)-kPinkRandomBits)

@interface HFBOscillator : NSObject
{
	AudioComponentInstance audioComponent;
    
    
}

@property OscType   oscType;
@property int       sampleRate;
@property int       frequency;
@property double    fadeAmplitude;
@property double    maxAmplitude;
@property NSTimer   *playbackTimer;
@property OscState  oscState;
@property NSMutableArray *fadeCoefficients;
@property int       fadeDuration;
@property int       fadePosition;

// Tone Properties
@property double toneTheta;
@property double toneThetaIncrement;
// Pink Noise Properties
@property NSMutableArray *pinkRows;
@property long  pinkRunningSum;     // Used to optimize summing of generators
@property int   pinkIndex;			// Incremented each sample
@property int   pinkIndexMask;		// Index wrapped by &ing with this mask
@property float pinkScalar;         // Used to scale within range of -1.0 to 1.0
// Noise Filter Properties
@property double noiseCenterFrequency;
@property double noiseBandwidth;
@property double noisew0;
@property double noisec;
@property double noises;
@property double noisealpha;
@property double noiseb0;
@property double noiseb1;
@property double noiseb2;
@property double noisea0;
@property double noisea1;
@property double noisea2;
@property double noiseFilterX;
@property double noiseFilterXmem1;
@property double noiseFilterXmem2;
@property double noiseFilterY;
@property double noiseFilterYmem1;
@property double noiseFilterYmem2;

- (void)setUpAudioUnit;
- (void)stopFrequency;
- (void)startFrequency:(int)freq withBandwidth:(Bandwidth)bw;
- (void)stopAudioUnit;

@end