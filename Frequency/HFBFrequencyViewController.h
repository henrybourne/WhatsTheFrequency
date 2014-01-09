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

@interface HFBFrequencyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    int currentFrequencyIndex;
}

@property HFBOscillator *oscillator;
@property HFBFrequencyModel *frequencyModel;
@property NSMutableArray *frequencies;
@property NSNumber *currentFrequency;
@property NSNumber *previousFrequency;
@property NSTimer *playFrequencyToGuessTimer;

@property (nonatomic, strong) IBOutlet UITableView *frequencyTableView;

- (IBAction)playFrequencyAgain:(id)sender;

@end
