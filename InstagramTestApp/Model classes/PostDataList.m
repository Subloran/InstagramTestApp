//
//  PostDataList.m
//  InstagramTestApp
//
//  Created by Interaktive Bank Ltd on 06/10/15.
//  Copyright © 2015 Artem. All rights reserved.
//

#import "PostDataList.h"
#import "PostData.h"

@implementation PostDataList

@synthesize dataList;

+ (PostDataList*)savedDataList
{
    PostDataList* postDataList = [NSKeyedUnarchiver unarchiveObjectWithFile:[self fullPath]];
    return postDataList;
}

- (id)init
{
    self = [super init];
    dataList = [NSMutableArray array];
    return self;
}

- (void)save
{
    BOOL archived = [NSKeyedArchiver archiveRootObject:self toFile:[PostDataList fullPath]];
    if (!archived)
        NSLog(@"Something wrong with archiving");
}

+ (NSString*)fullPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,   NSUserDomainMask, YES);
    NSString* directoryPath = [paths.firstObject stringByAppendingString:@"InstagramCache"];
    
    NSString* fullPath = [directoryPath stringByAppendingPathComponent:@"archive.data"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:fullPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    return fullPath;
}

- (void)setDataFromArray:(NSArray *)array
{
    [dataList removeAllObjects];
    for (NSDictionary* post in array)
    {
        PostData* postObject = [PostData dataWithJSON:post];
        if (postObject)
            [dataList addObject:postObject];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:dataList forKey:@"dataList"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
        dataList = [aDecoder decodeObjectForKey:@"dataList"];
    return self;
}

@end
