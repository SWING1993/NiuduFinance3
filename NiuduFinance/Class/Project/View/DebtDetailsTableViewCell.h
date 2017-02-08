//
//  DebtDetailsTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/2/26.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DebtDetailsViewController;
@interface DebtDetailsTableViewCell : UITableViewCell<UITextFieldDelegate>

//账户余额
@property (weak, nonatomic) IBOutlet UILabel *availableLab;

//认购份数
@property (weak, nonatomic) IBOutlet UITextField *investTextField;

//起购份数
@property (weak, nonatomic) IBOutlet UILabel *minBuyNumLabel;
//每份多少钱
@property (weak, nonatomic) IBOutlet UILabel *eachToMoneyLabel;

//预期收益
@property (weak, nonatomic) IBOutlet UITextField *getProfitLabel;

@property (nonatomic,strong)NSString *availableBalanceStr;

@property (nonatomic,strong)NSDictionary *dic;
@property (nonatomic,weak)DebtDetailsViewController *delegate;

@end
