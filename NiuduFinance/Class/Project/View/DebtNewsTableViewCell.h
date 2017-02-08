//
//  DebtNewsTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/2/26.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebtNewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *debtUserLab;
@property (weak, nonatomic) IBOutlet UILabel *debtHouseLab;
@property (weak, nonatomic) IBOutlet UILabel *debtCarLab;
@property (weak, nonatomic) IBOutlet UILabel *debtAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *debtRateLab;
@property (weak, nonatomic) IBOutlet UILabel *debtUseLab;

@property (nonatomic,strong)NSDictionary *debtDic;
@property (nonatomic,strong)NSDictionary *projectDic;
@end
