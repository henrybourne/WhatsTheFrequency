//
//  HFBFrequency.m
//  Frequency
//
//  Created by Henry Calrec on 2014/01/20.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import "HFBFrequency.h"

@implementation HFBFrequency

- (id)initWithFrequency:(int)freq label:(NSString *)lab
{
    if (self = [self init])
    {
        self.frequency  = freq;
        self.label      = lab;
        self.state      = kAnswerNone;
    }
    return self;
}


@end
