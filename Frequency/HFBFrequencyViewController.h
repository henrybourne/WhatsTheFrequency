//
//  HFBFrequencyViewController.h
//  Frequency
//
//  Created by Henry Bourne on 03/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFBOscillator.h"
#import "HFBChallengeModel.h"
#import "HFBCorrectViewController.h"

@interface HFBFrequencyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HFBCorrectViewControllerDelegate>
{
    int currentFrequencyIndex;
}

@property HFBOscillator *oscillator;
@property HFBChallengeModel *challengeModel;
@property NSMutableArray *frequencies;
@property NSTimer *playFrequencyToGuessTimer;
@property HFBCorrectViewController *correctViewController;

@property (nonatomic, strong) IBOutlet UITableView *frequencyTableView;

- (IBAction)playFrequencyAgain:(id)sender;
- (void)setUpViewForNextQuestion;
- (void)clearView;

@end
