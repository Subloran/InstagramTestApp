//
//  InstagramAPI.m
//  InstagramTestApp
//
//  Created by Artem on 05/10/15.
//  Copyright (c) 2015 Artem. All rights reserved.
//

#import "InstagramAPI.h"

static NSString* instagramBaseURL = @"https://api.instagram.com/";

static NSTimeInterval HttpRequestUntilDataTimeout = 15;
static NSTimeInterval HttpRequestTimeout = 30;

NSString* InstagramClientID = @"550b69bccdcf453bafdf7335cebcc95f";

NSString* InstagramPopularPostsMethod = @"v1/media/popular";
NSString* InstagramAuthMethod = @"oauth/authorize/";

@implementation InstagramAPI

+ (InstagramAPI*)sharedInstance
{
    static InstagramAPI* instagramAPI;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.allowsCellularAccess = YES;
        configuration.timeoutIntervalForRequest = HttpRequestUntilDataTimeout;
        configuration.timeoutIntervalForResource = HttpRequestTimeout;
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        configuration.URLCache = nil;
        
        instagramAPI = [[self alloc] initWithBaseURL:[NSURL URLWithString:instagramBaseURL] sessionConfiguration:configuration];
    });
    return instagramAPI;
}

@end
