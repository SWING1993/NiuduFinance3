//
//  FundAccountTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/3/14.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FundAccountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fundAccountLab;
@property (weak, nonatomic) IBOutlet UILabel *fundAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *fundDataLab;
@property (weak, nonatomic) IBOutlet UIImageView *funImage;

@property (nonatomic,strong)NSDictionary *fundAccountDic;
@end
