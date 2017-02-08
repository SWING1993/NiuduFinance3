//
//  MyViewTableViewCell.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/26.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MyViewTableViewCell.h"

@interface MyViewTableViewCell()



@end

@implementation MyViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.commitBtn.layer.cornerRadius = 5.0f;
    self.commitBtn.backgroundColor = NaviColor;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
