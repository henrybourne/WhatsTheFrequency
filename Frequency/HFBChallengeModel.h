//
//  HFBFrequencyModel.h
//  Frequency
//
//  Created by Henry Bourne on 07/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFBOscillator.h"
#import "HFBFrequency.h"

@interface HFBChallengeModel : NSObject

@property Bandwidth bandwidth;
@property NSArray *frequencies;
//@property NSArray *frequencyLabels;
//@property NSArray *frequencyState;
@property int currentFrequencyIndex;
@property int previousFrequencyIndex;
@property int numberOfQuestionsPerSession;
@property int cumulativeAccuracyPerSession;
@property int numberOfAnswersPerQuestion;

- (id)initWithBandwidth:(Bandwidth)initBandwidth;
- (void)newQuestion;
- (HFBFrequency *)frequencyAtIndex:(int)index;
- (NSString *)frequencyLabelAtIndex:(int)index;
- (int)numberOfFrequencies;
- (int)currentFrequencyInHz;
- (NSString *)currentFrequencyLabel;
- (int)averageAccuracy;
- (void)setAnswerState:(AnswerState)state forFrequencyAtIndex:(int)index;
- (void)resetAllStates;

@end
