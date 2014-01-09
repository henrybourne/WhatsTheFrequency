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
        self.frequencyModel     = [[HFBFrequencyModel alloc] init];
        self.previousFrequency  = @0;
        self.currentFrequency   = @0;
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.frequencyTableView registerNib:[UINib nibWithNibName:@"HFBFrequencyCell" bundle:nil] forCellReuseIdentifier:@"HFBFrequencyCell"];
    [self nextFrequency];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Quiz Logic

//- (void)nextFrequency
//{
//    int randomIndex = arc4random() % [self.frequencies count];
//    self.currentFrequency = [self.frequencies objectAtIndex:randomIndex];
//    
//    // Make sure the frequency is different to last time
//    while ([self.currentFrequency isEqual:self.previousFrequency])
//    {
//        randomIndex = arc4random() % [self.frequencies count];
//        self.currentFrequency = [self.frequencies objectAtIndex:randomIndex];
//    }
//    
//    currentFrequencyIndex = randomIndex;
//    self.previousFrequency = self.currentFrequency;
//}


- (void)nextFrequency
{
    // Stop current playback if any
    [self.oscillator stopFrequency];
    // Tell the model to get a new random frequency
    [self.frequencyModel randomFrequency];
    // Play the new frequency
    [self.oscillator startFrequency:[self.frequencyModel currentFrequencyInHz]];
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If guess was wrong, then mark the selection as incorrect
    if (indexPath.row != [self.frequencyModel currentFrequencyIndex])
    {
        NSLog(@"Incorrect Guess: %@", [self.frequencyModel frequencyLabelAtIndex:indexPath.row]);
        // UITableViewCell *cell = [self.frequencyTableView cellForRowAtIndexPath:indexPath];
        // [cell setAccessoryType:(UITableViewCellAccessoryType)]
        
    }
    // If selection was correct, mark as correct
    else
    {
        NSLog(@"Correct Guess: %@", [self.frequencyModel frequencyLabelAtIndex:indexPath.row]);
        [self nextFrequency];
    }
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
    
    cell.frequencyLabel.text = [self.frequencyModel frequencyLabelAtIndex:indexPath.row];
    return cell;
}


#pragma mark IBActions

- (IBAction)playFrequencyAgain:(id)sender
{
    [self.oscillator startFrequency:[self.frequencyModel currentFrequencyInHz]];
}


@end
