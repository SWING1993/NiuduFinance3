//
//  ZHBSlideItemView.h
//  ZHBSlideBarDemo
//
//  Created by 庄彪 on 15/8/16.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHBSlideItemView : UIControl

/*! @brief  标题 */
@property (nonatomic, strong) NSString *title;
/*! @brief  标识 */
@property (nonatomic, strong) NSString *identifier;
/*! @brief  默认颜色 */
@property (nonatomic, strong) UIColor *normalsColor;
/*! @brief  选中颜色 */
@property (nonatomic, strong) UIColor *selectedsColor;
/*! @brief  默认字体 */
@property (nonatomic, strong) UIFont *normalFont;
/*! @brief  选中字体 */
@property (nonatomic, strong) UIFont *selectedFont;



//默认图片
@property (nonatomic, strong)UIImage * normalaImage;
//选中图片
@property (nonatomic, strong)UIImage * selectedsImage;


@end
