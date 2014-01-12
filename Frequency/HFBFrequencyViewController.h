//
//  HFBFrequencyViewController.h
//  Frequency
//
//  Created by Henry Bourne on 03/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFBOscillator.h"
#import "HFBFrequencyModel.h"
#import "HFBCorrectViewController.h"

@interface HFBFrequencyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HFBCorrectViewControllerDelegate>
{
    int currentFrequencyIndex;
}

@property HFBOscillator *oscillator;
@property HFBFrequencyModel *frequencyModel;
@property NSMutableArray *frequencies;
@property NSNumber *currentFrequency;
@property NSNumber *previousFrequency;
@property NSTimer *playFrequencyToGuessTimer;
@property HFBCorrectViewController *correctViewController;

@property (nonatomic, strong) IBOutlet UITableView *frequencyTableView;

- (IBAction)playFrequencyAgain:(id)sender;
- (void)setUpViewForNextQuestion;
- (void)clearView;

@end
