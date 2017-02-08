//
//  ModifyPhoneOneViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/7.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ModifyPhoneOneViewController.h"
#import "ModifyPhoneTwoViewController.h"

@interface ModifyPhoneOneViewController ()
{
    int timerSecond;
}
@property (strong, nonatomic) NSTimer *deadTimer;
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (nonatomic,strong)NSDictionary *CodeDic;
@end

@implementation ModifyPhoneOneViewController
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

- (void)setMobileStr:(NSString *)mobileStr
{
    _mobileStr = mobileStr;
    
    _iphoneTextField.text = [_mobileStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改绑定手机";
    [self backBarItem];
    
    _CodeDic = [NSDictionary dictionary];
    
    _codeBtn.layer.cornerRadius = 2.0f;
    _nextBtn.layer.cornerRadius = 5.0f;
    _nextBtn.userInteractionEnabled = NO;
    
    [_iphoneTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_codeTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldChange:(UITextField *)textField
{
    if (IsStrEmpty(_codeTextField.text)){
        _nextBtn.userInteractionEnabled = NO;
        _nextBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (!IsStrEmpty(_codeTextField.text)){
        _nextBtn.userInteractionEnabled = YES;
        _nextBtn.backgroundColor = NaviColor;
    }
}

- (IBAction)codeBtnClick:(id)sender {
    
    if (IsStrEmpty(_mobileStr)) {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"mobile/getverifycode" parameters:@{@"Mobile":_mobileStr,@"Type":@(5)} result:^(NSDictionary *dic, int status, NSString *msg) {
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

- (IBAction)nextStep {
    
    
    [self.httpUtil requestDic4MethodName:@"mobile/mobilecodeverify" parameters:@{@"MobileCode":_codeTextField.text,@"Mobile":_mobileStr} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            ModifyPhoneTwoViewController *vc = [[ModifyPhoneTwoViewController alloc]init];
            vc.mobileStr = _iphoneTextField.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
    
}

@end
