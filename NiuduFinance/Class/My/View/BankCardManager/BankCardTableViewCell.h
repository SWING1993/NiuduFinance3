//
//  BankCardTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/4/6.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bankCardImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNameLab;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNumberLab;

@end
