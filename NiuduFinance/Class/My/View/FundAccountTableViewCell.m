//
//  FundAccountTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/14.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "FundAccountTableViewCell.h"

@implementation FundAccountTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setFundAccountDic:(NSDictionary *)fundAccountDic
{
    _fundAccountDic = fundAccountDic;
    
    _fundAccountLab.text = [_fundAccountDic objectForKey:@"EventType"];
    _fundAmountLab.text = [_fundAccountDic objectForKey:@"Amount"];
    if ([[_fundAccountDic objectForKey:@"Type"] integerValue] == 0) {
//        [_fundAmountLab setTextColor:[UIColor colorWithHexString:@"#FF7101"]];
        [_funImage setImage:[UIImage imageNamed:@"dong.png"]];
    }else if([[_fundAccountDic objectForKey:@"Type"] integerValue] == 1){
//        [_fundAmountLab setTextColor:[UIColor colorWithHexString:@"#51B162"]];
        [_funImage setImage:[UIImage imageNamed:@"shou.png"]];
    }else{
//        [_funImage setImage:[UIImage imageNamed:@"zhi.png"]];

    }

    _fundDataLab.text = [_fundAccountDic objectForKey:@"CreationDate"];
    _fundDataLab.numberOfLines = 0;
    NSLog(@"++++++--------%@",_fundDataLab.text);

    
   
    [self.contentView addSubview:_fundDataLab];
    [_fundDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.contentView addSubview:_funImage];
    [_funImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.left.mas_equalTo(74);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    
    [self.contentView addSubview:_fundAmountLab];
    [_fundAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.left.equalTo(_funImage.mas_right).with.offset(24);
        make.height.mas_equalTo(15);
    }];
    
    [self.contentView addSubview:_fundAccountLab];
    [_fundAccountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fundAmountLab.mas_bottom).with.offset(13);
        make.left.equalTo(_funImage.mas_right).with.offset(24);
        make.height.mas_equalTo(13);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
