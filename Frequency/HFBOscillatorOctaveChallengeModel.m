//
//  HFBOscillatorOctaveChallengeModel.m
//  Frequency
//
//  Created by Henry Bourne on 13/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import "HFBOscillatorOctaveChallengeModel.h"

@implementation HFBOscillatorOctaveChallengeModel

- (id)init
{
    if (self = [super init])
    {
        self.frequencies        = [NSArray arrayWithObjects:@125, @250, @500, @1000, @2000, @4000, @8000, @16000, nil];
        self.labels             = [NSArray arrayWithObjects:@"125 Hz", @"250 Hz", @"500 Hz", @"1 kHz", @"2 kHz", @"4 kHz", @"8 kHz", @"16 kHz", nil];
        self.wasGuessedWrong    = [NSArray arrayWithObjects:NO, NO, NO, NO, NO, NO, NO, NO, nil];
    }
    return self;
}


@end
