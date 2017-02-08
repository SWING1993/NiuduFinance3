//
//  RegisterFirstViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/1.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "RegisterFirstViewController.h"
#import "RegisterSecondViewController.h"
#import "WebProtocolViewController.h"
@interface RegisterFirstViewController ()
{
    int timerSecond;
}



@property (strong, nonatomic) NSTimer *deadTimer;
//请输入手机号码
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextField;
//请输入验证码
@property (weak, nonatomic) IBOutlet UITextField *checkNumTextField;
//获取验证码
@property (weak, nonatomic) IBOutlet UIButton *getNumBtn;
//下一步（注册即享100元现金）
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
//同意协议的图片
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
//请输入邀请码，可以为空
@property (weak, nonatomic) IBOutlet UITextField *inviteCode;

//H
//请输入用户名
@property (weak, nonatomic) IBOutlet UITextField *yongHuName;
//请输入密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
//请再次输入密码
@property (weak, nonatomic) IBOutlet UITextField *queRenPwdTextField;



@property (nonatomic,strong)NSDictionary *numDic;

@end

@implementation RegisterFirstViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"注册";
    }
    return self;
}


#pragma mark get checkNumber
-(void)flashBtnStatus{
    timerSecond --;
    if (timerSecond == 0) {
        _getNumBtn.backgroundColor = [UIColor colorWithHexString:@"#fcf0ea"];
        [_getNumBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [_getNumBtn setTitleColor:[UIColor colorWithHexString:@"#F1835F"] forState:UIControlStateNormal];
        _getNumBtn.userInteractionEnabled = YES;
        [self stopTimer];
    }else{
        
        [_getNumBtn setTitle:[NSString stringWithFormat:@"获取中(%d)",timerSecond] forState:UIControlStateNormal];
    }
}
-(void)startTimer{
    if (!self.deadTimer) {
        timerSecond = 120;
        _getNumBtn.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [_getNumBtn setTitleColor:[UIColor colorWithHexString:@"#bfbfbf"] forState:UIControlStateNormal];
        [_getNumBtn setTitle:[NSString stringWithFormat:@"获取中(%d)",timerSecond] forState:UIControlStateNormal];
        _getNumBtn.userInteractionEnabled = NO;
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
    [self backBarItem];
    
    _numDic = [NSDictionary dictionary];
    
    _getNumBtn.layer.cornerRadius = 3.0f;
    _nextStepBtn.layer.cornerRadius = 5.0f;
    _nextStepBtn.userInteractionEnabled = NO;
    _agreeButton.tag = 1;
    _inviteCode.keyboardType = UIKeyboardTypeDefault;
    [_iphoneTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_checkNumTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    

    
}

- (void)textFieldChange:(UITextField *)textField
{
    if (IsStrEmpty(_iphoneTextField.text)) {
        _nextStepBtn.userInteractionEnabled = NO;
        _nextStepBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (IsStrEmpty(_checkNumTextField.text)){
        _nextStepBtn.userInteractionEnabled = NO;
        _nextStepBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (!IsStrEmpty(_iphoneTextField.text) && !IsStrEmpty(_checkNumTextField.text)){
        _nextStepBtn.userInteractionEnabled = YES;
        _nextStepBtn.backgroundColor = NaviColor;
    }
}

//  获取验证码
- (IBAction)getNumClickEvent:(id)sender {
    //  获取验证码增加判断
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"mobile/getverifycode" parameters:@{@"Mobile":_iphoneTextField.text,@"Type":@(7)} result:^(NSDictionary *dic, int status, NSString *msg) {

        if (status == 1 || status == 2) {
            _numDic = dic;
            _getNumBtn.userInteractionEnabled = NO;
            [self startTimer];
            [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    }];
    
}
//  下一步
- (IBAction)nextStepClickEvent:(id)sender {
    
   
    if (_agreeButton.tag == 2) {
        [MBProgressHUD showError:@"请同意协议" toView:self.view];
    }
    else{
        [self.httpUtil requestDic4MethodName:@"mobile/mobilecodeverify" parameters:@{@"MobileCode":_checkNumTextField.text,@"Mobile":_iphoneTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
            if (status == 1 || status == 2) {
                RegisterSecondViewController *registerSecondVC = [RegisterSecondViewController new];
                
                registerSecondVC.iphoneStr = _iphoneTextField.text;
                if (_inviteCode.text.length != 0) {
                    registerSecondVC.inviteCode = _inviteCode.text;
                }
                [self.navigationController pushViewController:registerSecondVC animated:YES];
            }else{
                [MBProgressHUD showError:msg toView:self.view];
            }
        }];
    }
    
}
- (IBAction)agreeButton:(id)sender {
    if (_agreeButton.tag == 1) {
        [_agreeButton setImage:[UIImage imageNamed:@"no_check"] forState:UIControlStateNormal];
        _agreeButton.tag = 2;
    }else if (_agreeButton.tag == 2){
        [_agreeButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
        _agreeButton.tag = 1;
    }
    
}
- (IBAction)showProtocolButton:(id)sender {
    WebProtocolViewController *webProtocolVC = [WebProtocolViewController new];
    webProtocolVC.title = @"服务协议";
    webProtocolVC.webAddressStr = [self.httpUtil requWebName:@"/agreement.jsp" parameters:nil];
    
    [self.navigationController pushViewController:webProtocolVC animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
