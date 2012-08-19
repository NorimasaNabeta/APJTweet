//
//  TwitterAPI.h
//  APJTweet
//
//  Created by Norimasa Nabeta on 2012/08/19.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

@interface TwitterAPI : NSObject

+ (TWRequest *) getUsersShow:(ACAccount *)account;
+ (TWRequest *) getUsersProfileImage:(ACAccount *)account;

+ (TWRequest *) getListsAll:(ACAccount *)account;

+ (TWRequest *) getStatusHomeTimeLine:(ACAccount *)account;
+ (TWRequest *) getListsStatuses:(ACAccount *)account slug:(NSString*)slug;

@end
