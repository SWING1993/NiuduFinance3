//
//  MyDisperseInvestCell.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/11.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MyDisperseInvestCell.h"
#import "CircleAnimationView.h"
#import "NetWorkingUtil.h"
#import "ProjectProgressView.h"
#import "NSString+Adding.h"

@interface MyDisperseInvestCell()

/**
 *  共同部分
 */
// 头部
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 左边
//年利率标题
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
//年利率
@property (weak, nonatomic) IBOutlet UILabel *leftValueLabel;
//百分号
@property (weak, nonatomic) IBOutlet UILabel *leftValueUnitLabel;

// 中间
//借款期限
@property (weak, nonatomic) IBOutlet UILabel *middleTitleLabel;
//几期
@property (weak, nonatomic) IBOutlet UILabel *middleValueLabel;
//期标题
@property (weak, nonatomic) IBOutlet UILabel *middleValueUnitLabel;

// 底部
@property (weak, nonatomic) IBOutlet UIView *bottomView;
//投资金额
@property (weak, nonatomic) IBOutlet UILabel *bottomRIghtLabel;

/**
 *  其他部分
 */

// 投标中
//借款失败
@property (weak, nonatomic) IBOutlet UIView *progressView;
//底部分割线
@property (weak, nonatomic) IBOutlet ProjectProgressView *lineProgressView;

// 回款中
//回款详情button
@property (weak, nonatomic) IBOutlet UIButton *rightArrowButton;

// 投资记录
//投资金额
@property (weak, nonatomic) IBOutlet UILabel *investMoneyLabel;
//上面分割线
@property (weak, nonatomic) IBOutlet UIView *topLineView;
//图片
@property (weak, nonatomic) IBOutlet UIImageView *investStateImageView;


//@property (nonatomic,strong) UIButton *button;
@end

@implementation MyDisperseInvestCell

#pragma mark - Setter
- (void)setMyDisperseInvestState:(MyDisperseInvestState)myDisperseInvestState
{
    _myDisperseInvestState = myDisperseInvestState;
//    _button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
//    
//    
//    _button.layer.borderWidth = 1.0;
//    _button.layer.cornerRadius = 2.0f;
//    _button.layer.masksToBounds = YES;
//    
//    _progressView.layer.cornerRadius = 2.0f;
//    _progressView.layer.masksToBounds = YES;
    
    BOOL investHistoryTopHidden;
    NSString *leftTitleText;
    NSString *middleTitleText;
    switch (_myDisperseInvestState)
    {
    //已结算
        case MyDisperseInvestStateBidding:
            investHistoryTopHidden = YES;
            leftTitleText = @"年化利率";
            middleTitleText = @"已收本息";
            _rightArrowButton.hidden = NO;
            _investStateImageView.hidden = YES;
            _progressView.hidden = NO;
            _bottomView.hidden = NO;
            break;
        //未结算
        case MyDisperseInvestStateRufunding:
            investHistoryTopHidden = YES;
            leftTitleText = @"年化利率";
            middleTitleText = @"待收本息";
            _rightArrowButton.hidden = NO;
            _investStateImageView.hidden = YES;
            _progressView.hidden = YES;
            _bottomView.hidden = NO;
            break;
        case MyDisperseInvestStateHistory:
            investHistoryTopHidden = NO;
            leftTitleText = @"年化利率";
            middleTitleText = @"借款期限";
            _rightArrowButton.hidden = YES;
            _investStateImageView.hidden = NO;
            _progressView.hidden = YES;
            _bottomView.hidden = YES;
            break;
    }
    
    _topLineView.hidden = investHistoryTopHidden;
    _investMoneyLabel.hidden = investHistoryTopHidden;
    
    _leftTitleLabel.text = leftTitleText;
    _leftValueUnitLabel.text = [leftTitleText isEqualToString:@"年化利率"]?@"%":@"期";
    
    _middleTitleLabel.text = middleTitleText;
    
    if ([middleTitleText isEqualToString:@"借款期限"]) {
        _middleValueUnitLabel.text = @"个月";
    }else{
    
        _middleValueUnitLabel.text = @"元";
    }
//    _middleValueUnitLabel.text = [middleTitleText isEqualToString:@"借款期限"]?@"个月":@"元";
    
}

#pragma mark - Public
- (void)creditorState:(MyDisperseInvestState)state model:(NSDictionary *)modelDic
{
    [self setMyDisperseInvestState:state];
    NSString *rateStr = [[modelDic objectForKey:@"Rate"] stringValue];
    switch (state)
    {
            //已结算
        case MyDisperseInvestStateBidding:
            
            [NetWorkingUtil setImage:_iconImageView url:[modelDic objectForKey:@"IconUrl"] defaultIconName:nil];
            _nameLabel.text = [modelDic objectForKey:@"Title"] ;
            
            if ([rateStr rangeOfString:@"."].location != NSNotFound) {
                
                _leftValueLabel.text = [NSString stringWithFormat:@"%.2f",[[modelDic objectForKey:@"Rate"] floatValue]];
                
            }else{
                _leftValueLabel.text = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"Rate"]];
            }
            
            _middleValueLabel.text = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"SumReceivableAmount"]];
            
       
            _leftValueUnitLabel.text = @"%";
//            _progressView.percentStr = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"Progress"]];
            
            
            
            
            _lineProgressView.progressValue = [[NSString stringWithFormat:@"%@",[modelDic objectForKey:@"Progress"]] integerValue];
            _lineProgressView.isShowProgressText = NO;
            
            
            _bottomLeftLabel.text = @"协议";
            
            _bottomLeftLabel.textAlignment = UITextAlignmentCenter;
            _bottomLeftLabel.textColor = [UIColor colorWithRed:0.19f green:0.59f blue:0.98f alpha:1.00f];
            _bottomLeftLabel.font = [UIFont systemFontOfSize:13];
            
            _bottomRIghtLabel.text = [NSString stringWithFormat:@"累计赚取：%.2f",[[modelDic objectForKey:@"ReceivableAmount"] floatValue]];
//            _bottomRIghtLabel.text = [NSString stringWithFormat:@"累计赚取：%@",[modelDic objectForKey:@"SumReceivableAmount"] ];
            ;
            if (SCREEN_HEIGHT == 480 || SCREEN_HEIGHT == 568) {
                
                _bottomLeftLabel.font = [UIFont systemFontOfSize:11];
                _bottomRIghtLabel.font = [UIFont systemFontOfSize:11];
                
            }else{
                _bottomLeftLabel.font = [UIFont systemFontOfSize:12];
                _bottomRIghtLabel.font = [UIFont systemFontOfSize:12];
            }
            
            _bottomRIghtLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            
            break;
           //未结算
            
        case MyDisperseInvestStateRufunding:
        {
            [NetWorkingUtil setImage:_iconImageView url:[modelDic objectForKey:@"IconUrl"] defaultIconName:nil];
            _nameLabel.text = [modelDic objectForKey:@"Title"];
            if ([rateStr rangeOfString:@"."].location != NSNotFound) {
                
                _leftValueLabel.text = [NSString stringWithFormat:@"%.2f",[[modelDic objectForKey:@"Rate"] floatValue]];
                
            }else{
                _leftValueLabel.text = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"Rate"]];
            }
            _middleValueLabel.text = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"OwingAmount"]];
//            _bottomLeftLabel.text = [NSString stringWithFormat:@"下期还款：%@元",[modelDic objectForKey:@"ReceivableAmount"]];

            _bottomLeftLabel.text = @"协议";
            _bottomLeftLabel.textAlignment = UITextAlignmentCenter;
            _bottomLeftLabel.textColor = [UIColor colorWithRed:0.19f green:0.59f blue:0.98f alpha:1.00f];
            
            _bottomLeftLabel.font = [UIFont systemFontOfSize:12];
            
            _bottomRIghtLabel.text = [NSString stringWithFormat:@"下期还款日：%@",[modelDic objectForKey:@"DueDate"]];
            _bottomRIghtLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            if (SCREEN_HEIGHT == 480 || SCREEN_HEIGHT == 568) {
                
                _bottomLeftLabel.font = [UIFont systemFontOfSize:10];
                _bottomRIghtLabel.font = [UIFont systemFontOfSize:10];
                
            }else{
                
                _bottomLeftLabel.font = [UIFont systemFontOfSize:12];
                _bottomRIghtLabel.font = [UIFont systemFontOfSize:12];
            }
            
            break;
    }
        case MyDisperseInvestStateHistory:
            
            [NetWorkingUtil setImage:_iconImageView url:[modelDic objectForKey:@"IconUrl"] defaultIconName:nil];
            _nameLabel.text = [modelDic objectForKey:@"Title"];
            
            _investMoneyLabel.text = [NSString stringWithFormat:@"投资金额：%@",[modelDic objectForKey:@"Amount"]];
            
            
            if ([rateStr rangeOfString:@"."].location != NSNotFound) {
                
                _leftValueLabel.text = [NSString stringWithFormat:@"%.2f",[[modelDic objectForKey:@"Rate"] floatValue]];
                
            }else{
                _leftValueLabel.text = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"Rate"]];
            }
            
            
            _middleValueLabel.text = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"LoanPeriod"]];
            if ([[modelDic objectForKey:@"PeriodTypeId"] integerValue] == 1) {
                _middleValueUnitLabel.text = @"天";
            }else if ([[modelDic objectForKey:@"PeriodTypeId"] integerValue] == 2){
                _middleValueUnitLabel.text = @"个月";
            }else if ([[modelDic objectForKey:@"PeriodTypeId"] integerValue] == 3){
                _middleValueUnitLabel.text = @"年";
            }
            
//            else if([[modelDic objectForKey:@"StatusId"] integerValue] == 0){
//                _investStateImageView.image = [UIImage imageNamed:@"refund_fail"];
//            }
            
            if ([[modelDic objectForKey:@"StatusId"] integerValue] == 4) {
                _investStateImageView.image = [UIImage imageNamed:@"refund_success"];
            }else if ([[modelDic objectForKey:@"StatusId"] integerValue] == 3){
                _investStateImageView.image = [UIImage imageNamed:@"refunding"];
            }else if ([[modelDic objectForKey:@"StatusId"] integerValue] == 1){
                _investStateImageView.image = [UIImage imageNamed:@"toubiao"];
            }else if ([[modelDic objectForKey:@"StatusId"] integerValue] == 2){
                _investStateImageView.image = [UIImage imageNamed:@"refund_bided"];
            }else{
                _investStateImageView.image = [UIImage imageNamed:@"refund_fail"];
            }
            
            break;
    }
    
}



#pragma mark - Action
- (IBAction)rightArrowClike
{
    
}

@end
