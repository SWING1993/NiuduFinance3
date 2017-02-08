//
//  DebtTransferTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/26.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "DebtTransferTableViewCell.h"
#import "NetWorkingUtil.h"
#import "DebtModel.h"
#import "User.h"

@implementation DebtTransferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _debtStateBtn.layer.borderWidth = 1.0;
    _debtStateBtn.layer.cornerRadius = 2.0f;
    _debtStateBtn.layer.masksToBounds = YES;
    
}

- (void)setDebtModel:(DebtModel *)debtModel
{
    _debtModel = debtModel;
    
    [NetWorkingUtil setImage:_debtImageView url:_debtModel.iconUrl defaultIconName:nil];
    _debtTitleLab.text = _debtModel.title;
    _debtRateLab.text = [NSString stringWithFormat:@"%@",_debtModel.rate];
    
    if (_debtModel.priceForSaleTypeId == 1) {
        _debtAmountLab.text = [NSString stringWithFormat:@"%@",_debtModel.priceForSale];
        _debtAmountTypeLab.text = @"元";
    }else{
        _debtAmountLab.text = [NSString stringWithFormat:@"%@",_debtModel.priceForSale];
    }
    
    _surplusNum.text = [NSString stringWithFormat:@"剩%d份",_debtModel.surplusNum];
    
    if (_debtModel.sellerUserId == [User shareUser].userId) {
        [_debtStateBtn setTitle:@"我的债权" forState:UIControlStateNormal];
        _debtStateBtn.userInteractionEnabled = NO;
        _debtStateBtn.backgroundColor = BlackCCCCCC;
    }else{
        
        if (_debtModel.statusId == 1) {
            [_debtStateBtn setTitle:@"马上购买" forState:UIControlStateNormal];
            _debtStateBtn.userInteractionEnabled = YES;
            _debtStateBtn.backgroundColor = NaviColor;
        }else{
            [_debtStateBtn setTitle:@"交易结束" forState:UIControlStateNormal];
            _debtStateBtn.userInteractionEnabled = NO;
            _debtStateBtn.backgroundColor = BlackCCCCCC;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
