//
//  CollectionViewCell.h
//  InstagramTestApp
//
//  Created by Artem on 06/10/15.
//  Copyright (c) 2015 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostData.h"

@interface PhotoCollectionCell : UICollectionViewCell

- (void)setPostData:(PostData*)postData;

@end
