//
//  FinancialProductCell.h
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/10.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinancialProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *financeTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *financeRateLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *investAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *dataLab;
@property (weak, nonatomic) IBOutlet UILabel *amountTypeLab;

@property (nonatomic,strong)NSDictionary *financialDic;
@end
