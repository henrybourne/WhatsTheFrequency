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
    
    //NSLog(@"Current Frequency: %d", self.currentFrequencyIndex);
}

- (NSString *)frequencyLabelAtIndex:(int)index
{
    return [self.labels objectAtIndex:index];
}

- (int)numberOfFrequencies
{
    return [self.frequencies count];
}

- (int)currentFrequencyInHz
{
    int freq = [[self.frequencies objectAtIndex:self.currentFrequencyIndex] integerValue];
    //NSLog(@"currentFrequencyInHz returns %d", freq);
    return freq;
}

- (NSString *)currentFrequencyLabel
{
    return [self.labels objectAtIndex:self.currentFrequencyIndex];
}

@end
