//
//  UserProfileViewController.m
//  APJTweet
//
//  Created by Norimasa Nabeta on 2012/08/21.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "UserProfileViewController.h"
#import "TwitterAPI.h"
#import "AppDelegate.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController
@synthesize account=_account;
@synthesize userinfo=_userinfo;
@synthesize profileImage = _profileImage;
@synthesize labelName = _labelName;
@synthesize labelScreenName = _labelScreenName;
@synthesize textStatusText = _textStatusText;
@synthesize swFollow = _swFollow;
@synthesize textDetail = _textDetail;

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

    NSString *screen_name = [self.userinfo objectForKey:@"screen_name"];
    NSString *following = [self.userinfo objectForKey:@"following"];
    if ( [self.userinfo objectForKey:@"following"] ){
        NSLog(@"%@ ON:following:%@", screen_name, following);
        self.swFollow.on =YES;
    } else {
        NSLog(@"%@ OFF:following:%@", screen_name, following);
        self.swFollow.on =NO;
    }
    self.labelScreenName.text=[NSString stringWithFormat:@"@%@", screen_name];
    self.labelName.text = [self.userinfo objectForKey:@"name"];
    self.textStatusText.text = [self.userinfo valueForKeyPath:@"description"];
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    UIImage *image = [[appDelegate imageCache] objectForKey:screen_name];
    if (image) {
        // NSLog(@"Hit: %@", self.screenname);
        self.profileImage.image = image;
    }
    else {
        TWRequest *fetchUserImageRequest = [TwitterAPI getUsersProfileImage:self.account screenname:screen_name];
        [fetchUserImageRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if ([urlResponse statusCode] == 200) {
                UIImage *image = [UIImage imageWithData:responseData];
                [[appDelegate imageCache] setObject:image forKey:screen_name];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.profileImage.image = image;
                    [self.tableView reloadData];
                });
            }
        }];
    }
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
}

- (void)viewDidUnload
{
    [self setProfileImage:nil];
    [self setLabelName:nil];
    [self setLabelScreenName:nil];
    [self setTextStatusText:nil];
    [self setSwFollow:nil];
    [self setTextDetail:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
// #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
// #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Profile Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}
*/
- (IBAction)followedChanged:(id)sender {
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
