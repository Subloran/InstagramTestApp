//
//  InstagramAPI.h
//  InstagramTestApp
//
//  Created by Artem on 05/10/15.
//  Copyright (c) 2015 Artem. All rights reserved.
//

#import "AFHTTPSessionManager.h"

extern NSString* InstagramPopularPostsMethod;

@interface InstagramAPI : AFHTTPSessionManager

@property (nonatomic, strong) NSString* tokenString;

+ (InstagramAPI*)sharedInstance;

@end
