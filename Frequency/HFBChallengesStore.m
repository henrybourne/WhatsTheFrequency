//
//  HFBChallengesStore.m
//  Frequency
//
//  Created by Henry Bourne on 12/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import "HFBChallengesStore.h"

@implementation HFBChallengesStore

+ (HFBChallengesStore *)sharedStore
{
    static HFBChallengesStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        allChallenges = [NSArray arrayWithObjects:@"Oscillator (Octaves)", @"Oscillator (Third Octaves)", nil];
    }
    return self;
}

- (int)numberOfChallenges
{
    return [allChallenges count];
}

@end
