//
//  ChoseBankCardCell.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/20.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ChoseBankCardCell.h"




@implementation ChoseBankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setBankNameLabel:(UILabel *)bankNameLabel
{
    _bankNameLabel = bankNameLabel;
    
    _bankNameLabel.text = bankNameLabel.text;
}

- (void)setIconString:(NSString *)iconString
{
    _iconString = iconString;
    _iconImageView.image = [UIImage imageNamed:iconString];
}

- (void)setIsChose:(BOOL)isChose
{
    _isChose = isChose;
    
    if (isChose && self.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        _choseImageView.image = [UIImage imageNamed:@"chooseBank"];
    }{

        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
