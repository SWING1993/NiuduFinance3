//
//  AdScrollView.h
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIPageControlShowStyle)
{
    UIPageControlShowStyleNone,//default
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
};

typedef NS_ENUM(NSUInteger, AdTitleShowStyle)
{
    AdTitleShowStyleNone,
    AdTitleShowStyleLeft,
    AdTitleShowStyleCenter,
    AdTitleShowStyleRight,
};

typedef NS_ENUM(NSUInteger, AdPageLabelShowStyle)
{
    AdPageLabelShowStyleNone,
    AdPageLabelShowStyleRight
};

@interface AdScrollView : UIScrollView<UIScrollViewDelegate>

@property (retain,nonatomic,readonly) UIPageControl * pageControl;
@property (retain,nonatomic,readonly)UILabel* pageLabel;
@property (retain,nonatomic,readwrite) NSArray * imageNameArray;
@property (retain,nonatomic,readwrite) NSArray* loadImage;
@property (retain,nonatomic,readonly) NSArray * adTitleArray;
@property (assign,nonatomic,readwrite) UIPageControlShowStyle  PageControlShowStyle;
@property (assign,nonatomic,readonly) AdTitleShowStyle  adTitleStyle;
@property (assign,nonatomic,readwrite) AdPageLabelShowStyle pageLabelShowStyle;
@property (nonatomic,weak,readonly) NSTimer *moveTime; //循环滚动的周期时间

@property (nonatomic,assign) BOOL isTimer;

- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle;
@end

