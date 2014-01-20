//
//  HFBFrequency.m
//  Frequency
//
//  Created by Henry Calrec on 2014/01/20.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import "HFBFrequency.h"

@implementation HFBFrequency

- (id)initWithfrequency:(int)freq
{
    if (self = [self init])
    {
        self.frequency = freq;
        self.state = kNotGuessed;
        self.label = [NSString stringWithFormat:@"%i Hz", self.frequency];
    }
    return self;
}


@end
