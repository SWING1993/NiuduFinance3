//
//  ShowBigImage.h
//  NiuduFinance
//
//  Created by andrewliu on 16/10/13.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
    查看大图
 */
@interface ShowBigImage : NSObject
/**
 *  浏览大图
 *
 *  @param scanImageView 图片所在的imageView
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview;
@end
