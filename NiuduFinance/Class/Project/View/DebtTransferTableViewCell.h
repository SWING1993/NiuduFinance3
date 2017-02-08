//
//  DebtTransferTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/2/26.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleAnimationView;
@class DebtModel;
@interface DebtTransferTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *debtImageView;
//中建标题
@property (weak, nonatomic) IBOutlet UILabel *debtTitleLab;
//受让人年化利率
@property (weak, nonatomic) IBOutlet UILabel *debtRateLab;
//转让价格
@property (weak, nonatomic) IBOutlet UILabel *debtAmountLab;
//万元
@property (weak, nonatomic) IBOutlet UILabel *debtAmountTypeLab;
//立即购买
@property (weak, nonatomic) IBOutlet UIButton *debtStateBtn;
//剩余份数
@property (weak, nonatomic) IBOutlet UILabel *surplusNum;

@property (nonatomic,strong)DebtModel *debtModel;

@end
