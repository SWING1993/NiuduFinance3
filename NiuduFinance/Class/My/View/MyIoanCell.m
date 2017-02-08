//
//  MuyIoanCell.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/9.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MyIoanCell.h"
#import "NetWorkingUtil.h"

@interface MyIoanCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *ioanNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ioanAmountLabel;//借款金额：000
@property (weak, nonatomic) IBOutlet UILabel *yearRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ioanStateImageView;
@property (weak, nonatomic) IBOutlet UILabel *periodTypeLab;


@end

@implementation MyIoanCell

- (void)awakeFromNib {

}

- (void)setIoanState:(IoanState)ioanState
{
    _ioanState = ioanState;
    UIImage *image;
    switch (_ioanState)
    {
        case IoanStatefail:
            image = [UIImage imageNamed:@"refund_fail"];
            break;
        case IoanStateSuccess:
            image = [UIImage imageNamed:@"refund_success"];
            break;
        case IoanStateRefunding:
            image = [UIImage imageNamed:@"refunding"];
            break;
    }
    _ioanStateImageView.image = image;
}

- (void)setState:(NSString *)state
{
    _state = state;
}

- (void)setMyIoanDic:(NSDictionary *)myIoanDic
{
    _myIoanDic = myIoanDic;
    
    @try {
        
        [NetWorkingUtil setImage:_iconImageView url:[_myIoanDic objectForKey:@"IconUrl"] defaultIconName:@"project_trust"];
        _ioanNameLabel.text = [_myIoanDic objectForKey:@"Title"];

    } @catch (NSException *exception) {
        NSLog(@"数据IconUrl为null+%@",[_myIoanDic objectForKey:@"Title"]);
    } @finally {
        
    }
    
    _ioanAmountLabel.text = [NSString stringWithFormat:@"借款金额：%@",[_myIoanDic objectForKey:@"Amount"]];
    _yearRateLabel.text = [NSString stringWithFormat:@"%@",[_myIoanDic objectForKey:@"Rate"]];
    _dateLabel.text = [NSString stringWithFormat:@"%@",[_myIoanDic objectForKey:@"LoanPeriod"]];
    if ([[_myIoanDic objectForKey:@"PeriodTypeId"] integerValue] == 1) {
        _periodTypeLab.text = @"天";
    }else if ([[_myIoanDic objectForKey:@"PeriodTypeId"] integerValue] == 2){
        _periodTypeLab.text = @"个月";
    }else if ([[_myIoanDic objectForKey:@"PeriodTypeId"] integerValue] == 3){
        _periodTypeLab.text = @"年";
    }
    
    if ([_state isEqual:@"还款中"]) {
        _ioanStateImageView.image = [UIImage imageNamed:@"refunding"];
    }else{
        if ([[_myIoanDic objectForKey:@"StatusId"] integerValue] == 4) {
            _ioanStateImageView.image = [UIImage imageNamed:@"refund_success"];
        }else if ([[_myIoanDic objectForKey:@"StatusId"] integerValue] == 3){
            _ioanStateImageView.image = [UIImage imageNamed:@"refunding"];
        }else if ([[_myIoanDic objectForKey:@"StatusId"] integerValue] == 1){
            _ioanStateImageView.image = [UIImage imageNamed:@"toubiao"];
        }else if ([[_myIoanDic objectForKey:@"StatusId"] integerValue] == 2){
            _ioanStateImageView.image = [UIImage imageNamed:@"refund_bided"];
        }else{
            _ioanStateImageView.image = [UIImage imageNamed:@"refund_fail"];
        }
    }
}

@end
