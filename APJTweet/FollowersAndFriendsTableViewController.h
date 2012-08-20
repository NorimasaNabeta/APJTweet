//
//  FollowersAndFriendsTableViewController.h
//  APJTweet
//
//  Created by Norimasa Nabeta on 2012/08/20.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

#import "EGORefreshTableViewController.h"
@interface FollowersAndFriendsTableViewController : EGORefreshTableViewController

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) NSArray *accounts;

@property (strong, nonatomic) NSCache *friends;
@property (strong, nonatomic) NSCache *followers;


@end
