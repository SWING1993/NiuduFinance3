//
//  RealNameCertificationViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/7.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "RealNameCertificationViewController.h"
#import "User.h"

@interface RealNameCertificationViewController ()//255 70 80 红色
@property (weak, nonatomic) IBOutlet UITextField *raalNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation RealNameCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    [self backBarItem];
    
    _commitBtn.layer.cornerRadius = 5.0f;
    _commitBtn.userInteractionEnabled = NO;
    
    [_raalNameTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_passwordTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldChange:(UITextField *)textField
{
    if (IsStrEmpty(_raalNameTextField.text)) {
        _commitBtn.userInteractionEnabled = NO;
        _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (IsStrEmpty(_passwordTextField.text)){
        _commitBtn.userInteractionEnabled = NO;
        _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (!IsStrEmpty(_raalNameTextField.text) && !IsStrEmpty(_passwordTextField.text)){
        _commitBtn.userInteractionEnabled = YES;
        _commitBtn.backgroundColor = NaviColor;
    }
}

- (IBAction)profirmAction
{
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    _commitBtn.userInteractionEnabled = NO;
    [self.httpUtil requestDic4MethodName:@"user/idauth" parameters:@{@"RealName":_raalNameTextField.text,@"IdNum":_passwordTextField.text,@"UserId":@([User userFromFile].userId)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
            User *user = [User shareUser];
            user.realName = _raalNameTextField.text;
            user.idValidate = 1;
            user.idNumber = _passwordTextField.text;
            [user saveUser];
            [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
            _commitBtn.userInteractionEnabled = YES;
        }else{
            _commitBtn.userInteractionEnabled = YES;
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    }];
}

- (void)delayMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
