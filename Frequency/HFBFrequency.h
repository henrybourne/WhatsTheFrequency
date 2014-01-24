//
//  HFBFrequency.h
//  Frequency
//
//  Created by Henry Calrec on 2014/01/20.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kAnswerNone,
    kAnswerIncorrect,
    kAnswerCorrect
} AnswerState;

@interface HFBFrequency : NSObject

@property int frequency;
@property NSString *label;
@property AnswerState state;

- (id)initWithFrequency:(int)freq label:(NSString *)lab;

@end
