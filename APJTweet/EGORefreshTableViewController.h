//
//  EGORefreshTableViewController.h
//  APJTweet
//
//  Created by Norimasa Nabeta on 2012/08/20.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface EGORefreshTableViewController : UITableViewController <EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}


@end
