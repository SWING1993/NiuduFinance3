//
//  FundManagerCell.h
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/4.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,FundManagerCellValueStyle)
{
    FundManagerCellValueStyleBule,
    FundManagerCellValueStyleGreen,
    FundManagerCellValueStyleBlack
};

@interface FundManagerCell : UITableViewCell
- (void)setupTitle:(NSString *)title detailText:(NSString *)detailText valueStyle:(FundManagerCellValueStyle)valueStyle;

@end
