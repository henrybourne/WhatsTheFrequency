//
//  HFBFrequencyViewController.m
//  Frequency
//
//  Created by Henry Bourne on 03/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import "HFBFrequencyViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "HFBFrequencyCell.h"

@interface HFBFrequencyViewController ()


@end

// Octave frequencies
// 63 125 250 500 1000 2000 4000 8000 16000

// Third octave frequencies
// 20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6000 8000 10000 12500 16000 20000



@implementation HFBFrequencyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.oscillator         = [[HFBOscillator alloc] init];
        self.frequencyModel     = [[HFBChallengeModel alloc] init];
        self.previousFrequency  = @0;
        self.currentFrequency   = @0;
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"[HFBFrequencyViewController viewDidLoad]");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBezierPath *linePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0,self.view.frame.size.width, 1)];
    //shape layer for the line
    CAShapeLayer *line = [CAShapeLayer layer];
    line.path = [linePath CGPath];
    line.fillColor = [[UIColor blackColor] CGColor];
    line.frame = CGRectMake(0, 155, self.view.frame.size.width,1);
    [self.view.layer addSublayer:line];
    
    [self.frequencyTableView registerNib:[UINib nibWithNibName:@"HFBFrequencyCell" bundle:nil] forCellReuseIdentifier:@"HFBFrequencyCell"];
    self.frequencyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.frequencyTableView.alwaysBounceVertical = NO;
    
    [self nextFrequency];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Quiz Logic

- (void)nextFrequency
{
    // Stop current playback if any
    [self.oscillator stopFrequency];
    // Tell the model to get a new random frequency
    [self.frequencyModel randomFrequency];
    // Play the new frequency
    [self.oscillator startFrequency:[self.frequencyModel currentFrequencyInHz]];
}

- (void)setUpViewForNextQuestion
{
    NSLog(@"[HFBFrequencyViewController setUpViewForNextQuestion]");
    [self.frequencyTableView reloadData];

}

- (void)clearView
{
//    self.frequencyTableView
}

#pragma mark HFBCorrectViewControllerDelegate
- (void)didDismissCorrectViewController
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"Completed dismissing view controller");
        [self nextFrequency];
    }];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row != [self.frequencyModel currentFrequencyIndex])
    {
        // If guess was wrong, then mark the selection as incorrect
        NSLog(@"Incorrect Guess: %@", [self.frequencyModel frequencyLabelAtIndex:(int)indexPath.row]);
        UITableViewCell *cell = [self.frequencyTableView cellForRowAtIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor colorWithRed:240/255.0f green:110/255.0f blue:103/255.0f alpha:1.0f]];
        // [cell setAccessoryType:(UITableViewCellAccessoryType)]
        
    }
    else
    {
        // If guess was correct, show correct view
        NSLog(@"Correct Guess: %@", [self.frequencyModel frequencyLabelAtIndex:(int)indexPath.row]);
        UITableViewCell *cell = [self.frequencyTableView cellForRowAtIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor colorWithRed:145/255.0f green:215/255.0f blue:129/255.0f alpha:1.0f]];
        [self performSelector:@selector(showCorrectViewController:) withObject:nil afterDelay:0];

    }
}

-(void)showCorrectViewController:(id)sender
{
    self.correctViewController = [[HFBCorrectViewController alloc] init];
    self.correctViewController.delegate = self;
    [self presentViewController:self.correctViewController animated:YES completion:^(void){
        NSLog(@"Completed Presenting correctViewController");
        [self setUpViewForNextQuestion];
    }];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[self.frequencyModel numberOfFrequencies];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HFBFrequencyCell";
    HFBFrequencyCell *cell = (HFBFrequencyCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HFBFrequencyCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.frequencyLabel.text = [self.frequencyModel frequencyLabelAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


#pragma mark IBActions

- (IBAction)playFrequencyAgain:(id)sender
{
    [self.oscillator startFrequency:[self.frequencyModel currentFrequencyInHz]];
}


@end
