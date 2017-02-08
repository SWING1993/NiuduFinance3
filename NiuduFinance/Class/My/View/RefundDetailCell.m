//
//  RefundDetailCell.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/9.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "RefundDetailCell.h"
@interface RefundDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;// 已还 待还  //4a77a5  & f5635d

@end
@implementation RefundDetailCell

- (void)awakeFromNib {

}

- (void)setRefundDetailsDic:(NSDictionary *)refundDetailsDic
{
    _refundDetailsDic = refundDetailsDic;
    
    _dateLabel.text = [_refundDetailsDic objectForKey:@"DueDate"];
    
    _amountLabel.text = [NSString stringWithFormat:@"%.2f",[[_refundDetailsDic objectForKey:@"OwingAmount"] floatValue]];

    if ([[_refundDetailsDic objectForKey:@"Status"] isEqual:@"准时还款"]) {
        [_stateLabel setTextColor:[UIColor colorWithHexString:@"#4a77a5"]];
    }
    _stateLabel.text = [_refundDetailsDic objectForKey:@"Status"];
}

@end
