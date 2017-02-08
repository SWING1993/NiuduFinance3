//
//  DebtCommitViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/15.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "DebtCommitViewController.h"
#import "InvestSuccesViewController.h"

@interface DebtCommitViewController ()
@property (weak, nonatomic) IBOutlet UILabel *debtTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *debtRateLab;
@property (weak, nonatomic) IBOutlet UILabel *debtPeriodLab;
@property (weak, nonatomic) IBOutlet UILabel *debtReturnTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *debtPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *debtAmountLab;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation DebtCommitViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"债权确认";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    
    _commitBtn.layer.cornerRadius = 5.0f;
}

- (void)setDebtCommitDic:(NSDictionary *)debtCommitDic
{
    _debtCommitDic = debtCommitDic;
    
    _debtTitleLab.text = [_debtCommitDic objectForKey:@"Title"];
    _debtRateLab.text = [NSString stringWithFormat:@"%@%s",[_debtCommitDic objectForKey:@"CurrentRate"],"%"];
    _debtPeriodLab.text = [NSString stringWithFormat:@"%@天",[_debtCommitDic objectForKey:@"Duration"]];
    _debtReturnTypeLab.text = _periodStr;
    if ([[_debtCommitDic objectForKey:@"PriceForSaleTypeId"] integerValue ]== 1) {
        _debtPriceLab.text = [NSString stringWithFormat:@"%@元",[_debtCommitDic objectForKey:@"PriceForSale"]];
    }else{
        _debtPriceLab.text = [NSString stringWithFormat:@"%@万元",[_debtCommitDic objectForKey:@"PriceForSale"]];
    }
    
    CGFloat discountAmount = [[_debtCommitDic objectForKey:@"OwingPrincipal"] floatValue] + [[_debtCommitDic objectForKey:@"OwingInterest"] floatValue];
    _debtAmountLab.text = [NSString stringWithFormat:@"%.2f元",discountAmount];
}
- (IBAction)commitBtnClick:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    _commitBtn.userInteractionEnabled = NO;
    [self.httpUtil requestDic4MethodName:@"debtdeal/buy" parameters:@{@"DebtDealId":[_debtCommitDic objectForKey:@"Id"]} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [hud hide:YES];
            InvestSuccesViewController *investSuccessVC = [InvestSuccesViewController new];
            investSuccessVC.amountStr = [NSString stringWithFormat:@"%@",[_debtCommitDic objectForKey:@"PriceForSale"]];
            [self.navigationController pushViewController:investSuccessVC animated:YES];
            _commitBtn.userInteractionEnabled = YES;
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
            _commitBtn.userInteractionEnabled = YES;
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
