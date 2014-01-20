//
//  HFBFrequencyModel.m
//  Frequency
//
//  Created by Henry Bourne on 07/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import "HFBChallengeModel.h"
#import "HFBFrequency.h"

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

- (id)initWithBandwidth:(Bandwidth)initBandwidth
{
    self = [self init];
    self.bandwidth = initBandwidth;
    if (self.bandwidth == kBandwidthOctave)
    {
//        self.frequencies        = [NSArray arrayWithObjects:@125, @250, @500, @1000, @2000, @4000, @8000, @16000, nil];
//        self.frequencyLabels    = [NSArray arrayWithObjects:@"125 Hz", @"250 Hz", @"500 Hz", @"1 kHz", @"2 kHz", @"4 kHz", @"8 kHz", @"16 kHz", nil];
        self.frequencies = [NSArray arrayWithObjects:
                            [[HFBFrequency alloc] initWithfrequency:125],
                            [[HFBFrequency alloc] initWithfrequency:250],
                            [[HFBFrequency alloc] initWithfrequency:500],
                            [[HFBFrequency alloc] initWithfrequency:1000],
                            [[HFBFrequency alloc] initWithfrequency:2000],
                            [[HFBFrequency alloc] initWithfrequency:4000],
                            [[HFBFrequency alloc] initWithfrequency:8000],
                            [[HFBFrequency alloc] initWithfrequency:16000],
                            nil];
    }
    else if (self.bandwidth == kBandwidthThirdOctave)
    {
        // 20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6000 8000 10000 12500 16000 20000
        self.frequencies        = [NSArray arrayWithObjects:@100, @125, @160, @200, @250, @315, @400, @500, @630, @800, @1000, @1250, @1600, @2000, @2500, @3150, @4000, @5000, @6000, @8000, @10000, @12500, @16000, @20000, nil];
        self.frequencyLabels    = [NSArray arrayWithObjects:@"100 Hz", @"125 Hz", @"160 Hz", @"200 Hz", @"250 Hz", @"315 Hz", @"400 Hz", @"500 Hz", @"630 Hz", @"800 Hz", @"1 kHz", @"1.25 kHz", @"1.6 kHz", @"2 kHz", @"2.5 kHz", @"3.15 kHz", @"4 kHz", @"5 kHz", @"6 kHz", @"8 kHz", @"10 kHz", @"12.5 kHz", @"16 kHz", @"20 kHz", nil];
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
    return [self.frequencyLabels objectAtIndex:index];
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
    return [self.frequencyLabels objectAtIndex:self.currentFrequencyIndex];
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
