//
//  MyCreditoCell.h
//  NiuduFinance
//
//  Created by 123 on 17/1/22.
//  Copyright © 2017年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCreditoCell : UITableViewCell

@property(weak, nonatomic)UILabel * nameLabel;
//协议
@property(weak, nonatomic)UIButton * agreementLabel;
//分割线
@property(weak, nonatomic)UIView * lineView;
//未收本息
@property(weak,nonatomic)UILabel * noInterest;
@property(weak,nonatomic)UILabel * weiInterest;
//年化收益
@property(weak,nonatomic)UILabel * annualEarningsLabel;
//剩余期数
@property(weak,nonatomic)UILabel * restPeriodsLabel;
//下期还款
@property(weak,nonatomic)UILabel * nextPaymentLabel;
//转让
@property(weak,nonatomic)UIButton * transferLabel;

@end
