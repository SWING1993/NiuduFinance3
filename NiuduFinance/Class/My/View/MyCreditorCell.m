//
//  MyCreditorCell.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/10.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MyCreditorCell.h"
#import "NetWorkingUtil.h"

@interface MyCreditorCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

// 待收金额
@property (weak, nonatomic) IBOutlet UILabel *unRefundMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *unRefundTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end
@implementation MyCreditorCell

- (void)awakeFromNib {
    // Initialization code
    _creditorInvestButton.layer.borderWidth = 1.0;
    _creditorInvestButton.layer.borderColor = [UIColor colorWithHexString:@"f5635d"].CGColor;
}

#pragma mark - Setter
- (void)setCreditorState:(CreditorState)creditorState
{
    _creditorState = creditorState;
    /**
     *  分三种
     creditorInvestButton;// 转让 撤回  unRefundView hidee
     volumeTitleLabelLeftConstraint
     下期收款： 下期还款日：
     剩余本息： 下期还款日：
     剩余本金：  转让价格：
     */
    NSString *buttomLeft;
    NSString *buttomRight;
    NSString *creditorInvestButtonTitle;
    CGFloat constant;
    BOOL unRefundViewHidden;
    switch (_creditorState) {
        case CreditorStateRefunding:
            buttomLeft = @"剩余本金：";
            buttomRight = @"转让价格：";
            creditorInvestButtonTitle = @"撤回";
            unRefundViewHidden = YES;
            constant = 88;
            break;
        case CreditorStateCanTransfer:
            buttomLeft = @"剩余本息：";
            buttomRight = @"剩余期数：";
            creditorInvestButtonTitle = @"转让";
            unRefundViewHidden = YES;
            constant = 88;
            break;
        case CreditorStateHistory:
            buttomLeft = @"下期收款：";
            buttomRight = @"认购价格：";
            creditorInvestButtonTitle = @"";
            unRefundViewHidden = NO;
            constant = 53;
            break;
    }
    
    _creditorInvestButton.hidden = !unRefundViewHidden;
    _unRefundMoneyLabel.hidden = unRefundViewHidden;
    _unRefundTitleLabel.hidden = unRefundViewHidden;
    _yuanLabel.hidden = unRefundViewHidden
    ;
    
    _bottomLeftLabel.text = buttomLeft;
    _bottomRightLabel.text = buttomRight;
    [_creditorInvestButton setTitle:creditorInvestButtonTitle forState:UIControlStateNormal];
}

#pragma mark - Public
- (void)creditorState:(CreditorState)state model:(NSDictionary *)modelDic
{
    [self setCreditorState:state];
    
    switch (_creditorState) {
        case CreditorStateCanTransfer:
            
            [NetWorkingUtil setImage:_iconImageView url:[modelDic objectForKey:@"IconUrl"] defaultIconName:nil];
            _nameLabel.text = [modelDic objectForKey:@"Title"];
            _yearRateLabel.text = [NSString stringWithFormat:@"%.2f",[[modelDic objectForKey:@"Rate"] floatValue]];
            
            _volumeLabel.text = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"OwingNumber"]];

            _bottomLeftLabel.text = [NSString stringWithFormat:@"剩余本息：%@",[modelDic objectForKey:@"ReceivableAmount"]];
            _bottomLeftLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            if (SCREEN_HEIGHT == 480 || SCREEN_HEIGHT == 568) {
                _bottomLeftLabel.font = [UIFont systemFontOfSize:10];
                _bottomRightLabel.font = [UIFont systemFontOfSize:10];
            }else{
                
                _bottomLeftLabel.font = [UIFont systemFontOfSize:12];
                _bottomRightLabel.font = [UIFont systemFontOfSize:12];
            }
            
            _bottomLeftLabel.textAlignment = UITextAlignmentLeft;
            _bottomRightLabel.text = [NSString stringWithFormat:@"下期还款日：%@",[modelDic objectForKey:@"DueDate"]];
            _bottomRightLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            _statusLabel.textColor = [UIColor whiteColor];
//            _bottomRightLabel.font = [UIFont systemFontOfSize:12];
            _creditorInvestButton.userInteractionEnabled = YES;
            break;
        case CreditorStateRefunding:
            
            [NetWorkingUtil setImage:_iconImageView url:[modelDic objectForKey:@"IconUrl"] defaultIconName:nil];
            _nameLabel.text = [modelDic objectForKey:@"Title"];
            _yearRateLabel.text = [NSString stringWithFormat:@"%.2f",[[modelDic objectForKey:@"Rate"] floatValue]];
            _volumeLabel.text = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"OwingNumber"]];
            _bottomLeftLabel.text = [NSString stringWithFormat:@"剩余本金：%@",[modelDic objectForKey:@"ReceivablePrincipal"]];
            _bottomLeftLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            _bottomLeftLabel.textAlignment = UITextAlignmentLeft;
            _bottomRightLabel.text = [NSString stringWithFormat:@"转让价格：%@",[modelDic objectForKey:@"PriceForSale"]];
            _bottomRightLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            
            if (SCREEN_HEIGHT == 480 || SCREEN_HEIGHT == 568) {
                _bottomLeftLabel.font = [UIFont systemFontOfSize:11];
                _bottomRightLabel.font = [UIFont systemFontOfSize:11];
            }else{
                
                _bottomLeftLabel.font = [UIFont systemFontOfSize:12];
                _bottomRightLabel.font = [UIFont systemFontOfSize:12];
            }
            
            if ([[modelDic objectForKey:@"Auditstatusid"] integerValue ] == 1) {
                
                _creditorInvestButton.userInteractionEnabled = YES;
                [_creditorInvestButton setTitle:@"撤回" forState:UIControlStateNormal];
                _statusLabel.text = @"审核中";
                _statusLabel.font = [UIFont systemFontOfSize:14];
                _statusLabel.textColor = NaviColor;
                
            }else{
                
             _creditorInvestButton.userInteractionEnabled = NO;
                [_creditorInvestButton setTitle:@"转让中" forState:UIControlStateNormal];
                _statusLabel.textColor = [UIColor whiteColor];
            }
            
            break;
        case CreditorStateHistory:
            
            [NetWorkingUtil setImage:_iconImageView url:[modelDic objectForKey:@"IconUrl"] defaultIconName:nil];
            _nameLabel.text = [modelDic objectForKey:@"Title"];
            _yearRateLabel.text = [NSString stringWithFormat:@"%.2f",[[modelDic objectForKey:@"Rate"] floatValue]];
            _volumeLabel.text = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"OwingNumber"]];
            _unRefundMoneyLabel.text = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"SumReceivableAmount"]];
            
            _bottomLeftLabel.text = @"协议";
            
            
            
            _bottomLeftLabel.textAlignment = UITextAlignmentCenter;
            _bottomLeftLabel.textColor = [UIColor colorWithRed:0.19f green:0.59f blue:0.98f alpha:1.00f];
            
            _bottomRightLabel.text = [NSString stringWithFormat:@"认购价格：%.2f",[[modelDic objectForKey:@"PriceForSale"] floatValue]];
            _statusLabel.textColor = [UIColor whiteColor];
            _bottomRightLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            
            if (SCREEN_HEIGHT == 480 || SCREEN_HEIGHT == 568) {
                _bottomLeftLabel.font = [UIFont systemFontOfSize:11];
                _bottomRightLabel.font = [UIFont systemFontOfSize:11];
            }else{
                
                _bottomLeftLabel.font = [UIFont systemFontOfSize:12];
                _bottomRightLabel.font = [UIFont systemFontOfSize:12];
            }
            break;
            
    }
}

#pragma mark - Action
- (IBAction)creditorInvestClike
{
    if([self.delegate respondsToSelector:@selector(creditorInvestAction:)])
    {
        [self.delegate creditorInvestAction:self];
    }
}

@end
