//
//  PostData.m
//  InstagramTestApp
//
//  Created by Interaktive Bank Ltd on 06/10/15.
//  Copyright © 2015 Artem. All rights reserved.
//

#import "PostData.h"

@implementation PostData

+ (PostData*)dataWithJSON:(NSDictionary*)json
{
    NSString* type = json[@"type"];
    if (![type isEqualToString:@"image"])
        return nil;
    PostData* post = [[PostData alloc] init];
    NSDictionary* caption = json[@"caption"];
    if (![caption isKindOfClass:[NSNull class]])
        post.captionText = caption[@"text"];
    else
        post.captionText = @"";
    NSDictionary* images = json[@"images"];
    if (![images isKindOfClass:[NSNull class]])
        post.imageURL = [NSURL URLWithString:images[@"standard_resolution"][@"url"]];
    else
        post.imageURL = nil;
    NSString* postID = json[@"id"];
    if (![postID isKindOfClass:[NSString class]])
        postID = postID.description;
    post.postID = postID;
    return post;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.postID forKey:@"postID"];
    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
    [aCoder encodeObject:self.captionText forKey:@"captionText"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.postID = [aDecoder decodeObjectForKey:@"postID"];
    self.imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
    self.captionText = [aDecoder decodeObjectForKey:@"captionText"];
    return self;
}

@end
