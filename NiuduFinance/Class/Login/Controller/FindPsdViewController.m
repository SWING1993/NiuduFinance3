//
//  FindPsdViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/1.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "FindPsdViewController.h"
#import "ResetPsdViewController.h"
#import "User.h"
@interface FindPsdViewController ()
{
    int timerSecond;
}
@property (strong, nonatomic) NSTimer *deadTimer;
@property (weak, nonatomic) IBOutlet UIButton *getCheckNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
//@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkNumTextField;

@property (nonatomic,strong)NSDictionary *numDic;
@end

@implementation FindPsdViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"忘记密码";
    }
    return self;
}

#pragma mark get checkNumber
-(void)flashBtnStatus{
    timerSecond --;
    if (timerSecond == 0) {
        _getCheckNumBtn.backgroundColor = [UIColor colorWithHexString:@"#fcf0ea"];
        [_getCheckNumBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [_getCheckNumBtn setTitleColor:[UIColor colorWithHexString:@"#F1835F"] forState:UIControlStateNormal];
        _getCheckNumBtn.userInteractionEnabled = YES;
        [self stopTimer];
    }else{
        
        [_getCheckNumBtn setTitle:[NSString stringWithFormat:@"获取中(%d)",timerSecond] forState:UIControlStateNormal];
    }
}
-(void)startTimer{
    if (!self.deadTimer) {
        timerSecond = 60;
        _getCheckNumBtn.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [_getCheckNumBtn setTitleColor:[UIColor colorWithHexString:@"#bfbfbf"] forState:UIControlStateNormal];
        [_getCheckNumBtn setTitle:[NSString stringWithFormat:@"获取中(%d)",timerSecond] forState:UIControlStateNormal];
        _getCheckNumBtn.userInteractionEnabled = NO;
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
    
    _getCheckNumBtn.layer.cornerRadius = 3.0;
    _nextStepBtn.layer.cornerRadius = 5.0f;
    _nextStepBtn.userInteractionEnabled = NO;
    
//    [_accountTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_iphoneTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_checkNumTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldChange:(UITextField *)textField
{
     if (IsStrEmpty(_iphoneTextField.text)){
        _nextStepBtn.userInteractionEnabled = NO;
        _nextStepBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (IsStrEmpty(_checkNumTextField.text)){
        _nextStepBtn.userInteractionEnabled = NO;
        _nextStepBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (!IsStrEmpty(_iphoneTextField.text) && !IsStrEmpty(_checkNumTextField.text)){
        _nextStepBtn.userInteractionEnabled = YES;
        _nextStepBtn.backgroundColor = Nav019BFF;
    }
}
//  获取验证码
- (IBAction)getCheckClickEvent:(id)sender {
    //  获取验证码增加判断
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"mobile/getverifycode" parameters:@{@"Mobile":_iphoneTextField.text,@"Type":@(4)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
//            _numDic = dic;
            
            _getCheckNumBtn.userInteractionEnabled = NO;
            [self startTimer];
            [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    }];
}

//  下一步
- (IBAction)nextStepClickEvent:(id)sender {
    
    [self.httpUtil requestDic4MethodName:@"mobile/mobilecodeverify" parameters:@{@"MobileCode":_checkNumTextField.text,@"Mobile":_iphoneTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            
            ResetPsdViewController *resetPsdVC = [ResetPsdViewController new];
            resetPsdVC.accountStr = [NSString stringWithFormat:@"%@",dic];
            resetPsdVC.iphoneStr = _iphoneTextField.text;
            [self.navigationController pushViewController:resetPsdVC animated:YES];
        }else{
            
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
