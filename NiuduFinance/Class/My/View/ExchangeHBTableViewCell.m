//
//  ExchangeHBTableViewCell.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/18.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ExchangeHBTableViewCell.h"

@interface ExchangeHBTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UIView *imgView;


@end

@implementation ExchangeHBTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _exchangeBtn.layer.cornerRadius = 10.0f;
    _exchangeBtn.autoresizingMask = YES;
    

    _imgView.backgroundColor = BlackCCCCCC;
    self.backgroundColor = BlackCCCCCC;
    
}


- (void)setHongbaoDic:(NSDictionary *)hongbaoDic
{
    _hongbaoDic = hongbaoDic;
    
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",[hongbaoDic objectForKey:@"BounsValue"]];
    self.integralLabel.text = [NSString stringWithFormat:@"%@积分兑换",[NSString stringWithFormat:@"%@",[hongbaoDic objectForKey:@"Integral"]]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
