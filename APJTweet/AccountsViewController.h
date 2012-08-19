//
//  AccountsViewController.h
//  APJTweet
//
//  Created by Norimasa Nabeta on 2012/08/19.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import "EGORefreshTableHeaderView.h"

@interface AccountsViewController : UITableViewController <EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) NSArray *accounts;

@end
