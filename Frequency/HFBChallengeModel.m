//
//  HFBFrequencyModel.m
//  Frequency
//
//  Created by Henry Bourne on 07/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import "HFBChallengeModel.h"

@implementation HFBChallengeModel

- (id)init
{
    if (self = [super init])
    {
        self.numberOfAnswers = 0;
        self.numberOfCorrectAnswers = 0;
    }
    return self;
}

- (void)randomFrequency
{
    self.currentFrequencyIndex = arc4random() % [self.frequencies count];
    // Make sure the frequency is different to last time
    while (self.currentFrequencyIndex == self.previousFrequencyIndex)
    {
        self.currentFrequencyIndex = arc4random() % [self.frequencies count];
    }
    self.previousFrequencyIndex = self.currentFrequencyIndex;
}

- (NSString *)frequencyLabelAtIndex:(int)index
{
    return [self.labels objectAtIndex:index];
}

- (int)numberOfFrequencies
{
    return (int)[self.frequencies count];
}

- (int)currentFrequencyInHz
{
    int freq = (int)[[self.frequencies objectAtIndex:self.currentFrequencyIndex] integerValue];
    return freq;
}

- (NSString *)currentFrequencyLabel
{
    return [self.labels objectAtIndex:self.currentFrequencyIndex];
}

- (void)didAnswer
{
    self.numberOfAnswers++;
    NSLog(@"%@ numberOfAnswers: %i", self, self.numberOfAnswers);
}

- (void)didAnswerCorrectly
{
    self.numberOfCorrectAnswers++;
    NSLog(@"%@ numberOfCorrectAnswers: %i", self, self.numberOfCorrectAnswers);
}

- (int)currentPercentCorrect
{
    int percent = ((double)self.numberOfCorrectAnswers/(double)self.numberOfAnswers)*100;
    return percent;
}

@end
