//
//  RegisterCell.m
//  NiuduFinance
//
//  Created by 123 on 17/2/5.
//  Copyright © 2017年 liuyong. All rights reserved.
//

#import "RegisterCell.h"

@implementation RegisterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setupdetailLabel:(NSString *)detailLabel xianTextLabel:(NSString *)xianTextLabel
{
    _detailLabel.text   = detailLabel;
    _xianTextLabel.text = xianTextLabel;

    
}

@end
