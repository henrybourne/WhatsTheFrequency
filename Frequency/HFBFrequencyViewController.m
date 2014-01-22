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


@implementation HFBFrequencyViewController


- (id)initWithOscillatorType:(OscType)osc bandwidth:(Bandwidth)bandwidth
{
    self = [self init];
    self.notGuessedColor    = [UIColor whiteColor];
    self.guessedRightColor  = [UIColor colorWithRed:91/255.0f green:189/255.0f blue:131/255.0f alpha:1.0f];
    self.guessedWrongColor  = [UIColor colorWithRed:217/255.0f green:130/255.0f blue:132/255.0f alpha:1.0f];
    self.oscillator         = [[HFBOscillator alloc] init];
    self.oscillator.oscType = osc;
    self.challengeModel     = [[HFBChallengeModel alloc] initWithBandwidth:bandwidth];
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"[HFBFrequencyViewController viewDidLoad]");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f];
//    UIBezierPath *boxPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0,self.view.frame.size.width, 90)];
//    //shape layer for the line
//    CAShapeLayer *box = [CAShapeLayer layer];
//    box.path = [boxPath CGPath];
//    box.fillColor = [[UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f] CGColor];
//    box.frame = CGRectMake(0.0, 64.0, self.view.frame.size.width,60);
//    [self.view.layer insertSublayer:box atIndex:0];
    
    UIBezierPath *linePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0,self.view.frame.size.width, 0.5)];
    //shape layer for the line
    CAShapeLayer *line = [CAShapeLayer layer];
    line.path = [linePath CGPath];
    line.fillColor = [[UIColor colorWithRed:200/255.0f green:199/255.0f blue:204/255.0f alpha:1.0f] CGColor];
    line.frame = CGRectMake(0.0, 154.0, self.view.frame.size.width,0.5);
    [self.view.layer addSublayer:line];
    

    
    [self.frequencyTableView registerNib:[UINib nibWithNibName:@"HFBFrequencyCell" bundle:nil] forCellReuseIdentifier:@"HFBFrequencyCell"];
    self.frequencyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.frequencyTableView.alwaysBounceVertical = NO;
    self.frequencyTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.frequencyTableView sizeToFit];

}

- (void)viewDidAppear:(BOOL)animated
{
    [self.oscillator setUpAudioUnit];
    [self performSelector:@selector(nextFrequency) withObject:nil afterDelay:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.oscillator stopFrequency];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.oscillator stopAudioUnit];
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
    [self.challengeModel newQuestion];
    // Play the new frequency
    [self.oscillator startFrequency:[self.challengeModel currentFrequencyInHz] withBandwidth:self.challengeModel.bandwidth];
}

- (void)replayFrequency
{
    [self.oscillator startFrequency:[self.challengeModel currentFrequencyInHz] withBandwidth:self.challengeModel.bandwidth];
}

- (void)setUpViewForNextQuestion
{
    NSLog(@"[HFBFrequencyViewController setUpViewForNextQuestion]");
    [self.challengeModel resetAllStates];
    [self.frequencyTableView reloadData];

}


#pragma mark HFBCorrectViewControllerDelegate
- (void)didDismissCorrectViewController
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"Completed dismissing view controller");
        //[self nextFrequency];
    }];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [self.challengeModel currentFrequencyIndex])
    {
        // If guess was wrong, then mark the selection as incorrect
        NSLog(@"[HFBFrequencyViewController tableView:didSelectRowatIndexPath:] Incorrect Guess: %@", [self.challengeModel frequencyLabelAtIndex:(int)indexPath.row]);
        [self.challengeModel setAnswerState:kAnswerIncorrect forFrequencyAtIndex:(int)indexPath.row];
        UITableViewCell *cell = [self.frequencyTableView cellForRowAtIndexPath:indexPath];
        [cell setBackgroundColor:self.guessedWrongColor];
    }
    else
    {
        // If guess was correct, show correct view
        NSLog(@"[HFBFrequencyViewController tableView:didSelectRowatIndexPath:] Correct Guess: %@", [self.challengeModel frequencyLabelAtIndex:(int)indexPath.row]);
        [self.challengeModel setAnswerState:kAnswerCorrect forFrequencyAtIndex:(int)indexPath.row];
        UITableViewCell *cell = [self.frequencyTableView cellForRowAtIndexPath:indexPath];
        [cell setBackgroundColor:self.guessedRightColor];
        [self performSelector:@selector(showCorrectViewController:) withObject:nil afterDelay:0];
    }
}

-(void)showCorrectViewController:(id)sender
{
    self.correctViewController = [[HFBCorrectViewController alloc] init];
    self.correctViewController.delegate = self;
    self.correctViewController.challengeModel = self.challengeModel;
    [self presentViewController:self.correctViewController animated:YES completion:^(void){
        NSLog(@"[HFBFrequencyViewController showCorrectViewController:] Completed Presenting correctViewController");
        [self setUpViewForNextQuestion];
    }];
}

// Before navigation controller destorys this viewcontroller, need to stop audio unit
// Shoudln't call when the view is hidden, as the 'Correct' dialog will hide it

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[self.challengeModel numberOfFrequencies];
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
    
    HFBFrequency *freq = [self.challengeModel frequencyAtIndex:(int)indexPath.row];
    cell.frequencyLabel.text = freq.label;
    if (freq.state == kAnswerIncorrect)
    {
        cell.backgroundColor = self.guessedWrongColor;
    }
    else if (freq.state == kAnswerCorrect)
    {
        cell.backgroundColor = self.guessedRightColor;
    }
    else if (freq.state == kAnswerNone)
    {
        cell.backgroundColor = self.notGuessedColor;
    }

    return cell;
}


#pragma mark IBActions

- (IBAction)playFrequencyAgain:(id)sender
{
    [self performSelector:@selector(replayFrequency) withObject:nil afterDelay:0];
}


@end
