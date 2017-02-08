//
//  ExchangeHBTableViewCell.h
//  NiuduFinance
//
//  Created by andrewliu on 16/9/18.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeHBTableViewCell : UITableViewCell


@property (nonatomic,strong) NSDictionary *hongbaoDic;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;

@end
