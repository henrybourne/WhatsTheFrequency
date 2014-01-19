//
//  HFBCorrectViewController.m
//  Frequency
//
//  Created by Henry Bourne on 09/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import "HFBCorrectViewController.h"

@interface HFBCorrectViewController ()

@end

@implementation HFBCorrectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        NSLog(@"[HFBCorrectViewController initWithNibName:bundle:]");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"[HFBCorrectViewController viewDidLoad]");
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i%%", [self.challengeModel currentPercentCorrect]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"[HFBCorrectViewController viewDidAppear]");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender
{
    NSLog(@"[HFBCorrectViewController close:sender:]");
    [self.delegate didDismissCorrectViewController];
}


@end
