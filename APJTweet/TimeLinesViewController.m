//
//  TimeLinesViewController.m
//  APJTweet
//
//  Created by Norimasa Nabeta on 2012/08/19.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "TimeLinesViewController.h"
#import "TweetComposeViewController.h"
#import "TwitterAPI.h"

@interface TimeLinesViewController ()
- (void)fetchData;
@property (strong, nonatomic) NSCache *usernameCache;
@property (strong, nonatomic) NSCache *imageCache;
@end

@implementation TimeLinesViewController

@synthesize account = _account;
@synthesize timeline = _timeline;
@synthesize slug=_slug;

@synthesize imageCache = _imageCache;
@synthesize usernameCache = _usernameCache;

- (void) setAccount:(ACAccount *)account
{
    if (_account != account) {
        _account = account;
        // NSLog(@"TL: %@", account.username);
    }
}

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
    if (_refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:
                                           CGRectMake(0.0f,
                                                      0.0f - self.tableView.bounds.size.height,
                                                      self.tableView.frame.size.width,
                                                      self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
        _refreshHeaderView.delegate = self;
        _imageCache = [[NSCache alloc] init];
        [_imageCache setName:@"TWTLImageCache"];
        _usernameCache = [[NSCache alloc] init];
        [_usernameCache setName:@"TWTLUsernameCache"];
    }

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

- (void)viewWillAppear:(BOOL)animated
{
    self.title = [NSString stringWithFormat:@"@%@", self.account.username];
    [self fetchData];
    [super viewWillAppear:animated];
}

#pragma mark - Data management

- (void)fetchData
{
    [_refreshHeaderView refreshLastUpdatedDate];
    TWRequest *request;
    if ([self.slug isEqualToString:@"timeline"]) {
        request = [TwitterAPI getStatusHomeTimeLine:self.account];
    } else {
        request = [TwitterAPI getListsStatuses:self.account slug:self.slug];
    }
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([urlResponse statusCode] == 200) {
            NSError *jsonError = nil;
            id jsonResult = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            if (jsonResult != nil) {
                self.timeline = jsonResult;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
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
    
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];  // Need a delay here otherwise it gets called to early and never finishes.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.timeline count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TimeLines Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    id tweet = [self.timeline objectAtIndex:[indexPath row]];
    // NSLog(@"Tweet at index %d is %@", [indexPath row], tweet);

    cell.textLabel.text = [tweet objectForKey:@"text"];
    cell.detailTextLabel.text = [tweet valueForKeyPath:@"user.name"];

    NSString* tweetscreenuser = [tweet valueForKeyPath:@"user.screen_name"];
    // NSString* tweetuser = [tweet valueForKeyPath:@"user.name"];
    // NSLog(@"user:%@ screen:%@", tweetuser, tweetscreenuser);
    UIImage *image = [_imageCache objectForKey:tweetscreenuser];
    if (image) {
        cell.imageView.image = image;
    }
    else {
        // https://dev.twitter.com/docs/api/1/get/users/profile_image/%3Ascreen_name
        // GET users/profile_image/:screen_name
        TWRequest *fetchUserImageRequest = [[TWRequest alloc]
                                            initWithURL:[NSURL URLWithString:
                                                         [NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image/%@",
                                                          tweetscreenuser]]
                                            parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"bigger", @"size", nil]
                                            requestMethod:TWRequestMethodGET];
        [fetchUserImageRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if ([urlResponse statusCode] == 200) {
                UIImage *image = [UIImage imageWithData:responseData];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [_imageCache setObject:image forKey:tweetscreenuser];
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

#pragma mark - Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
    // We want fresh data (added new account since launch)
    _reloading = YES;
	[self fetchData];
}

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Compose Tweet"]) {
        // NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // NSLog(@"%@:indexPath %@", segue.identifier, indexPath);
        NSLog(@"%@:", segue.identifier);
        [segue.destinationViewController setAccount:self.account];
        [segue.destinationViewController setTweetComposeDelegate:(id) self];
    }
}


- (void)tweetComposeViewController:(TweetComposeViewController *)controller
               didFinishWithResult:(TweetComposeResult)result {
    [self dismissModalViewControllerAnimated:YES];
    [self fetchData];
}

@end
