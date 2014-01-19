//
//  HFBFrequencyModel.h
//  Frequency
//
//  Created by Henry Bourne on 07/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFBChallengeModel : NSObject

@property NSArray *frequencies;
@property NSArray *labels;
@property NSArray *wasGuessedWrong;
@property int currentFrequencyIndex;
@property int previousFrequencyIndex;
@property int numberOfAnswers;
@property int numberOfCorrectAnswers;

- (void)randomFrequency;
- (NSString *)frequencyLabelAtIndex:(int)index;
- (int)numberOfFrequencies;
- (int)currentFrequencyInHz;
- (NSString *)currentFrequencyLabel;
- (void)didAnswer;
- (void)didAnswerCorrectly;
- (int)currentPercentCorrect;

@end
