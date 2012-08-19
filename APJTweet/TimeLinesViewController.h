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
#import "EGORefreshTableHeaderView.h"

@interface TimeLinesViewController : UITableViewController<TweetComposeViewControllerDelegate, EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (strong, nonatomic) ACAccount *account;
@property (strong, nonatomic) id timeline;

@property (strong, nonatomic) NSString *slug;

@end
