//
//  MyCreditorActionViewControllerBackViewController.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/19.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MyCreditorActionViewControllerBackViewController.h"

@interface MyCreditorActionViewControllerBackViewController ()


@property (weak, nonatomic) IBOutlet UILabel *transferProjectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusPrincipalLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusInterestLabel;
@property (weak, nonatomic) IBOutlet UITextField *transferPriceTextField;
@property (weak, nonatomic) IBOutlet UILabel *interestAmountLab;

// 转让和撤回 公用的两个Label
@property (weak, nonatomic) IBOutlet UILabel *commonLabel;
@property (weak, nonatomic) IBOutlet UILabel *commonValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *suggestPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;// 234  195
@end

@implementation MyCreditorActionViewControllerBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    
    _confirmButton.layer.cornerRadius = 5.0f;
}

- (void)setTransferInvest:(BOOL)transferInvest
{
    _transferInvest = transferInvest;
    _contentViewHeightConstraint.constant = _transferInvest?239:50;
    _commonLabel.text = _transferInvest?@"服务费":@"下期还款日期";
    self.title = _transferInvest?@"转让债权":@"撤回债权";
    NSString *title = _transferInvest?@"转让":@"撤回";
    [_confirmButton setTitle:title forState:UIControlStateNormal];
}

- (void)setMyCreditorDic:(NSDictionary *)myCreditorDic
{
    _myCreditorDic = myCreditorDic;
    
    if (_transferInvest == YES) {
        _transferProjectNameLabel.text = [_myCreditorDic objectForKey:@"Title"];
        _surplusPrincipalLabel.text = [NSString stringWithFormat:@"%.2f元",[[_myCreditorDic objectForKey:@"ReceivablePrincipal"] floatValue]];
        _interestAmountLab.text = [NSString stringWithFormat:@"%.2f元",[[_myCreditorDic objectForKey:@"ReceivableInterest"] floatValue]];
        _commonValueLabel.text = [NSString stringWithFormat:@"%@元",[_myCreditorDic objectForKey:@"ServiceCharge"]];
        _suggestPriceLabel.text = [NSString stringWithFormat:@"%.2f-%.2f元",[[_myCreditorDic objectForKey:@"ReceivablePrincipal"] floatValue] * 0.965,[[_myCreditorDic objectForKey:@"ReceivablePrincipal"] floatValue]];
    }else{
        _transferProjectNameLabel.text = [_myCreditorDic objectForKey:@"Title"];
        _surplusPrincipalLabel.text = [NSString stringWithFormat:@"%@",[_myCreditorDic objectForKey:@"ReceivablePrincipal"]];
        _interestAmountLab.text = [NSString stringWithFormat:@"%.2f元",[[_myCreditorDic objectForKey:@"ReceivableInterest"] floatValue]];
        _commonValueLabel.text = [NSString stringWithFormat:@"%@",[_myCreditorDic objectForKey:@"NextRepayDate"]];
        _transferPriceTextField.text = [NSString stringWithFormat:@"%@",[_myCreditorDic objectForKey:@"PriceForSale"]];
        _transferPriceTextField.userInteractionEnabled = NO;
    }
}
- (IBAction)commitBtnClick:(id)sender {
    if (_transferInvest == YES){
        
        if ([[_myCreditorDic objectForKey:@"ReceivablePrincipal"] floatValue] * 0.965 > [_transferPriceTextField.text floatValue] || [[_myCreditorDic objectForKey:@"ReceivablePrincipal"] floatValue] < [_transferPriceTextField.text floatValue]) {
            [MBProgressHUD showMessag:@"转让价格需在建议价格范围内" toView:self.view];
            return;
        }
        
        MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
        [self.httpUtil requestDic4MethodName:@"debtdeal/postdebtDeal" parameters:@{@"ProjectId":[_myCreditorDic objectForKey:@"ProjectId"],@"CurrentRate":[_myCreditorDic objectForKey:@"Rate"],@"OwingPrincipal":[_myCreditorDic objectForKey:@"ReceivablePrincipal"],@"OwingNumber":[_myCreditorDic objectForKey:@"OwingNumber"],@"OwingInterest":[_myCreditorDic objectForKey:@"ReceivableInterest"],@"PriceForSale":_transferPriceTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
            if (status == 1 || status == 2) {
                [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
            }else{
                [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
            }
        }];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
        [self.httpUtil requestDic4MethodName:@"debtdeal/transferrevoke" parameters:@{@"DebtDealId":[_myCreditorDic objectForKey:@"DebtDealId"]} result:^(NSDictionary *dic, int status, NSString *msg) {
            if (status == 1 || status == 2) {
                [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
            }else{
                [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
            }
        }];
    }
}

- (void)delayMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
