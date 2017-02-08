//
//  ReturnMoneyTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/2/29.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReturnMoneyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *returnLab;

@property (nonatomic,strong)NSDictionary *repayDic;

@property (nonatomic,strong) NSDictionary *debtRepayDic;
@end
