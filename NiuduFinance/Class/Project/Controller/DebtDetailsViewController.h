//
//  DebtDetailsViewController.h
//  NiuduFinance
//
//  Created by liuyong on 16/2/26.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "BaseViewController.h"
@class DebtDetailsTableViewCell;
@interface DebtDetailsViewController : BaseViewController

@property (nonatomic,assign)int debtID;

- (void)projectTableViewCell:(DebtDetailsTableViewCell *)cell supportProject:(id)project;
@end
