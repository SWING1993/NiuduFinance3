//
//  InvestRecodeTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/1.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "InvestRecodeTableViewCell.h"
#import "InvestRecode.h"
#import "NSString+Adding.h"

@implementation InvestRecodeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInvestRecode:(InvestRecode *)investRecode
{
    _investRecode = investRecode;
    
    _investUserNameLab.text = _investRecode.userName;
    _investAmountLab.text = [[[NSString stringWithFormat:@"%.2f",_investRecode.successfulAmount] strmethodComma] stringByAppendingString:@"元"];
    _investBidTimeLab.text = _investRecode.bidDate;
}

- (void)setDebtDic:(NSDictionary *)debtDic
{
    _debtDic = debtDic;
    
    _investUserNameLab.text = [_debtDic objectForKey:@"Mobile"];
    _investAmountLab.text = [[[NSString stringWithFormat:@"%.2f",[[_debtDic objectForKey:@"Realprice"] floatValue]] strmethodComma] stringByAppendingString:@"元"];
    _investBidTimeLab.text = [_debtDic objectForKey:@"Creationdate"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
