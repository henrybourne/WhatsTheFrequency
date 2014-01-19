//
//  HFBCorrectViewController.h
//  Frequency
//
//  Created by Henry Bourne on 09/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFBChallengeModel.h"

@protocol HFBCorrectViewControllerDelegate <NSObject>
- (void)didDismissCorrectViewController;
@end

@interface HFBCorrectViewController : UIViewController

@property (nonatomic, weak) id<HFBCorrectViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property HFBChallengeModel *challengeModel;

@end
