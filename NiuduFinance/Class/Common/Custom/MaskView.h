//
//  MaskView.h
//  NiuduFinance
//
//  Created by andrewliu on 16/9/26.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskView : UIView<UIGestureRecognizerDelegate>

-(instancetype)initWithFrame:(CGRect)frame;
+(instancetype)makeViewWithMask:(CGRect)frame andView:(UIView*)view;
-(void)block:(void(^)())block;

@end
