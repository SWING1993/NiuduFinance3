//
//  PushMoneyViewController.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/17.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "PushMoneyViewController.h"

@interface PushMoneyViewController ()

@end

@implementation PushMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backBarItem];
    self.title = @"提现";
    self.submitButton.layer.cornerRadius = 5.0f;
    self.haveMoneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
}
- (void)setBankCardsArr:(NSMutableArray *)bankCardsArr
{
    _bankCardsArr = bankCardsArr;
    
    //数据绑定
//    NSDictionary *dic = _bankCardsArr[indexPath.row];
//    [NetWorkingUtil setImage:cell.bankCardImageView url:[dic objectForKey:@"BackIconUrl"] defaultIconName:nil];
//    cell.bankCardNameLab.text = [dic objectForKey:@"BankTypeName"];
//    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSString *numberStr = [dic objectForKey:@"BankNumber"];
//    cell.bankCardNumberLab.text = [NSString stringWithFormat:@"尾号 %@",[numberStr substringFromIndex:numberStr.length -4]];
    
    NSDictionary *dic = bankCardsArr[0];
    [NetWorkingUtil setImage:self.iconImageView url:[dic objectForKey:@"BackIconUrl"]  defaultIconName:nil];
    self.bankNameLabel.text = [dic objectForKey:@"BankTypeName"];
    NSString *numberStr = [dic objectForKey:@"BankNumber"];
    self.accountNumLabel.text = [NSString stringWithFormat:@"尾号 %@",[numberStr substringFromIndex:numberStr.length -4]];
    
    //计算手续费,和预计到账的前
    
}

- (void)setHaveMoney:(NSString *)haveMoney
{
    _haveMoney = haveMoney;
    
    self.balanceLabel.text = [NSString stringWithFormat:@"  可提现金额%@元",haveMoney];
}

- (IBAction)submit:(id)sender {
    
    if(self.haveMoneyTextField.text.length == 0){
        [MBProgressHUD showMessag:@"请输入提现金额" toView:self.view];
    }
    else if ([_haveMoney floatValue]<[_haveMoneyTextField.text floatValue]) {
        NSLog(@"test%@,提现:%@",self.balanceLabel.text,_haveMoneyTextField.text);
        [MBProgressHUD showMessag:@"余额不足" toView:self.view];
        return;
    }
    else{
        [MBProgressHUD showMessag:@"提现成功,以提交审核" toView:self.view];
    }
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
