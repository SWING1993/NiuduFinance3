//
//  UIView+ZHBFrame.h
//  WoHelp
//
//  Created by 庄彪 on 15/8/12.
//  Copyright (c) 2015年 ultrapower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZHBFrame)

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGSize size;

/*! @brief  最大X */
@property (nonatomic, assign, readonly) CGFloat maxX;
/*! @brief  最大Y */
@property (nonatomic, assign, readonly) CGFloat maxY;
/*! @brief  最小X */
@property (nonatomic, assign, readonly) CGFloat minX;
/*! @brief  最小Y */
@property (nonatomic, assign, readonly) CGFloat minY;
/*! @brief  中心X */
@property (nonatomic, assign, readonly) CGFloat midX;
/*! @brief  中心Y */
@property (nonatomic, assign, readonly) CGFloat midY;
@end
