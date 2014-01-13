//
//  HFBChallengesStore.h
//  Frequency
//
//  Created by Henry Bourne on 12/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFBChallengesStore : NSObject
{
    NSArray *allChallenges;
}

+ (HFBChallengesStore *)sharedStore;
- (int)numberOfChallenges;


@end
