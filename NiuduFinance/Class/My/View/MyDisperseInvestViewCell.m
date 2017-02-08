//
//  MyDisperseInvestViewCell.m
//  NiuduFinance
//
//  Created by 123 on 17/1/20.
//  Copyright © 2017年 liuyong. All rights reserved.
//

#import "MyDisperseInvestViewCell.h"

@interface MyDisperseInvestViewCell()
//标题
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//未收本息
@property (weak, nonatomic) IBOutlet UILabel *weiInterestLabel;
//年化收益
@property (weak, nonatomic) IBOutlet UILabel *shouyiLabel;
//已收本息
@property (weak, nonatomic) IBOutlet UILabel *yiBenXiLabel;
//预期赚取
@property (weak, nonatomic) IBOutlet UILabel *yuQiLabel;
//投资本金
@property (weak, nonatomic) IBOutlet UILabel *benJinLabel;
//回款详情
@property (weak, nonatomic) IBOutlet UIButton *detailsLabel;

@end


@implementation MyDisperseInvestViewCell

- (void)setMyDisperseInvestStat:(MyDisperseInvestStat)myDisperseInvestState
{
    switch (myDisperseInvestState)
    {
        case MyDisperseInvestStatBidding:
            break;
        case MyDisperseInvestStatRufunding:
            break;
        case MyDisperseInvestStatHistory:
            break;
    }
}


-(void)creditorState:(MyDisperseInvestStat)state model:(NSDictionary *)modeIDic
{
    [self setMyDisperseInvestStat:state];
    
    
    NSString *rateStr = [[modeIDic objectForKey:@"Rate"] stringValue];
    
    switch (state)
    {
        case MyDisperseInvestStatBidding:
            _nameLabel.text = [modeIDic objectForKey:@"Title"] ;
            if ([rateStr rangeOfString:@"."].location != NSNotFound) {
                _shouyiLabel.text = [NSString stringWithFormat:@"年化收益：%.2f",[[modeIDic objectForKey:@"Rate"]floatValue]];
            }else{
                _shouyiLabel.text = [NSString stringWithFormat:@"年化收益：%@ ",[modeIDic objectForKey:@"Rate"]];
                
            }
            _xieYiBtn.titleLabel.text=@"协议";
            _yuQiLabel.text = [NSString stringWithFormat:@"预期赚取：%.2f",[[modeIDic objectForKey:@"ReceivableAmount"] floatValue]];
            _yiBenXiLabel.text = [NSString stringWithFormat:@"已收本息：%@",[modeIDic objectForKey:@"SumReceivableAmount"]];
            _weiInterestLabel.text = [NSString stringWithFormat:@"%@",[modeIDic objectForKey:@"OwingAmount"]];
            _benJinLabel.text = [NSString stringWithFormat:@"投资本金：%@",[modeIDic objectForKey:@"Amount"]];
            break;
        case MyDisperseInvestStatRufunding:
            _nameLabel.text = [modeIDic objectForKey:@"Title"] ;
            if ([rateStr rangeOfString:@"."].location != NSNotFound) {
                _shouyiLabel.text = [NSString stringWithFormat:@"年化收益：%.2f",[[modeIDic objectForKey:@"Rate"]floatValue]];
            }else{
                _shouyiLabel.text = [NSString stringWithFormat:@"年化收益：%@",[modeIDic objectForKey:@"Rate"]];
            }
            _xieYiBtn.titleLabel.text=@"协议";
            _yuQiLabel.text = [NSString stringWithFormat:@"预期赚取：%.2f",[[modeIDic objectForKey:@"ReceivableAmount"] floatValue]];
            _yiBenXiLabel.text = [NSString stringWithFormat:@"已收本息：%@",[modeIDic objectForKey:@"SumReceivableAmount"]];
            _weiInterestLabel.text = [NSString stringWithFormat:@"%@",[modeIDic objectForKey:@"OwingAmount"]];
            _benJinLabel.text = [NSString stringWithFormat:@"投资本金：%@",[modeIDic objectForKey:@"Amount"]];
            break;
        case MyDisperseInvestStatHistory:
            _nameLabel.text = [modeIDic objectForKey:@"Title"] ;
            if ([rateStr rangeOfString:@"."].location != NSNotFound) {
                _shouyiLabel.text = [NSString stringWithFormat:@"年化收益：%.2f",[[modeIDic objectForKey:@"Rate"]floatValue]];
            }else{
                _shouyiLabel.text = [NSString stringWithFormat:@"年化收益：%@",[modeIDic objectForKey:@"Rate"]];
            }
            _xieYiBtn.titleLabel.text=@"协议";
            _yuQiLabel.text = [NSString stringWithFormat:@"预期赚取：%.2f",[[modeIDic objectForKey:@"ReceivableAmount"] floatValue]];
            _yiBenXiLabel.text = [NSString stringWithFormat:@"已收本息：%@",[modeIDic objectForKey:@"SumReceivableAmount"]];
            _weiInterestLabel.text = [NSString stringWithFormat:@"%@",[modeIDic objectForKey:@"OwingAmount"]];
            _benJinLabel.text = [NSString stringWithFormat:@"投资本金：%@",[modeIDic objectForKey:@"Amount"]];
            break;
    }
    

    
}


@end
