//
//  ModifyMailViewController.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/17.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ModifyMailViewController.h"
#import "NSString+Adding.h"
#import "AppDelegate.h"
#import "User.h"
#import "AccountSafeController.h"
@interface ModifyMailViewController ()
{
    int timerSecond;
}

@property (weak, nonatomic) IBOutlet UITextField *mailTextFiled;

@property (weak, nonatomic) IBOutlet UITextField *codeTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (strong, nonatomic) NSTimer *deadTimer;
@property (nonatomic,strong)NSDictionary *CodeDic;
@end

@implementation ModifyMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    
    self.view.backgroundColor = BlackCCCCCC;
    
    self.codeTextFiled.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setIsNext:(BOOL)isNext
{
    _isNext = isNext;
    self.commitButton.layer.cornerRadius = 10.0f;
    self.commitButton.autoresizingMask = YES;
    self.commitButton.backgroundColor = NaviColor;
    
    self.codeBtn.layer.cornerRadius = 2.0f;
}


//获取验证码相关的方法

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
        timerSecond = 120;
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

- (IBAction)getCode:(id)sender {
    
    if (IsStrEmpty(self.mailTextFiled.text)) {
        [MBProgressHUD showMessag:@"请输入邮箱" toView:self.view];
        return;
    }else if(![NSString isValidateEmail:self.mailTextFiled.text]){
        [MBProgressHUD showMessag:@"请输入正确格式的邮箱" toView:self.view];
        return;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
   
    
    [self.httpUtil requestDic4MethodName:@"email/sendcode" parameters:@{@"email":[NSString stringWithFormat:@"%@",self.mailTextFiled.text],@"emailType":@0} result:^(NSDictionary *dic, int status, NSString *msg) {
        
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


- (IBAction)commit:(id)sender {
    
    if (self.mailTextFiled.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入邮箱" toView:self.view];
        return;
    }else if(self.codeTextFiled.text.length == 0){
        [MBProgressHUD showMessag:@"请输入验证码" toView:self.view];
        return;
    }else if(![NSString isValidateEmail:self.mailTextFiled.text]){
        [MBProgressHUD showMessag:@"请输入正确格式的邮箱" toView:self.view];
        return;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"email/bindnewemail" parameters:@{@"newEmail":[NSString stringWithFormat:@"%@",self.mailTextFiled.text],@"newCode":[NSString stringWithFormat:@"%@",self.codeTextFiled.text]} result:^(NSDictionary *dic, int status, NSString *msg) {
        
        if (status == 1 || status == 2) {
            
            [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
            //修改成功,返回
            //保存邮箱信息
            User *user = [User shareUser];
            user.email = [NSString stringWithFormat:@"%@",self.mailTextFiled.text];
            [user saveUser];
            
//            [AppDelegate backToMe];
             [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
            
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    }];
    
}

- (void)delayMethod
{
//    [self.navigationController popViewControllerAnimated:YES];
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[AccountSafeController class]]) {
            AccountSafeController *revise =(AccountSafeController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
        }
        
    }

}

@end
