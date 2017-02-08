//
//  PushMoneyViewController.h
//  NiuduFinance
//
//  Created by andrewliu on 16/9/17.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "BaseViewController.h"

@interface PushMoneyViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *accountNumLabel;

@property (weak, nonatomic) IBOutlet UITextField *haveMoneyTextField;

@property (weak, nonatomic) IBOutlet UILabel *serviceMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *getMoneyLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic,strong) NSMutableArray *bankCardsArr;

@property (nonatomic,strong) NSString *haveMoney;
@end
