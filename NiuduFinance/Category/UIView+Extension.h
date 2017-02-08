//
//  UIView+Extension.h
//  NiuduFinance
//
//  Created by liuyong on 16/3/3.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat w;
@property (assign, nonatomic) CGFloat h;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;
+ (instancetype)viewFromXib;
- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;
@end
