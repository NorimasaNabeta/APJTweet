//
//  TimeLinesViewController.h
//  APJTweet
//
//  Created by Norimasa Nabeta on 2012/08/19.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import "TweetComposeViewController.h"

#import "EGORefreshTableViewController.h"
@interface TimeLinesViewController : EGORefreshTableViewController <TweetComposeViewControllerDelegate>

@property (strong, nonatomic) ACAccount *account;
@property (strong, nonatomic) id timeline;

@property (strong, nonatomic) NSString *slug;

@end
