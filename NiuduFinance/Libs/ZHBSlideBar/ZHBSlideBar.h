//
//  ZHBSlideBar.h
//  ZHBSlideBarDemo
//
//  Created by 庄彪 on 15/8/16.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHBSlideBar;
@class ZHBSlideItemView;

/*!
 *  @brief  不显示标识view
 */
UIKIT_EXTERN CGFloat const ZHBSlideBarMarkViewNone;

/*!
 *  @brief  滑动条滑动的样式
 */
typedef NS_ENUM(NSInteger, ZHBSlideBarScrollPosition){
    ZHBSlideBarScrollPositionMiddle,
    ZHBSlideBarScrollPositionLeft,
    ZHBSlideBarScrollPositionRight,
    ZHBSlideBarScrollPositionNone
};


@protocol ZHBSlideBarDataSource <NSObject>

@required
/*!
 *  @brief  设置ZHBSlideBar包含的Item数
 *
 *  @param slideBar 要设置的ZHBSlideBar
 *
 *  @return item数量
 */
- (NSUInteger)numberOfItemViewsInSlideBar:(ZHBSlideBar *)slideBar;
/*!
 *  @brief  设置ZHBSlideBar在index处的view
 *
 *  @param sliderBar 要设置的ZHBSlideBar
 *  @param index     位置
 *
 *  @return ZHBSlideItemView
 */
- (ZHBSlideItemView *)slideBar:(ZHBSlideBar *)sliderBar viewForItemAtIndex:(NSUInteger)index;

@end


@protocol ZHBSlideBarDelegate <NSObject>

@optional
/*!
 *  @brief  ZHBSlideBar选中某个item的代理方法
 *
 *  @param sliderBar 响应ZHBSlideBar
 *  @param index     选中的位置
 */
- (void)slideBar:(ZHBSlideBar *)sliderBar didSelectItemViewAtIndex:(NSUInteger)index;

- (CGFloat)slideBar:(ZHBSlideBar *)sliderBar itemWidthAtIndex:(NSUInteger)index;

@end

/*!
 *  @brief  滑动条
 */
@interface ZHBSlideBar : UIView

/*! @brief  代理 */
@property (nonatomic, weak) id<ZHBSlideBarDelegate> delegate;
/*! @brief  数据源 */
@property (nonatomic, weak) id<ZHBSlideBarDataSource> dataSource;
/*! @brief  当前选中的item */
@property (nonatomic, weak, readonly) ZHBSlideItemView *currentItemView;
/*! @brief  滑动状态 */
@property (nonatomic, assign) ZHBSlideBarScrollPosition scrollPosition;
/*! @brief  底部标识高度 */
@property (nonatomic, assign) CGFloat markHeight;
/*! @brief  标识颜色 */
@property (nonatomic, strong) UIColor *markColor;
/*! @brief  滑动速度 */
@property (nonatomic, assign) NSTimeInterval duration;
/*! @brief  宽度 */
@property (nonatomic, assign) CGFloat itemWidth;

/*!
 *  @brief  ZHBSlideBar中index处的Item
 *
 *  @param index 对应位置
 *
 *  @return ZHBSlideItemView
 */
- (ZHBSlideItemView *)itemViewAtIndex:(NSUInteger)index;

/*!
 *  @brief  刷新滑动条
 */
- (void)reloadData;

/*!
 *  @brief  选中index处的item,并滑动到所处位置
 *
 *  @param index 位置
 */
- (void)selectedItemViewAtIndex:(NSUInteger)index;

@end