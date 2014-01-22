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
        self.numberOfQuestionsPerSession    = 0;
        self.numberOfAnswersPerQuestion     = 0;
        self.cumulativeAccuracyPerSession   = 0;
    }
    return self;
}

- (id)initWithBandwidth:(Bandwidth)initBandwidth
{
    self = [self init];
    self.bandwidth = initBandwidth;
    if (self.bandwidth == kBandwidthOctave)
    {
        self.frequencies = [NSArray arrayWithObjects:
                            [[HFBFrequency alloc] initWithFrequency:125 label:@"125 Hz"],
                            [[HFBFrequency alloc] initWithFrequency:250 label:@"250 Hz"],
                            [[HFBFrequency alloc] initWithFrequency:500 label:@"500 Hz"],
                            [[HFBFrequency alloc] initWithFrequency:1000 label:@"1 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:2000 label:@"2 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:4000 label:@"4 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:8000 label:@"8 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:16000 label:@"16 kHz"],
                            nil];
    }
    else if (self.bandwidth == kBandwidthThirdOctave)
    {
        // 20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6000 8000 10000 12500 16000 20000
        self.frequencies = [NSArray arrayWithObjects:
                            [[HFBFrequency alloc] initWithFrequency:100 label:@"100 Hz"],
                            [[HFBFrequency alloc] initWithFrequency:125 label:@"125 Hz"],
                            [[HFBFrequency alloc] initWithFrequency:160 label:@"160 Hz"],
                            [[HFBFrequency alloc] initWithFrequency:200 label:@"200 Hz"],
                            [[HFBFrequency alloc] initWithFrequency:250 label:@"250 Hz"],
                            [[HFBFrequency alloc] initWithFrequency:315 label:@"315 Hz"],
                            [[HFBFrequency alloc] initWithFrequency:400 label:@"400 Hz"],
                            [[HFBFrequency alloc] initWithFrequency:500 label:@"500 Hz"],
                            [[HFBFrequency alloc] initWithFrequency:630 label:@"630 Hz"],
                            [[HFBFrequency alloc] initWithFrequency:800 label:@"800 Hz"],
                            [[HFBFrequency alloc] initWithFrequency:1000 label:@"1 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:1250 label:@"1.25 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:1600 label:@"1.6 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:2000 label:@"2 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:2500 label:@"2.5 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:3150 label:@"3.15 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:4000 label:@"4 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:5000 label:@"5 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:6000 label:@"6 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:8000 label:@"8 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:10000 label:@"10 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:12500 label:@"12.5 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:16000 label:@"16 kHz"],
                            [[HFBFrequency alloc] initWithFrequency:20000 label:@"20 kHz"],
                            nil];
    }
    return self;
}

- (void)newQuestion
{
    // Set up question and answer variables
    self.numberOfQuestionsPerSession++;
    NSLog(@"[HFBChallengeModel newQuestion] numberOfQuestionsPerSession = %i", self.numberOfQuestionsPerSession);
    self.numberOfAnswersPerQuestion = 0;
    
    // Choose a new frequency, different to last time
    self.currentFrequencyIndex = arc4random() % [self.frequencies count];
    while (self.currentFrequencyIndex == self.previousFrequencyIndex)
    {
        self.currentFrequencyIndex = arc4random() % [self.frequencies count];
    }
    self.previousFrequencyIndex = self.currentFrequencyIndex;
}

- (HFBFrequency *)frequencyAtIndex:(int)index
{
    HFBFrequency *freq = [self.frequencies objectAtIndex:index];
    return freq;
}

- (NSString *)frequencyLabelAtIndex:(int)index
{
    HFBFrequency *freq = [self.frequencies objectAtIndex:index];
    return freq.label;
}

- (int)numberOfFrequencies
{
    return (int)[self.frequencies count];
}

- (int)currentFrequencyInHz
{
    HFBFrequency *freq = [self.frequencies objectAtIndex:self.currentFrequencyIndex];
    return freq.frequency;
}

- (NSString *)currentFrequencyLabel
{
    HFBFrequency *freq = [self.frequencies objectAtIndex:self.currentFrequencyIndex];
    return freq.label;
}

- (int)averageAccuracy
{
    int currentAccuracy = (1.0/(double)self.numberOfAnswersPerQuestion)*100;
    NSLog(@"[averageAccuracy] currentAccuracy = %i", currentAccuracy);
    self.cumulativeAccuracyPerSession += currentAccuracy;
    NSLog(@"[averageAccuracy] cumulativeAccuracyPerSession = %i", self.cumulativeAccuracyPerSession);
    NSLog(@"[averageAccuracy] numberOfQuestionsPerSession = %i", self.numberOfQuestionsPerSession);
    int averageAccuracy = self.cumulativeAccuracyPerSession/self.numberOfQuestionsPerSession;
    NSLog(@"[averageAccuracy] averageAccuracy = %i", averageAccuracy);
    return averageAccuracy;
}

- (void)setAnswerState:(AnswerState)state forFrequencyAtIndex:(int)index
{
    HFBFrequency *freq = [self.frequencies objectAtIndex:index];
    freq.state = state;
    self.numberOfAnswersPerQuestion++;
    NSLog(@"[setAnswerState:forFrequencyAtIndex:] numberofAnswersPerQuestion = %i", self.numberOfAnswersPerQuestion);
}

- (void)resetAllStates
{
    for (HFBFrequency *freq in self.frequencies) {
        freq.state = kAnswerNone;
    }
}

@end
