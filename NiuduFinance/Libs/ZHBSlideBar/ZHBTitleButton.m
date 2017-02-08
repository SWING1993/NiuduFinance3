//
//  ZHBTitleButton.m
//  BJEomsIOSApp
//
//  Created by 庄彪 on 15/6/9.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//

#import "ZHBTitleButton.h"
#import "UIView+ZHBFrame.h"

@implementation ZHBTitleButton

#pragma mark -
#pragma mark Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 内部图标居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字对齐
        self.titleLabel.textAlignment = NSTextAlignmentRight;
//        self.titleLabel.backgroundColor = [UIColor blueColor];
//        self.imageView.backgroundColor = [UIColor greenColor];
        // 文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // 字体
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        // 高亮的时候不需要调整内部的图片为灰色
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

/**
 *  设置内部图标的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageW = self.frame.size.height;
    CGFloat imageH = imageW;
    CGFloat imageX = self.frame.size.width - imageW - 15;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

/**
 *  设置内部文字的frame
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = 0;
    CGFloat titleX = 0;
    CGFloat titleH = self.height;
    CGFloat titleW = self.width - self.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
//    // 1.计算文字的尺寸
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSFontAttributeName] = self.titleLabel.font;
//    CGSize titleSize = [title sizeWithAttributes:dict];
//    // 2.计算按钮的宽度
//    self.width = titleSize.width + self.height + 10;
}


@end
