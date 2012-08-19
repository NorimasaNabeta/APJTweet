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


@end
