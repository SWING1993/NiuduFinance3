//
//  ProjectMsgTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/29.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ProjectMsgTableViewCell.h"

@implementation ProjectMsgTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setBorrowerInfoDic:(NSDictionary *)borrowerInfoDic
{
    _borrowerInfoDic = borrowerInfoDic;
    
    _userNameLab.text = [_borrowerInfoDic objectForKey:@"UserName"];
    _ageLab.text = [NSString stringWithFormat:@"%@",[_borrowerInfoDic objectForKey:@"Age"]];
    _educationLab.text = [_borrowerInfoDic objectForKey:@"EducationId"];
    _sexLab.text = [_borrowerInfoDic objectForKey:@"Gender"];
    _marrigeLab.text = [_borrowerInfoDic objectForKey:@"MarriageStatusId"];
    _houseLab.text = [_borrowerInfoDic objectForKey:@"ResidenceTypeId"];
    _carLab.text = [_borrowerInfoDic objectForKey:@"HasBuyCar"];
    _borrowMoneyLab.text = [_borrowerInfoDic objectForKey:@"LoanUseName"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
