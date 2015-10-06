//
//  CollectionViewCell.m
//  InstagramTestApp
//
//  Created by Artem on 06/10/15.
//  Copyright (c) 2015 Artem. All rights reserved.
//

#import "PhotoCollectionCell.h"
#import <UIImageView+WebCache.h>


@interface PhotoCollectionCell ()

@property (nonatomic, strong) IBOutlet UIImageView* image;
@property (nonatomic, strong) IBOutlet UILabel* captionLabel;

@end

@implementation PhotoCollectionCell

- (void)awakeFromNib
{
}

- (void)setPostData:(PostData*)postData
{
    __weak PhotoCollectionCell* weakSelf = self;
    [self.image sd_setImageWithURL:postData.imageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error)
            [weakSelf setPostData:postData];
        else
        {
            [weakSelf.image setImage:image];
        }
    }];
    [self.captionLabel setText:postData.captionText];
}

@end
