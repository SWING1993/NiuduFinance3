//
//  ReturnDetailsTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/3/16.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReturnDetailsTableViewCell : UITableViewCell
//当期本金
@property (weak, nonatomic) IBOutlet UILabel *principalLab;
//当期利息
@property (weak, nonatomic) IBOutlet UILabel *interestLab;
//还款状态
@property (weak, nonatomic) IBOutlet UILabel *dataStateLab;
//还款状态标题
@property (weak, nonatomic) IBOutlet UILabel *dataStatLab;
//还款期数
@property (weak, nonatomic) IBOutlet UILabel *periodLab;
//还款日期
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//顶部阴影
@property (weak, nonatomic) IBOutlet UIView *shadowView;
//分割线
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic,strong)NSDictionary *returnDetailsDic;
@end
