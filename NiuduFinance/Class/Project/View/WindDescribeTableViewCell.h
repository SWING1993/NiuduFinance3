//
//  WindDescribeTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/2/29.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WindDescribeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *windDescribeLab;

@property (nonatomic,strong)NSString *windDescribeStr;

@end
