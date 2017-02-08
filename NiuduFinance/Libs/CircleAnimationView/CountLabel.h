//
//  CountLabel.h
//  CircleAnimation
//
//  Created by fujin on 15/10/20.
//  Copyright © 2015年 fujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountLabel : UILabel
/**
 *  更新数据
 *
 *  @param percent （0-100）
 */
-(void)updateLabel:(CGFloat)percent withAnimationTime:(CGFloat)animationTime;

/**
 *  展示状态
 */
//- (void)updateLabel:(NSString *)title;
/**
 *  恢复原位置
 */
-(void)clear;


- (void)noClear;
@end
