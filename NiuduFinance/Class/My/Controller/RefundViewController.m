//
//  RefundViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/9.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "RefundViewController.h"

@interface RefundViewController ()
@property (weak, nonatomic) IBOutlet UILabel *refundAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation RefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"还款确认";
    _commitBtn.layer.cornerRadius = 5.0f;
    [self backBarItem];
}

- (void)setBalance:(NSString *)balance
{
    _balance = balance;
    
    _balanceLabel.text = [NSString stringWithFormat:@"%@元",_balance];
}

- (void)setRefundDic:(NSDictionary *)refundDic
{
    _refundDic = refundDic;
   
    _refundAmountLabel.text = [NSString stringWithFormat:@"%.2f元",[[_refundDic objectForKey:@"OwingAmount"] floatValue]];
    _dateLabel.text = [_refundDic objectForKey:@"DueDate"];
}

- (void)setRefundProjectDic:(NSDictionary *)refundProjectDic
{
    _refundProjectDic = refundProjectDic;
}

- (IBAction)confirmAction {

    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    _commitBtn.userInteractionEnabled = NO;
    [self.httpUtil requestDic4MethodName:@"account/postrepayment" parameters:@{@"ProjectId":[_refundProjectDic objectForKey:@"ProjectID"]} result:^(NSDictionary *dic, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
            [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
            _commitBtn.userInteractionEnabled = YES;
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
            _commitBtn.userInteractionEnabled = YES;
        }
    }];
}

- (void)delayMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gotoRechargeAction {
    [MBProgressHUD showMessag:@"敬请期待..." toView:self.view];
}


@end
