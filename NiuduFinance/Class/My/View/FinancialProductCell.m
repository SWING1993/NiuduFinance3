//
//  FinancialProductCell.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/10.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "FinancialProductCell.h"

@implementation FinancialProductCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setFinancialDic:(NSDictionary *)financialDic
{
    _financialDic = financialDic;
    
    _financeTitleLab.text = [NSString stringWithFormat:@"%@%@(%d%@)",[_financialDic objectForKey:@"Title"],[_financialDic objectForKey:@"Name"],[[_financialDic objectForKey:@"LoanPeriod"] intValue],[_financialDic objectForKey:@"PeriodTypeId"]];
    _financeRateLab.text = [NSString stringWithFormat:@"%@",[_financialDic objectForKey:@"Rate"]];
    if ([[_financialDic objectForKey:@"Interest"] floatValue] / 10000 >= 1) {
        _amountLab.text = [NSString stringWithFormat:@"%.2f",[[_financialDic objectForKey:@"Interest"] floatValue] / 10000];
        _amountTypeLab.text = @"万元";
    }else{
        _amountLab.text = [NSString stringWithFormat:@"%.2f",[[_financialDic objectForKey:@"Interest"] floatValue]];
    }
    
    _investAmountLab.text = [NSString stringWithFormat:@"投资金额：%@",[_financialDic objectForKey:@"SuccessfulAmount"]];
    
    _dataLab.text = [NSString stringWithFormat:@"回款日期：%@",[_financialDic objectForKey:@"PaymentDateTime"]];
}

@end
