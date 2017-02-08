//
//  InvestCommitViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/29.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "InvestCommitViewController.h"
#import "InvestSuccesViewController.h"
#import "WebProtocolViewController.h"
#import "NSString+Adding.h"

@interface InvestCommitViewController ()
@property (weak, nonatomic) IBOutlet UIButton *commitProtocolBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UILabel *rateLab;
@property (weak, nonatomic) IBOutlet UILabel *periodLab;
@property (weak, nonatomic) IBOutlet UILabel *returnTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *investAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *projectTitleLab;

@end

@implementation InvestCommitViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"投资确认";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    
    _commitBtn.layer.cornerRadius = 5.0f;
    _commitProtocolBtn.tag = 1;
}

- (void)setInvestDic:(NSDictionary *)investDic
{
    _investDic = investDic;
    
    _projectTitleLab.text = [_investDic objectForKey:@"Title"];
    if ([_investStr isEqual:@"理财"]) {
         _rateLab.text = [NSString stringWithFormat:@"%@%s",[_investDic objectForKey:@"Rate"],"%"];
        _periodLab.text = [NSString stringWithFormat:@"%@%@",[_investDic objectForKey:@"LoanPeriod"],[_investDic objectForKey:@"LoanDate"]];
        _returnTypeLab.text = [_investDic objectForKey:@"RepaymentTypeId"];
    }else{
         _rateLab.text = [NSString stringWithFormat:@"%@%s",[_investDic objectForKey:@"LoanRate"],"%"];
        if ([[_investDic objectForKey:@"PeriodTypeId"] integerValue] == 1) {
            _periodLab.text = [NSString stringWithFormat:@"%@天",[_investDic objectForKey:@"LoanDate"]];
        }else if ([[_investDic objectForKey:@"PeriodTypeId"] integerValue] == 2){
            _periodLab.text = [NSString stringWithFormat:@"%@个月",[_investDic objectForKey:@"LoanDate"]];
        }else if ([[_investDic objectForKey:@"PeriodTypeId"] integerValue] == 3){
            _periodLab.text = [NSString stringWithFormat:@"%@年",[_investDic objectForKey:@"LoanDate"]];
        }
        _returnTypeLab.text = [_investDic objectForKey:@"RepaymentType"];
    }
    _investAmountLab.text = [[[NSString stringWithFormat:@"%@",_investAmount] strmethodComma] stringByAppendingString:@"元"];
}

#pragma mark   是否同意协议
- (IBAction)commitProtocolClick:(id)sender {
    if (_commitProtocolBtn.tag == 1) {
        [_commitProtocolBtn setImage:[UIImage imageNamed:@"no_check"] forState:UIControlStateNormal];
        _commitProtocolBtn.tag = 2;
    }else if (_commitProtocolBtn.tag == 2){
        [_commitProtocolBtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
        _commitProtocolBtn.tag = 1;
    }
}
#pragma mark   协议跳转链接
- (IBAction)protocolClick:(id)sender {
    WebProtocolViewController *webProtocolVC = [WebProtocolViewController new];
    webProtocolVC.webAddressStr = @"http://192.168.1.83:8083/agreement/index";
    webProtocolVC.title = @"投资协议";
    [self.navigationController pushViewController:webProtocolVC animated:NO];
}
- (IBAction)commitBtnClick:(id)sender {
    if (_commitProtocolBtn.tag == 2) {
        [MBProgressHUD showError:@"请同意协议" toView:self.view];
        return;
    }
    NSInteger isNew;
    if ([_isNewType isEqual:@"新手"]) {
        isNew = 1;
    }else{
        isNew = 0;
    }
    if ([_investStr isEqual:@"理财"]) {
        MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
        _commitBtn.userInteractionEnabled = NO;
        [self.httpUtil requestDic4MethodName:@"financialproduct/financialbid" parameters:@{@"ProductId":[_investDic objectForKey:@"ProductId"],@"BidAmount":_investAmount,@"IsNew":@(isNew)} result:^(NSDictionary *dic, int status, NSString *msg) {
            if (status == 1 || status == 2) {
                [hud hide:YES];
                InvestSuccesViewController *investSuccessVC = [InvestSuccesViewController new];
                investSuccessVC.amountStr = _investAmount;
                [self.navigationController pushViewController:investSuccessVC animated:YES];
                _commitBtn.userInteractionEnabled = YES;
            }else{
                [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
                _commitBtn.userInteractionEnabled = YES;
            }
        }];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
        _commitBtn.userInteractionEnabled = NO;
        [self.httpUtil requestDic4MethodName:@"project/buy" parameters:@{@"ProjectId":[_investDic objectForKey:@"ProjectId"],@"BidAmount":_investAmount,@"IsNew":@(isNew)} result:^(NSDictionary *dic, int status, NSString *msg) {
            if (status == 1 || status == 2) {
                [hud hide:YES];
                InvestSuccesViewController *investSuccessVC = [InvestSuccesViewController new];
                investSuccessVC.amountStr = _investAmount;
                [self.navigationController pushViewController:investSuccessVC animated:YES];
                _commitBtn.userInteractionEnabled = YES;
            }else{
                [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
                _commitBtn.userInteractionEnabled = YES;
            }
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
