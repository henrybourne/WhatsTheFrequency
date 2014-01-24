//
//  HFBChallengeViewController.h
//  Frequency
//
//  Created by Henry Calrec on 2014/01/23.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFBOscillator.h"
#import "HFBCorrectViewController.h"

@interface HFBChallengeViewController : UITableViewController <HFBCorrectViewControllerDelegate>
{
    int currentFrequencyIndex;
}

@property HFBOscillator *oscillator;
@property HFBChallengeModel *challengeModel;
@property NSMutableArray *frequencies;
@property NSTimer *playFrequencyToGuessTimer;
@property HFBCorrectViewController *correctViewController;
@property OscType oscType;
@property Bandwidth bandwidth;
@property UIColor *notGuessedColor;
@property UIColor *guessedRightColor;
@property UIColor *guessedWrongColor;

- (id)initWithOscillatorType:(OscType)osc bandwidth:(Bandwidth)bandwidth;
- (void)setUpViewForNextQuestion;

@end
