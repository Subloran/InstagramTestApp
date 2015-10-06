//
//  PostData.h
//  InstagramTestApp
//
//  Created by Interaktive Bank Ltd on 06/10/15.
//  Copyright © 2015 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PostData : NSObject <NSCoding>

@property (nonatomic, strong) NSString* postID;
@property (nonatomic, strong) NSURL* imageURL;
@property (nonatomic, strong) NSString* captionText;

+ (PostData*)dataWithJSON:(NSDictionary*)json;

@end
