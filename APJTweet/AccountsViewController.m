//
//  AccountsViewController.m
//  APJTweet
//
//  Created by Norimasa Nabeta on 2012/08/19.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "AccountsViewController.h"
#import "TwitterAPI.h"
#import "AppDelegate.h"

@interface AccountsViewController ()
- (void)fetchData;
@property (strong, nonatomic) NSCache *usernameCache;
@end

@implementation AccountsViewController

@synthesize accounts=_accounts;
@synthesize accountStore=_accountStore;

@synthesize usernameCache = _usernameCache;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
//    [_imageCache removeAllObjects];
    [_usernameCache removeAllObjects];
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _usernameCache = [[NSCache alloc] init];
    [_usernameCache setName:@"TWUsernameCache"];
    [self fetchData];

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


#pragma mark - Data handling

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
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            }];
        }
    }
    
    [self performSelector:@selector(doneLoadingTableViewData)
               withObject:nil afterDelay:1.0];  // Need a delay here otherwise it gets called to early and never finishes.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

// - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
// {
//     return 0;
// }

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.accounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Accounts Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    // http://stackoverflow.com/questions/8839464/uilabel-string-as-text-and-links
    ACAccount *account = [self.accounts objectAtIndex:[indexPath row]];
    cell.textLabel.text = account.username;
    cell.detailTextLabel.text = account.accountDescription;
    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *username = [_usernameCache objectForKey:account.username];
    if (username) {
        cell.textLabel.text = username;
    }
    else {
        TWRequest *fetchAdvancedUserProperties = [TwitterAPI getUsersShow:account];
        [fetchAdvancedUserProperties performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if ([urlResponse statusCode] == 200) {
                NSError *error;
                id userInfo = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
                if (userInfo != nil) {
                    // NSInvalidArgumentException:attempt to insert nil value
                    NSString *usernameCheck = [userInfo valueForKey:@"name"];
                    if( usernameCheck == nil){
                        usernameCheck=@"";
                    }
                    [_usernameCache setObject:usernameCheck forKey:account.username];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        // NSInvalidArgumentException:attempt to insert nil value
                        // NSString *usernameCheck = [userInfo valueForKey:@"name"];
                        // if( usernameCheck == nil){
                        //     usernameCheck=@"";
                        // }
                        // [_usernameCache setObject:usernameCheck forKey:account.username];
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
                    });
                }
            }
        }];
    }

    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    UIImage *image = [[appDelegate imageCache] objectForKey:account.username];
    if (image) {
        // NSLog(@"Hit: %@", account.username);
        cell.imageView.image = image;
    }
    else {
        TWRequest *fetchUserImageRequest = [TwitterAPI getUsersProfileImage:account screenname:account.username];
        [fetchUserImageRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if ([urlResponse statusCode] == 200) {
                UIImage *image = [UIImage imageWithData:responseData];
                [[appDelegate imageCache] setObject:image forKey:account.username];
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
    //
    // TweetsListViewController *tweetsListViewController = [[TweetsListViewController alloc] init];
    // tweetsListViewController.account = [self.accounts objectAtIndex:[indexPath row]];
    // [self.navigationController pushViewController:tweetsListViewController animated:TRUE];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Lists Show"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"%@:indexPath %@", segue.identifier, indexPath);
        [segue.destinationViewController setAccount:[self.accounts objectAtIndex:[indexPath row]]];
    }
}


#pragma mark - Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource
{
    // We want fresh data (added new account since launch)
    _accountStore = nil;
    _accounts = nil;
    
    _reloading = YES;
    [self fetchData];
}

@end
