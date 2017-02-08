//
//  ReturnMoneyTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/29.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ReturnMoneyTableViewCell.h"

@implementation ReturnMoneyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setDebtRepayDic:(NSDictionary *)debtRepayDic
{
    _debtRepayDic = debtRepayDic;
    _timeLab.text = [NSString stringWithFormat:@"%@",[debtRepayDic objectForKey:@"Duedate"]];
    _timeLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _moneyLab.text = [NSString stringWithFormat:@"%@",[debtRepayDic objectForKey:@"Amount"]];
    _moneyLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _returnLab.text = [NSString stringWithFormat:@"%@",[debtRepayDic objectForKey:@"Statusid"]];
    if ([[debtRepayDic objectForKey:@"Statusid"] isEqualToString:@"已还"]) {
        _returnLab.textColor = [UIColor colorWithHexString:@"#4A77A5"];
    }else{
        _returnLab.textColor = [UIColor colorWithHexString:@"#F5635D"];
        
    }
}

- (void)setRepayDic:(NSDictionary *)repayDic
{
    _repayDic = repayDic;
    
    _timeLab.text = [_repayDic objectForKey:@"DueDate"];
    _timeLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _moneyLab.text = [_repayDic objectForKey:@"RepaymentAmount"];
    _moneyLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _returnLab.text = [_repayDic objectForKey:@"StatusName"];
    if ([[_repayDic objectForKey:@"StatusId"] integerValue] == 0) {
        _returnLab.textColor = [UIColor colorWithHexString:@"#F5635D"];
    }else{
        _returnLab.textColor = [UIColor colorWithHexString:@"#4A77A5"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
