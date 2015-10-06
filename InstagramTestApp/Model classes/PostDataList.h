//
//  PostDataList.h
//  InstagramTestApp
//
//  Created by Interaktive Bank Ltd on 06/10/15.
//  Copyright © 2015 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostDataList : NSObject <NSCoding>

@property (nonatomic, strong, readonly) NSMutableArray* dataList;

+ (PostDataList*)savedDataList;
- (void)save;
- (void)setDataFromArray:(NSArray*)array;

@end
