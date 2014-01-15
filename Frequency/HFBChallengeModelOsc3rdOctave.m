//
//  HFBChallengeModelOsc3rdOctave.m
//  Frequency
//
//  Created by Henry Bourne on 13/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import "HFBChallengeModelOsc3rdOctave.h"

@implementation HFBChallengeModelOsc3rdOctave

- (id)init
{
    if (self = [super init])
    {
        // 20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6000 8000 10000 12500 16000 20000

        self.frequencies        = [NSArray arrayWithObjects:@100, @125, @160, @200, @250, @315, @400, @500, @630, @800, @1000, @1250, @1600, @2000, @2500, @3150, @4000, @5000, @6000, @8000, @10000, @12500, @16000, @20000, nil];
        self.labels             = [NSArray arrayWithObjects:@"100 Hz", @"125 Hz", @"160 Hz", @"200 Hz", @"250 Hz", @"315 Hz", @"400 Hz", @"500 Hz", @"630 Hz", @"800 Hz", @"1 kHz", @"1.25 kHz", @"1.6 kHz", @"2 kHz", @"2.5 kHz", @"3.15 kHz", @"4 kHz", @"5 kHz", @"6 kHz", @"8 kHz", @"10 kHz", @"12.5 kHz", @"16 kHz", @"20 kHz", nil];
        self.wasGuessedWrong    = [NSArray arrayWithObjects:NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, nil];
    }
    return self;
}

@end
