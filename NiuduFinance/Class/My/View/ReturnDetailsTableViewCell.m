//
//  ReturnDetailsTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/16.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ReturnDetailsTableViewCell.h"

@implementation ReturnDetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setReturnDetailsDic:(NSDictionary *)returnDetailsDic
{
    _returnDetailsDic = returnDetailsDic;
    
    _principalLab.text = [NSString stringWithFormat:@"当期本金:%.2f元",[[_returnDetailsDic objectForKey:@"Principal"] floatValue]];
    _interestLab.text = [NSString stringWithFormat:@"当期利息:%.2f元",[[_returnDetailsDic objectForKey:@"Interest"] floatValue]];
    if ([[_returnDetailsDic objectForKey:@"StatusId"] isEqual:@"待收"]) {
        [_dataStateLab setTextColor:NaviColor];
    }
    //
    _dataStateLab.text = [NSString stringWithFormat:@"%@",[_returnDetailsDic objectForKey:@"StatusId"]];
    //时间
    _dateLabel.text = [NSString stringWithFormat:@"还款日期:%@",[_returnDetailsDic objectForKey:@"DueDate"]];
    //期数
    _periodLab.text = [NSString stringWithFormat:@"%@/%@期",[_returnDetailsDic objectForKey:@"OrderId"],[_returnDetailsDic objectForKey:@"SumOrder"]];
    
    
    
    [self.contentView addSubview:_shadowView];
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
    [self.contentView addSubview:_periodLab];
    [_periodLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shadowView.mas_bottom).with.offset(18);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_periodLab.mas_bottom).with.offset(12);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(2);
    }];
    
    [self.contentView addSubview:_interestLab];
    [_interestLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).with.offset(16);
        make.left.mas_equalTo(22);
        make.height.mas_equalTo(14);
    }];
    
    [self.contentView addSubview:_principalLab];
    [_principalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_interestLab.mas_bottom).with.offset(9);
        make.left.mas_equalTo(22);
        make.height.mas_equalTo(14);
    }];
    
    [self.contentView addSubview:_dataStatLab];
    [_dataStatLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_interestLab.mas_top).with.offset(0);
        make.height.mas_equalTo(14);
        make.right.mas_equalTo(0);
        make.centerX.mas_equalTo(89);
    }];
    
    [self.contentView addSubview:_dataStateLab];
    [_dataStateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_interestLab.mas_top).with.offset(0);
        make.left.equalTo(_dataStatLab.mas_left).with.offset(65);
        make.height.mas_equalTo(14);
        make.right.mas_equalTo(0);
    }];
    
    [self.contentView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_principalLab.mas_top).with.offset(0);
//        make.left.mas_equalTo(180);
        make.height.mas_equalTo(14);
        make.right.mas_equalTo(0);
        make.centerX.mas_equalTo(89);


    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
