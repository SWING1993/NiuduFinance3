//
//  AccountSafCell.m
//  NiuduFinance
//
//  Created by 123 on 17/2/5.
//  Copyright © 2017年 liuyong. All rights reserved.
//

#import "AccountSafCell.h"

@implementation AccountSafCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setuptitle:(NSString *)title detailText:(NSString *)detail hideLine:(BOOL)hide jianTouImageView:(BOOL)jianTouImageView zhegnjainLabel:(BOOL)zhegnjainLabel
{
    _titleLabel.text = title;
    _detailLabel.text = detail;
    _lineView.hidden = hide;
    _jianTouImageView.hidden = jianTouImageView;
    _zhegnjainLabel.hidden = zhegnjainLabel;
    
    
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.detailLabelHeight.constant = 15;
//    
//}

@end
