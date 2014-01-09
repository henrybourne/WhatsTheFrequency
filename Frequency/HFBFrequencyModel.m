//
//  HFBFrequencyModel.m
//  Frequency
//
//  Created by Henry Bourne on 07/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import "HFBFrequencyModel.h"

@implementation HFBFrequencyModel

- (id)init
{
    if (self = [super init])
    {
        self.frequencies    = [NSArray arrayWithObjects:@63, @125, @250, @500, @1000, @2000, @4000, @8000, @16000, nil];
        self.labels         = [NSArray arrayWithObjects:@"63 Hz", @"125 Hz", @"250 Hz", @"500 Hz", @"1 kHz", @"2 kHz", @"4 kHz", @"8 kHz", @"16 kHz", nil];

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
