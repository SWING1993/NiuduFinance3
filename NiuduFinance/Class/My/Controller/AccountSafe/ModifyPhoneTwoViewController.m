//
//  ModifyPhoneTwoViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/7.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ModifyPhoneTwoViewController.h"
#import "User.h"

@interface ModifyPhoneTwoViewController ()
{
    int timerSecond;
}
@property (strong, nonatomic) NSTimer *deadTimer;
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (nonatomic,strong)NSDictionary *CodeDic;
@end

@implementation ModifyPhoneTwoViewController
#pragma mark get checkNumber
-(void)flashBtnStatus{
    timerSecond --;
    if (timerSecond == 0) {
        _codeBtn.backgroundColor = [UIColor colorWithHexString:@"#fcf0ea"];
        [_codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:[UIColor colorWithHexString:@"#F1835F"] forState:UIControlStateNormal];
        _codeBtn.userInteractionEnabled = YES;
        [self stopTimer];
    }else{
        
        [_codeBtn setTitle:[NSString stringWithFormat:@"获取中(%d)",timerSecond] forState:UIControlStateNormal];
    }
}
-(void)startTimer{
    if (!self.deadTimer) {
        timerSecond = 60;
        _codeBtn.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [_codeBtn setTitleColor:[UIColor colorWithHexString:@"#bfbfbf"] forState:UIControlStateNormal];
        [_codeBtn setTitle:[NSString stringWithFormat:@"获取中(%d)",timerSecond] forState:UIControlStateNormal];
        _codeBtn.userInteractionEnabled = NO;
        self.deadTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(flashBtnStatus) userInfo:nil repeats:YES];
    }
}
-(void)stopTimer{
    [self.deadTimer invalidate];
    self.deadTimer = nil;
}
-(void)dealloc{
    [self stopTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定新手机";
    [self backBarItem];
    _CodeDic = [NSDictionary dictionary];
    _codeBtn.layer.cornerRadius = 2.0f;
    
    _commitBtn.layer.cornerRadius = 5.0f;
    _commitBtn.userInteractionEnabled = NO;
    
    [_iphoneTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_codeTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldChange:(UITextField *)textField
{
    if (IsStrEmpty(_iphoneTextField.text)) {
        _commitBtn.userInteractionEnabled = NO;
        _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (IsStrEmpty(_codeTextField.text)){
        _commitBtn.userInteractionEnabled = NO;
        _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (!IsStrEmpty(_iphoneTextField.text) && !IsStrEmpty(_codeTextField.text)){
        _commitBtn.userInteractionEnabled = YES;
        _commitBtn.backgroundColor = NaviColor;
    }
}
- (IBAction)codeBtnClick:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"mobile/getverifycode" parameters:@{@"Mobile":_iphoneTextField.text,@"Type":@(5)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            _CodeDic = dic;
            _codeBtn.userInteractionEnabled = NO;
            [self startTimer];
            [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    }];
}

- (IBAction)confirmAction {
    
//    if (![[_CodeDic objectForKey:@"Code"] isEqual:_codeTextField.text]) {
//        [MBProgressHUD showError:@"您输入的验证码不正确，请重新输入" toView:self.view];
//        return;
//    }
    
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"user/bindmobile" parameters:@{@"Mobile":_iphoneTextField.text,@"TypeId":@(2),@"Code":_codeTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [hud dismissSuccessStatusString:@"操作成功" hideAfterDelay:1.0];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    }];
}

- (void)delayMethod
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
}
@end
