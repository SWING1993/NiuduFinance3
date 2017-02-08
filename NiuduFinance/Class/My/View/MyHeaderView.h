//
//  MyHeaderView.h
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/3.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSJumpNumLabel.h"
@interface MyHeaderView : UIView


//H1
//提现
@property (weak, nonatomic) IBOutlet UIButton *withdrawalBtn;
//充值
@property (weak, nonatomic) IBOutlet UIButton *topupBtn;
//总资产
@property (weak, nonatomic) IBOutlet UILabel *totalAssetsLabel;
//可用余额
@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;
//总资产
@property (weak, nonatomic) IBOutlet UIButton *zongZiBtn;



//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
//累计收益
@property (weak, nonatomic) IBOutlet PSJumpNumLabel *moneyLabel;
//回款计划
@property (weak, nonatomic) IBOutlet UIButton *returnPlanBtn;
//资金记录
@property (weak, nonatomic) IBOutlet UIButton *fundRecodeBtn;
//
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *tiChongView;
@property (nonatomic,assign) BOOL isOpenAccount;

@end
