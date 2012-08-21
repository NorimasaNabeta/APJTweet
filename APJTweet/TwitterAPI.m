//
//  TwitterAPI.m
//  APJTweet
//
//  Created by Norimasa Nabeta on 2012/08/19.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//
#import "TwitterAPI.h"

@implementation TwitterAPI


// https://dev.twitter.com/docs/api/1/get/users/show
// GET users/show
+ (TWRequest *) getUsersShow:(ACAccount *)account
{
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/users/show.json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:account.username, @"screen_name", nil];
    TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodGET];
    [request setAccount:account];

    return request;
}


// "profile_image_url_https": "https://si0.twimg.com/profile_images/1390759306/n208911_31619766_8580_normal.jpg",
// NSURL *urlImage = [NSURL URLWithString:[tweet valueForKeyPath:@"profile_image_url_https"]];


// https://dev.twitter.com/docs/api/1/get/users/profile_image/%3Ascreen_name
// GET users/profile_image/:screen_name
+ (TWRequest *) getUsersProfileImage:(ACAccount *)account screenname:(NSString*) screen_name
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image/%@", screen_name]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"bigger", @"size", nil];
    TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodGET];
    [request setAccount:account];

    return request;
}

// https://dev.twitter.com/docs/api/1/get/lists/all
// GET lists/all
+ (TWRequest *) getListsAll:(ACAccount *)account
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1/lists/all.json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:account.username, @"screen_name", nil];
    TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodGET];
    [request setAccount:account];
    
    return request;
}


// https://dev.twitter.com/docs/api/1/get/statuses/home_timeline
// GET statues/home_timeline
+ (TWRequest *) getStatusHomeTimeLine:(ACAccount *)account
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/home_timeline.json"];
    TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:nil requestMethod:TWRequestMethodGET];
    [request setAccount:account];

    return request;
}

// [NSDictionary dictionaryWithObjectsAndKeys:self.account.username, @"owner_screen_name", self.slug, @"slug", nil]
// https://dev.twitter.com/docs/api/1/get/lists/statuses
// GET lists/statuses
// https://api.twitter.com/1/lists/statuses.json?slug=team&owner_screen_name=twitter&per_page=1&page=1&include_entities=true
+ (TWRequest *) getListsStatuses:(ACAccount *)account slug:(NSString*)slug
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1/lists/statuses.json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:slug, @"slug", account.username, @"owner_screen_name", nil];
    TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodGET];
    [request setAccount:account];
    
    return request;
}

// https://dev.twitter.com/docs/api/1/get/friends/ids
// GET friends/ids
// https://api.twitter.com/1/friends/ids.json?cursor=-1&screen_name=twitterapi
+ (TWRequest *) getFriendsIds:(ACAccount *)account  screenname:(NSString*) screen_name
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1/friends/ids.json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:screen_name, @"screen_name", nil];
    TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodGET];
    [request setAccount:account];
    
    return request;
}

// https://dev.twitter.com/docs/api/1/get/followers/ids
// GET followers/ids
// https://api.twitter.com/1/followers/ids.json?cursor=-1&screen_name=twitterapi
+ (TWRequest *) getFollowersIds:(ACAccount *)account  screenname:(NSString*) screen_name
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1/followers/ids.json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:screen_name, @"screen_name", nil];
    TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodGET];
    [request setAccount:account];
    
    return request;
}

// https://dev.twitter.com/docs/api/1/get/users/lookup
// GET users/lookup
// https://api.twitter.com/1/users/lookup.json?screen_name=twitterapi,twitter&include_entities=true
+ (TWRequest *) getUsersLookup:(ACAccount *)account  screenname:(NSString*) screen_name
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1/users/lookup.json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:screen_name, @"screen_name", nil];
    TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodGET];
    [request setAccount:account];
    
    return request;
}

+ (TWRequest *) getUsersLookup:(ACAccount *)account  userids:(NSString*) ids
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1/users/lookup.json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:ids, @"user_id", nil];
    TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodGET];
    [request setAccount:account];
    
    return request;
}

// https://dev.twitter.com/docs/api/1/post/friendships/create
// POST friendships/create
// https://api.twitter.com/1/friendships/create.json
// user_id=1401881

// https://dev.twitter.com/docs/api/1/post/friendships/destroy
// POST friendships/destroy
// http://api.twitter.com/1/friendships/destroy.json
// Either user_id or screen_name must be provided.


// http://engineering.twitter.com/2010/02/woeids-in-twitters-trends.html


@end
