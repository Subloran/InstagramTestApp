//
//  PopularPostsViewController.m
//  InstagramTestApp
//
//  Created by Artem on 05/10/15.
//  Copyright (c) 2015 Artem. All rights reserved.
//

#import "PopularPostsViewController.h"
#import "PhotoCollectionCell.h"
#import "PostDataList.h"
#import "InstagramAPI.h"
#import <SDImageCache.h>

@interface PopularPostsViewController ()

@property (nonatomic, strong) IBOutlet UICollectionView* collection;
@property (nonatomic, strong) PostDataList* postDataList;
@property (nonatomic, strong) NSURLSessionDataTask* loadDataTask;

@end

@implementation PopularPostsViewController

@synthesize postDataList, loadDataTask;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Обновить" style:UIBarButtonItemStylePlain target:self action:@selector(reloadData)];
    }
    return self;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collection registerNib:[UINib nibWithNibName:@"PhotoCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"photoCollectionCell"];
    postDataList = [PostDataList savedDataList];
    if (postDataList == nil)
    {
        postDataList = [[PostDataList alloc] init];
        [self reloadData];
    }
    else
        [self.collection reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshCollectionViewLayout];
    [super viewWillAppear:animated];
}

- (void)refreshCollectionViewLayout
{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    CGFloat itemWidth = self.view.bounds.size.width - layout.sectionInset.right - layout.sectionInset.left;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    [self.collection setCollectionViewLayout:layout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [loadDataTask cancel];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return postDataList.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCollectionCell" forIndexPath:indexPath];
    [cell setPostData:postDataList.dataList[indexPath.row]];
    return cell;
}

#pragma mark - Loading data

- (void)reloadData
{
    [self showLoadingStatus];
    self.collection.contentOffset = CGPointZero;
    __weak PopularPostsViewController* weakSelf = self;
    {
        loadDataTask = [[InstagramAPI sharedInstance] GET:InstagramPopularPostsMethod parameters:@{@"access_token": [InstagramAPI sharedInstance].tokenString} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            SDImageCache* imageCache = [SDImageCache sharedImageCache];
            [imageCache clearMemory];
            [imageCache clearDisk];
            [weakSelf hideLoadingStatus];
            NSDictionary* response = (NSDictionary*)responseObject;
            [weakSelf updateDataWithResponse:response];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf reloadData];
            });
        }];
    }
}

- (void)updateDataWithResponse:(NSDictionary*)response
{
    [postDataList setDataFromArray:response[@"data"]];
    [postDataList save];
    [self.collection reloadData];
}

#pragma mark - Loading status

- (void)showLoadingStatus
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.collection.hidden = YES;
    if ([self.view viewWithTag:100] == nil)
    {
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        indicator.tag = 100;
        [self.view addSubview:indicator];
        indicator.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
        [indicator startAnimating];
    }
}

- (void)hideLoadingStatus
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.collection.hidden = NO;
    UIView* indicator = [self.view viewWithTag:100];
    [indicator removeFromSuperview];
}

@end
