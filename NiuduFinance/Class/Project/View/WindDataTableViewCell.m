//
//  WindDataTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/29.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "WindDataTableViewCell.h"
#import "WindDataCollectionViewCell.h"
#import <MWPhotoBrowser.h>
#import "BaseNavigationController.h"
#import "NetWorkingUtil.h"

@interface WindDataTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *windDataCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end

@implementation WindDataTableViewCell

- (void)awakeFromNib {
    _windDataCollectionView.delegate = self;
    _windDataCollectionView.dataSource = self;
    [_windDataCollectionView registerNib:[UINib nibWithNibName:@"WindDataCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WindDataCollectionViewCell"];
    
    _layout.itemSize = CGSizeMake((SCREEN_WIDTH - 32) / 2, 110);
    _layout.minimumInteritemSpacing = 12;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProjectImageArr:(NSMutableArray *)projectImageArr
{
    _projectImageArr = projectImageArr;
    
    _windDataCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    if (_projectImageArr.count <= 2) {
        _windDataCollectionView.size = CGSizeMake(SCREEN_WIDTH - 20, 110);
    }else if (_projectImageArr.count <= 4){
        _windDataCollectionView.size = CGSizeMake(SCREEN_WIDTH - 20, 110 * 2 + 12);
    }else if (_projectImageArr.count <= 6){
        _windDataCollectionView.size = CGSizeMake(SCREEN_WIDTH - 20, 110 * 3 + 12 * 2);
    }else if (_projectImageArr.count <= 8){
        _windDataCollectionView.size = CGSizeMake(SCREEN_WIDTH - 20, 110 * 4 + 12 * 3);
    }else if (_projectImageArr.count <= 10){
        _windDataCollectionView.size = CGSizeMake(SCREEN_WIDTH - 20, 110 * 5 + 12 * 4);
    }
    
    [_windDataCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _projectImageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WindDataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WindDataCollectionViewCell" forIndexPath:indexPath];
    [NetWorkingUtil setImage:cell.windDataImageView url:[_projectImageArr[indexPath.row] objectForKey:@"Url"] defaultIconName:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 查看图片 //删除功能
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = NO;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:indexPath.row];
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    
    // Present
    BaseNavigationController *nc = [[BaseNavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UIViewController *vc = (UIViewController *)self.delegate;
    [vc presentViewController:nc animated:YES completion:nil];
}

//#pragma mark - MWPhotoBrowserDelegate
//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
//{
//    NSInteger number = _images.count;
//    return number;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
//{
//    NSDictionary *dict = _images[index];
//    MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dict objectForKey:@"Picture"]]];
//    return photo;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
//{
//    NSDictionary *dict = _images[index];
//    MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dict objectForKey:@"Picture"]]];
//    return photo;
//}
//
//- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser
//{
//    [photoBrowser dismissViewControllerAnimated:YES completion:nil];
//}

@end
