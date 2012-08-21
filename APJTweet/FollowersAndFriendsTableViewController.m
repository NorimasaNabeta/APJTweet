//
//  FollowersAndFriendsTableViewController.m
//  APJTweet
//
//  Created by Norimasa Nabeta on 2012/08/20.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "FollowersAndFriendsTableViewController.h"
#import "TwitterAPI.h"
#import "AppDelegate.h"

#import "UserProfileViewController.h"

@interface FollowersAndFriendsTableViewController ()
- (void)fetchData;
@end

@implementation FollowersAndFriendsTableViewController

@synthesize accounts=_accounts;
@synthesize accountStore=_accountStore;

@synthesize friends=_friends;
@synthesize followers=_followers;


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
    [self fetchData];

    _friends = [[NSCache alloc] init];
    [_friends setName:@"TWFriendsCache"];
    _followers = [[NSCache alloc] init];
    [_followers setName:@"TWFollowersCache"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.accounts count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ACAccount* account = [self.accounts objectAtIndex:section];
    NSString *title = [NSString stringWithFormat:@"%@", account.username];
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ACAccount* account = [self.accounts objectAtIndex:section];
    id friendsList = [self.friends objectForKey:account.username];
    id followersList = [self.followers objectForKey:account.username];
    NSMutableSet *allSet = [[NSMutableSet alloc] initWithArray:nil];
    int idx;
    for (idx = 0; idx< [friendsList count]; idx++) {
        [allSet addObject:[[friendsList objectAtIndex:idx] objectForKey:@"screen_name"]];
    }
    for (idx = 0; idx< [followersList count]; idx++) {
        [allSet addObject:[[followersList objectAtIndex:idx] objectForKey:@"screen_name"]];
    }
    NSArray *all = [allSet allObjects];

    return [all count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"List Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    ACAccount* account = [self.accounts objectAtIndex:indexPath.section];
    id friendsList = [self.friends objectForKey:account.username];
    id followersList = [self.followers objectForKey:account.username];
    NSMutableSet *friendsSet = [[NSMutableSet alloc] initWithArray:nil];
    NSMutableSet *followersSet = [[NSMutableSet alloc] initWithArray:nil];
    NSMutableSet *allSet = [[NSMutableSet alloc] initWithArray:nil];

    int idx;
    for (idx = 0; idx< [friendsList count]; idx++) {
        [friendsSet addObject:[[friendsList objectAtIndex:idx] objectForKey:@"screen_name"]];
        [allSet addObject:[[friendsList objectAtIndex:idx] objectForKey:@"screen_name"]];
    }
    for (idx = 0; idx< [followersList count]; idx++) {
        [followersSet addObject:[[followersList objectAtIndex:idx] objectForKey:@"screen_name"]];
        [allSet addObject:[[followersList objectAtIndex:idx] objectForKey:@"screen_name"]];
    }
    
    // Configure the cell...
    // id dict = [friendsList objectAtIndex:indexPath.row];
    // NSString* screen_name= [dict objectForKey:@"screen_name"];

    NSArray *all = [allSet allObjects];
    NSString* screen_name= [all objectAtIndex:indexPath.row];
    // name = [user objectForKey:@"name"];
    
    NSString* flag=@"";
    if( [friendsSet containsObject:screen_name]){
        flag=[flag stringByAppendingString:@"[FRIEND] "];
    }
    if( [followersSet containsObject:screen_name]){
        flag=[flag stringByAppendingString:@"[FOLLOWER] "];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", screen_name];
    cell.detailTextLabel.text = flag;
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    UIImage *image = [[appDelegate imageCache] objectForKey:screen_name];
    if (image) {
        // NSLog(@"Hit: %@", account.username);
        cell.imageView.image = image;
    }
    else {
        TWRequest *fetchUserImageRequest = [TwitterAPI getUsersProfileImage:account screenname:screen_name];
        [fetchUserImageRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if ([urlResponse statusCode] == 200) {
                UIImage *image = [UIImage imageWithData:responseData];
                [[appDelegate imageCache] setObject:image forKey:screen_name];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
                });
            }
        }];
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



// TODO: marge fetchDataAux3 and fetchDataAux4, create new id_number <--> user_profile database.
//       account --> firends, followers into NSUserDefaults
// NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
// [defaults dictionaryForKey:screen_name];
// NSArray *recents = [defaults arrayForKey:FAVORITES_KEY];
// if (! recents){
//     recents = [NSMutableArray array];
// }
// NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
// NSMutableArray *favorites = [[defaults objectForKey:FAVORITES_KEY] mutableCopy];
// [favorites insertObject:photo atIndex:0];
// [defaults setObject:[favorites copy] forKey:FAVORITES_KEY];
// [defaults synchronize];


- (void) fetchDataAux3:(ACAccount *)account userid:(NSArray*) ids
{
    // + (TWRequest *) getUsersLookup:(ACAccount *)account  userids:(NSString*) ids;
    TWRequest *request = [TwitterAPI getUsersLookup:account userids:[ids componentsJoinedByString:@","]];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([urlResponse statusCode] == 200) {
            NSError *error;
            id result = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
            if (result != nil) {
                NSLog(@"[3] Friends: %@ %d", account.username, [result count]);
                // NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), result);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.friends setObject:result forKey:account.username];
                    [self.tableView reloadData];
                });
            }
        }
    }];
    
}

- (void) fetchDataAux4:(ACAccount *)account userid:(NSArray*) ids
{
    // + (TWRequest *) getUsersLookup:(ACAccount *)account  userids:(NSString*) ids;
    TWRequest *request = [TwitterAPI getUsersLookup:account userids:[ids componentsJoinedByString:@","]];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([urlResponse statusCode] == 200) {
            NSError *error;
            id result = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
            if (result != nil) {
                // NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), result);
                NSLog(@"[4] Followers: %@ %d", account.username, [result count]);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.followers setObject:result forKey:account.username];
                    [self.tableView reloadData];
                });
            }
        }
    }];
    
}

// TODO: set this result into NSUserDefaults, as the dictionary for key screen_name.
-(void) fetchDataAux1:(ACAccount*) account
{
    TWRequest *request=[TwitterAPI getFriendsIds:account screenname:account.username];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([urlResponse statusCode] == 200) {
            NSError *jsonError = nil;
            id jsonResult = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            if (jsonResult != nil) {
                [self fetchDataAux3:account userid:[jsonResult objectForKey:@"ids"]];
                NSLog(@"[1] Friends: %@ %d", account.username, [[jsonResult objectForKey:@"ids"] count]);
            }
            else {
                NSString *message = [NSString stringWithFormat:@"Could not parse your timeline: %@", [jsonError localizedDescription]];
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:message
                                            delegate:nil
                                    cancelButtonTitle:@"Cancel"
                                    otherButtonTitles:nil] show];
            }
        }
    }];

}

// TODO: set this result into NSUserDefaults, as the dictionary for key screen_name.
- (void)fetchDataAux2:(ACAccount*)account
{
    TWRequest *request=[TwitterAPI getFollowersIds:account screenname:account.username];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([urlResponse statusCode] == 200) {
            NSError *jsonError = nil;
            id jsonResult = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            if (jsonResult != nil) {
                // [self.followerslist setObject:jsonResult forKey:account.username];
                NSLog(@"[2] Followers: %@ %d", account.username, [[jsonResult objectForKey:@"ids"] count]);
                [self fetchDataAux4:account userid:[jsonResult objectForKey:@"ids"]];
            }
            else {
                NSString *message = [NSString stringWithFormat:@"Could not parse your timeline: %@", [jsonError localizedDescription]];
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:message
                                            delegate:nil
                                    cancelButtonTitle:@"Cancel"
                                    otherButtonTitles:nil] show];
            }
        }
    }];
}
- (void)fetchData
{
    [_refreshHeaderView refreshLastUpdatedDate];
    
    if (_accountStore == nil) {
        self.accountStore = [[ACAccountStore alloc] init];
        if (_accounts == nil) {
            ACAccountType *accountTypeTwitter = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            [self.accountStore requestAccessToAccountsWithType:accountTypeTwitter
                                         withCompletionHandler:^(BOOL granted, NSError *error) {
                                             if(granted) {
                                                 self.accounts = [self.accountStore accountsWithAccountType:accountTypeTwitter];
                                                 for(ACAccount *account in self.accounts) {
                                                     [self fetchDataAux1:account];
                                                     [self fetchDataAux2:account];
                                                 }

                                             }
                                         }];
        }
    }
    
    // Need a delay here otherwise it gets called to early and never finishes.
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}

// Show Profile
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Profile Show"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"%@:indexPath %@", segue.identifier, indexPath);
        ACAccount* account = [self.accounts objectAtIndex:indexPath.section];
        [segue.destinationViewController setAccount:account];

        id friendsList = [self.friends objectForKey:account.username];
        id followersList = [self.followers objectForKey:account.username];
        NSMutableSet *allSet = [[NSMutableSet alloc] initWithArray:nil];
        int idx;
        for (idx = 0; idx< [friendsList count]; idx++) {
            [allSet addObject:[[friendsList objectAtIndex:idx] objectForKey:@"screen_name"]];
        }
        for (idx = 0; idx< [followersList count]; idx++) {
            [allSet addObject:[[followersList objectAtIndex:idx] objectForKey:@"screen_name"]];
        }
        NSArray *all = [allSet allObjects];
        
        [segue.destinationViewController setScreenname:[all objectAtIndex:indexPath.row]];
    }
}

@end
