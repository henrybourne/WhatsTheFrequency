//
//  HFBChallengesViewController.m
//  Frequency
//
//  Created by Henry Bourne on 13/01/2014.
//  Copyright (c) 2014 Henry Bourne. All rights reserved.
//

#import "HFBChallengesViewController.h"
#import "HFBChallengesCell.h"
#import "HFBChallengeViewController.h"

@interface HFBChallengesViewController ()

@end

@implementation HFBChallengesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Challenges";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:Nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"HFBChallengesCell" bundle:nil] forCellReuseIdentifier:@"HFBChallengesCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.alwaysBounceVertical = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.navigationController setToolbarHidden:YES animated:NO];
    [self.navigationController setToolbarHidden:YES];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            // Pure Tone
            return 2;
            break;
            
        case 2:
            // Noise
            return 2;
            break;
            
        default:
            break;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HFBChallengesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Octave Spacing";
                break;
            case 1:
                cell.textLabel.text = @"Third Octave Spacing";
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Octave Spacing";
                break;
            case 1:
                cell.textLabel.text = @"Third Octave Spacing";
                break;
                
            default:
                break;
        }
    }
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Pure Tones";
            break;
        case 1:
            return @"Filtered Noise";
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HFBChallengeViewController *frequencyViewController;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            frequencyViewController = [[HFBChallengeViewController alloc] initWithOscillatorType:kOscTypePureTone bandwidth:kBandwidthOctave];
//            frequencyViewController.navigationItem.title = @"Pure Tones";
        }
        else if (indexPath.row == 1)
        {
            frequencyViewController = [[HFBChallengeViewController alloc] initWithOscillatorType:kOscTypePureTone bandwidth:kBandwidthThirdOctave];
//            frequencyViewController.navigationItem.title = @"Pure Tones";
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            frequencyViewController = [[HFBChallengeViewController alloc] initWithOscillatorType:kOscTypePinkNoise bandwidth:kBandwidthOctave];
//            frequencyViewController.navigationItem.title = @"Filtered Noise";
        }
        else if (indexPath.row == 1)
        {
            frequencyViewController = [[HFBChallengeViewController alloc] initWithOscillatorType:kOscTypePinkNoise bandwidth:kBandwidthThirdOctave];
//            frequencyViewController.navigationItem.title = @"Filtered Noise";
        }
    }
    frequencyViewController.navigationItem.title = @"What's the Frequency?";
    [self.navigationController pushViewController:frequencyViewController animated:YES];
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
