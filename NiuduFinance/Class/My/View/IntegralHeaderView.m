//
//  IntegralHeaderView.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/18.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "IntegralHeaderView.h"
#import "Masonry.h"
#define FONTSize [UIFont systemFontOfSize:14];

@interface IntegralHeaderView()

@property (nonatomic,strong) UIButton *registerButton;

@property (nonatomic,strong) UILabel *canUserIntegraLabel;

@property (nonatomic,strong) UILabel *integrateNumLabel;

@property (nonatomic,strong) UILabel *monthLabel;

@property (nonatomic,strong) UILabel *monthNumLabel;

@property (nonatomic,strong) UILabel *sumIntegrateLabel;

@property (nonatomic,strong) UILabel *sumIntegrateNumLabel;

@end

@implementation IntegralHeaderView


- (instancetype)init
{
    if (self=[super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    [self loadView];
    
}
- (void)loadView{

    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _registerButton.layer.cornerRadius = 30.0f;
    _registerButton.autoresizingMask = YES;
    [_registerButton setTitle:@"签到" forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_registerButton setTintColor:[UIColor whiteColor]];
    
    if ([[_dic objectForKey:@"IsCansign"] integerValue] == 0) {
        _registerButton.userInteractionEnabled = NO;
        
        [_registerButton setTitle:@"已签" forState:UIControlStateNormal];
        _registerButton.backgroundColor = BlackCCCCCC;
    }else{
        _registerButton.backgroundColor = NaviColor;
        [_registerButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        _registerButton.userInteractionEnabled = YES;
    }
    
    [self addSubview:_registerButton];
    
    _canUserIntegraLabel = [[UILabel alloc] init];
    _canUserIntegraLabel.text = @"可用积分:";
    [_canUserIntegraLabel setTextColor:NaviColor];
    _canUserIntegraLabel.font = FONTSize;
    [self addSubview:_canUserIntegraLabel];
    
    _integrateNumLabel = [[UILabel alloc] init];
    if (IsStrEmpty([[_dic objectForKey:@"Integral"] stringValue])) {
      _integrateNumLabel.text = @"";
    }else{
        _integrateNumLabel.text = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"Integral"]];
    }
    
    _integrateNumLabel.font = FONTSize;
    [_integrateNumLabel setTextColor:NaviColor];
    [self addSubview:_integrateNumLabel];
    
    _monthLabel = [[UILabel alloc]init];
    _monthLabel.text = @"本月获得:";
    _monthLabel.font = FONTSize;
    [_monthLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
    [self addSubview:_monthLabel];
    
    _monthNumLabel = [[UILabel alloc] init];
    _monthNumLabel.text = [NSString stringWithFormat:@"%@",IsStrEmpty([[_dic objectForKey:@"MonthIntegral"] stringValue])?@"":[_dic objectForKey:@"MonthIntegral"]];
    _monthNumLabel.font = FONTSize;
    [_monthNumLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
    [self addSubview:_monthNumLabel];
    
    _sumIntegrateLabel = [[UILabel alloc] init];
    _sumIntegrateLabel.text = @"累计获得:";
    _sumIntegrateLabel.font = FONTSize;
    _sumIntegrateLabel.textAlignment = NSTextAlignmentLeft;
    [_sumIntegrateLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
    [self addSubview:_sumIntegrateLabel];
    
    _sumIntegrateNumLabel = [[UILabel alloc] init];
    _sumIntegrateNumLabel.text = [NSString stringWithFormat:@"%@",IsStrEmpty([[_dic objectForKey:@"TotalIntegral"] stringValue])?@"":[_dic objectForKey:@"TotalIntegral"]];
    _sumIntegrateNumLabel.font = FONTSize;
    [_sumIntegrateNumLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
    _sumIntegrateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_sumIntegrateNumLabel];
    
    
    //添加约束
    __weak typeof (self)weakSelf = self;
    
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(weakSelf).offset(-10);
        make.centerX.equalTo(weakSelf);
        make.height.width.mas_equalTo(60);
    }];
    
    [_canUserIntegraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(8);
        make.bottom.equalTo(weakSelf).offset(-5);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(35);
        
    }];
    
    [_integrateNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_canUserIntegraLabel);
        make.left.equalTo(_canUserIntegraLabel.mas_right).offset(1);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(35);
    }];
    
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf).offset(-10);
        make.top.bottom.equalTo(_canUserIntegraLabel);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(35);
    }];
    
    [_monthNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_monthLabel);
        make.left.equalTo(_monthLabel.mas_right).offset(0);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(35);
    }];
    
    [_sumIntegrateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_monthLabel);
        make.right.equalTo(_sumIntegrateNumLabel.mas_left).offset(1);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(35);
        
    }];
    [_sumIntegrateNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_monthLabel);
        make.right.equalTo(weakSelf).offset(-10);
//        make.width.mas_equalTo(65);
        make.height.mas_equalTo(35);
    }];
    
    
}




- (void)buttonClick{

    //签到
    _registerButton.userInteractionEnabled = NO;
    [_registerButton setTitle:@"已签" forState:UIControlStateNormal];
    
    _registerButton.backgroundColor = BlackCCCCCC;
    NSLog(@"签到成功");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getIntegralNoti" object:nil];
    
}

@end
