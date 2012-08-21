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
@property (strong, nonatomic) NSDictionary *userinfo;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelScreenName;
@property (weak, nonatomic) IBOutlet UILabel *textStatusText;
@property (weak, nonatomic) IBOutlet UISwitch *swFollow;
@property (weak, nonatomic) IBOutlet UILabel *textDetail;
@end
