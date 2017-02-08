//
//  MailViewController.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/17.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MailViewController.h"
#import "ModifyMailViewController.h"
#import "User.h"
#import "AppDelegate.h"
@interface MailViewController ()
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

@implementation MailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backBarItem];
    
    self.view.backgroundColor = BlackCCCCCC;
    
    self.codeTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.commitButton.layer.cornerRadius = 6.0f;
    self.commitButton.autoresizingMask = YES;
    self.mailTextFiled.text = [NSString stringWithFormat:@"%@",[User userFromFile].email];
    self.codeBtn.layer.cornerRadius = 2.0f;
    [self.codeTextFiled addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldChange:(UITextField *)textField
{
    if (IsStrEmpty(self.codeTextFiled.text)) {
        self.commitButton.userInteractionEnabled = NO;
        self.commitButton.backgroundColor = [UIColor colorWithHexString:@"#019BFF"];
    }else{
        self.commitButton.userInteractionEnabled = YES;
        self.commitButton.backgroundColor = NaviColor;
    }
}

- (void)setIsOldMail:(BOOL)isOldMail
{
    _isOldMail = isOldMail;
    
    if (!isOldMail) {
        [self.commitButton setTitle:@"绑定" forState:UIControlStateNormal];
        self.commitButton.userInteractionEnabled = NO;
        self.commitButton.backgroundColor = [UIColor colorWithHexString:@"#019BFF"];
    }else{
        [self.commitButton setTitle:@"下一步" forState:UIControlStateNormal];
        self.commitButton.userInteractionEnabled = NO;
        self.commitButton.backgroundColor = [UIColor colorWithHexString:@"#019BFF"];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCode:(id)sender {
    
    if (IsStrEmpty(self.mailTextFiled.text)) {
        [MBProgressHUD showMessag:@"邮箱不能为空" toView:self.view];
        return;
    }else if(![self emailIsValidate:self.mailTextFiled.text]){
    //验证邮箱格式是否有效
        [MBProgressHUD showMessag:@"邮箱格式不对" toView:self.view];
        
        return;
    }
    int typeNum = 2;
    if (!_isOldMail) {
        typeNum = 1;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    
    
    [self.httpUtil requestDic4MethodName:@"email/sendcode" parameters:@{@"email":[NSString stringWithFormat:@"%@",self.mailTextFiled.text],@"emailType":@(typeNum)} result:^(NSDictionary *dic, int status, NSString *msg) {
       
        if ([msg isEqualToString:@"该邮箱已经绑定，请不要重复绑定"]) {
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
            return ;
        }else{
            if (status == 1 || status == 2) {
                _CodeDic = dic;
                _codeBtn.userInteractionEnabled = NO;
                [self startTimer];
                //保存邮箱信息
               User *user = [User shareUser];
                user.email = [NSString stringWithFormat:@"%@",self.mailTextFiled.text];
                [user saveUser];
                
                [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
            }else{
                [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
            }
        }
        
       
    }];

    
}

- (BOOL)emailIsValidate:(NSString *)email{

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}

- (IBAction)commit:(UIButton *)sender {
    if (self.codeTextFiled.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入验证码" toView:self.view];
        return;
    }
    
    if (_isOldMail) {
        
        
            MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
        
            [self.httpUtil requestDic4MethodName:@"email/verifyemail" parameters:@{@"email":[NSString stringWithFormat:@"%@",self.mailTextFiled.text],@"emailCode":[NSString stringWithFormat:@"%@",self.codeTextFiled.text]} result:^(NSDictionary *dic, int status, NSString *msg) {
                
                if (status == 1 || status == 2) {
                    [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
                    ModifyMailViewController *vc = [[ModifyMailViewController alloc] init];
                    
                    vc.title = @"绑定新邮箱";
                    vc.isNext = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
                }
    
            }];

        
    }else{
    
        //绑定邮箱
        MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
        
        [self.httpUtil requestDic4MethodName:@"email/bind" parameters:@{@"email":[NSString stringWithFormat:@"%@",self.mailTextFiled.text],@"emailCode":[NSString stringWithFormat:@"%@",self.codeTextFiled.text]} result:^(NSDictionary *dic, int status, NSString *msg) {
            if (status == 1 || status == 2) {
//                [AppDelegate backToMe];
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
                
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
