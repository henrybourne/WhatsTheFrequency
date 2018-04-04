//
//  HFBChallengeViewController.m
//  Frequency
//
//  Created by Henry Calrec on 2014/01/23.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import "HFBChallengeViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HFBChallengeViewController ()

@end

@implementation HFBChallengeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithOscillatorType:(OscType)osc bandwidth:(Bandwidth)bandwidth
{
    self = [self initWithStyle:UITableViewStylePlain];
    self.notGuessedColor    = [UIColor whiteColor];
    self.guessedRightColor  = [UIColor colorWithRed:91/255.0f green:189/255.0f blue:131/255.0f alpha:1.0f];
    self.guessedWrongColor  = [UIColor colorWithRed:217/255.0f green:130/255.0f blue:132/255.0f alpha:1.0f];
    self.oscType            = osc;
    self.bandwidth          = bandwidth;
    //self.oscillator         = [HFBOscillator sharedOscillator];
    self.oscillator         = [[HFBOscillator alloc] init];
    self.oscillator.oscType = self.oscType;
    self.challengeModel     = [[HFBChallengeModel alloc] initWithBandwidth:bandwidth];
    
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"[HFBFrequencyViewController viewDidLoad]");
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if (self.bandwidth == kBandwidthOctave)
    {
        self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f];
    }
    else if (self.bandwidth == kBandwidthThirdOctave)
    {
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    
    [self.navigationController setToolbarHidden:NO];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *playAgain = [[UIBarButtonItem alloc] initWithTitle:@"Play Again" style:UIBarButtonItemStylePlain target:self action:@selector(playFrequency)];
    playAgain.accessibilityHint = @"Plays the audio to guess";
    NSArray *toolbarItems = [NSArray arrayWithObjects:flexibleSpace, playAgain, flexibleSpace, nil];
    [self setToolbarItems:toolbarItems animated:YES];
    [self chooseFrequency];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"[HFBChallengeViewController viewDidAppear]");
    [self performSelector:@selector(playFrequency) withObject:nil afterDelay:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"[HFBChallengeViewController viewWillDisappear]");
    [self.oscillator stopFrequency];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"[HFBChallengeViewController viewDidDisappear]");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Quiz Logic

- (void)chooseFrequency
{
    // Stop current playback if any
    [self.oscillator stopFrequency];
    // Tell the model to get a new random frequency
    [self.challengeModel newQuestion];
}

- (void)playFrequency
{
    // Play the new frequency
    [self.oscillator startFrequency:[self.challengeModel currentFrequencyInHz] withBandwidth:self.challengeModel.bandwidth];
}

- (void)setUpViewForNextQuestion
{
    NSLog(@"[HFBFrequencyViewController setUpViewForNextQuestion]");
    [self chooseFrequency];
    [self.challengeModel resetAllStates];
    [self.tableView reloadData];
}


#pragma mark HFBCorrectViewControllerDelegate
- (void)didDismissCorrectViewController
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"[HFBFrequencyViewController setUpViewForNextQuestion] Completed dismissing CorrectViewController");
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
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setBackgroundColor:self.guessedWrongColor];
    }
    else
    {
        // If guess was correct, show correct view
        NSLog(@"[HFBFrequencyViewController tableView:didSelectRowatIndexPath:] Correct Guess: %@", [self.challengeModel frequencyLabelAtIndex:(int)indexPath.row]);
        [self.challengeModel setAnswerState:kAnswerCorrect forFrequencyAtIndex:(int)indexPath.row];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HFBFrequencyCell"];
    
    if (cell == nil)
    {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HFBFrequencyCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    HFBFrequency *freq = [self.challengeModel frequencyAtIndex:(int)indexPath.row];
    cell.textLabel.text = freq.label;
    cell.accessibilityHint = [NSString stringWithFormat:@"Guess a frequency of %@", freq.label];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
