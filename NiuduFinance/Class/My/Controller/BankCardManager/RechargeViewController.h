//
//  RechargeViewController.h
//  NiuduFinance
//
//  Created by andrewliu on 16/9/18.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "BaseViewController.h"

@interface RechargeViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;


@property (weak, nonatomic) IBOutlet UILabel *accountNumLabel;

@property (weak, nonatomic) IBOutlet UITextField *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic,strong) NSMutableArray *bankCardsArr;
@end
