//
//  MyTailView.h
//  NiuduFinance
//
//  Created by 123 on 17/1/19.
//  Copyright © 2017年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTailView : UIView

@property (nonatomic,assign) BOOL isOpenAccount;

//最新公告
@property (weak, nonatomic) IBOutlet UIButton *mewAnnouncementBtn;
//资金记录
@property (weak, nonatomic) IBOutlet UIButton *moneyRecordBtn;
//我的投资
@property (weak, nonatomic) IBOutlet UIButton *myInvestBtn;
//债权交易
@property (weak, nonatomic) IBOutlet UIButton *bondTradingBtn;
//我的福利
@property (weak, nonatomic) IBOutlet UIButton *myWelfareBtn;
//邀请有奖
@property (weak, nonatomic) IBOutlet UIButton *invitePrizeBtn;
//积分签到
@property (weak, nonatomic) IBOutlet UIButton *integralBtn;


@property (weak, nonatomic) IBOutlet UIView *tailView;

@end
