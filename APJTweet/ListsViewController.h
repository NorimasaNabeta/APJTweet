//
//  ListsViewController.h
//  APJTweet
//
//  Created by Norimasa Nabeta on 2012/08/19.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

#import "EGORefreshTableViewController.h"
@interface ListsViewController : EGORefreshTableViewController

@property (strong, nonatomic) ACAccount *account;
@property (strong, nonatomic) id userslist;

@end
