//
//  IntegralLogTableViewCell.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/18.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "IntegralLogTableViewCell.h"

@interface IntegralLogTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *userDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *usedNumLabel;


@end
@implementation IntegralLogTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_usedNumLabel setTextColor:[UIColor greenColor]];
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    _typeLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Caption"]];
    _userDateLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CreateDate"]];
    if ([[[NSString stringWithFormat:@"%@",[dic objectForKey:@"Integral"]] substringToIndex:1] isEqualToString:@"-"]) {
        _usedNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Integral"]];
        _usedNumLabel.textColor = [UIColor colorWithHexString:@"#FF7A16"];
    }else{
        _usedNumLabel.text = [NSString stringWithFormat:@"+%@",[dic objectForKey:@"Integral"]];
        _usedNumLabel.textColor = [UIColor colorWithHexString:@"#51B162"];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
