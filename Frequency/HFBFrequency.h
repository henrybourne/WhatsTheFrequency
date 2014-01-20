//
//  HFBFrequency.h
//  Frequency
//
//  Created by Henry Calrec on 2014/01/20.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kNotGuessed,
    kGuessedWrong,
    kGuessedRight
} GuessedState;

@interface HFBFrequency : NSObject

@property int frequency;
@property NSString *label;
@property GuessedState state;

- (id)initWithfrequency:(int)freq;

@end
