//
//  ProjectBorrowTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/29.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ProjectBorrowTableViewCell.h"
#import "NSString+Adding.h"

@implementation ProjectBorrowTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCreditFileDic:(NSDictionary *)creditFileDic
{
    _creditFileDic = creditFileDic;
    
    _projectNumLab.text = [NSString stringWithFormat:@"%@笔",[_creditFileDic objectForKey:@"ProjectNum"]];
    _successNumLab.text = [NSString stringWithFormat:@"%@笔",[_creditFileDic objectForKey:@"SuccessNum"]];
    _repaymentSuccessNumLab.text = [NSString stringWithFormat:@"%@笔",[_creditFileDic objectForKey:@"RepaymentSuccessNum"]];
    _successAmountLab.text = [[[NSString stringWithFormat:@"%@",[_creditFileDic objectForKey:@"SuccessAmount"]] strmethodComma] stringByAppendingString:@"元"];
    _owingAmountLab.text = [[[NSString stringWithFormat:@"%@",[_creditFileDic objectForKey:@"OwingAmount"]] strmethodComma] stringByAppendingString:@"元"];
    _overdueNumLab.text = [NSString stringWithFormat:@"%@次",[_creditFileDic objectForKey:@"OverdueNum"]];
    _overdueAmountLab.text = [NSString stringWithFormat:@"%@元",[_creditFileDic objectForKey:@"OverdueAmount"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
