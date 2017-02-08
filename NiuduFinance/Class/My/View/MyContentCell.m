//
//  MyContentCell.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/3.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MyContentCell.h"
@interface MyContentCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end


@implementation MyContentCell

- (void)setupContentIcon:(NSString *)iconName title:(NSString *)title detailText:(NSString *)detail hideLine:(BOOL)hide
{
    _iconImageView.image = [UIImage imageNamed:iconName];
    _titleLabel.text = title;
    _detailLabel.text = detail;
    _lineView.hidden = hide;
}
@end
