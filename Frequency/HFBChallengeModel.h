//
//  HFBFrequencyModel.h
//  Frequency
//
//  Created by Henry Bourne on 07/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kBandwidthOctave,
    kBandwidthThirdOctave
} Bandwidth;

@interface HFBChallengeModel : NSObject

@property Bandwidth bandwidth;
@property NSArray *frequencies;
@property NSArray *frequencyLabels;
@property NSArray *frequencyState;
@property int currentFrequencyIndex;
@property int previousFrequencyIndex;
@property int numberOfAnswers;
@property int numberOfCorrectAnswers;

- (id)initWithBandwidth:(Bandwidth)initBandwidth;
- (void)randomFrequency;
- (NSString *)frequencyLabelAtIndex:(int)index;
- (int)numberOfFrequencies;
- (int)currentFrequencyInHz;
- (NSString *)currentFrequencyLabel;
- (void)didAnswer;
- (void)didAnswerCorrectly;
- (int)currentPercentCorrect;

@end
