//
//  InvestRecodeTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/3/1.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InvestRecode;
@interface InvestRecodeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *investUserNameLab;
@property (weak, nonatomic) IBOutlet UILabel *investAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *investBidTimeLab;

@property (nonatomic,strong)InvestRecode *investRecode;

@property (nonatomic,strong)NSDictionary *debtDic;
@end
