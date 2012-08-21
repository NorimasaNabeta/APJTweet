//
//  UserProfileViewController.h
//  APJTweet
//
//  Created by Norimasa Nabeta on 2012/08/21.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@interface UserProfileViewController : UITableViewController

@property (strong, nonatomic) ACAccount *account;
@property (strong, nonatomic) NSString *screenname;

@end
