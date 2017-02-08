//
//  CheckLoginViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/18.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "CheckLoginViewController.h"
#import "GestureViewController.h"
#import "User.h"
#import "AppDelegate.h"
#import "PCCircleViewConst.h"
#import "FindPsdViewController.h"

@interface CheckLoginViewController ()<GestureViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property (nonatomic,strong)User *user;
@end

@implementation CheckLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBack];
    
    self.title = @"忘记手势密码";
    
    _checkBtn.layer.cornerRadius = 5.0f;
    
    [_accountTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_passwordTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
}

#pragma mark 自定义NaviBack
- (void)setNaviBack
{
    [self setupBarButtomItemWithImageName:@"nav_back_normal.png" highLightImageName:@"nav_back_select.png" selectedImageName:nil target:self action:@selector(backClick) leftOrRight:YES];
}

- (void)backClick{
    
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldChange:(UITextField *)textField
{
    
    if (IsStrEmpty(_accountTextField.text)) {
        _checkBtn.userInteractionEnabled = NO;
        _checkBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (IsStrEmpty(_passwordTextField.text)){
        _checkBtn.userInteractionEnabled = NO;
        _checkBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (!IsStrEmpty(_accountTextField.text) && !IsStrEmpty(_passwordTextField.text)){
        _checkBtn.userInteractionEnabled = YES;
        _checkBtn.backgroundColor = NaviColor;
    }
}

- (IBAction)checkBtnClickEvent:(id)sender {
    
    [self.httpUtil requestDic4MethodName:@"user/forgetgesture" parameters:@{@"UserName":_accountTextField.text,@"Pwd":_passwordTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            GestureViewController *gestureVc = [[GestureViewController alloc] init];
            gestureVc.type = GestureViewControllerTypeSetting;
            gestureVc.delegate = self;
            [self.navigationController pushViewController:gestureVc animated:YES];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
    
}

#pragma mark GestureViewControllerDelegate
- (void)createLockSuccess:(NSString *)lockPwd
{
    [self.httpUtil requestDic4MethodName:@"user/gesture" parameters:@{@"Gesture":lockPwd} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD showSuccess:msg toView:self.view];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];

        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}
//延迟方法
- (void)delayMethod
{
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:nil];
    
    [self.httpUtil requestObj4MethodName:@"user/login" parameters:@{@"UserName":_accountTextField.text,@"password":_passwordTextField.text} result:^(id obj, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            _user = (User *)obj;
            _user.password = _passwordTextField.text;
            [_user saveUser];
            [_user saveLogin];
            [PCCircleViewConst saveGesture:_user.gesture Key:gestureFinalSaveKey];
            [AppDelegate loginMain];
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    } convertClassName:@"User" key:nil];
}
- (IBAction)forgetPsdClick:(id)sender {
    FindPsdViewController *findPsdVC = [FindPsdViewController new];
    [self.navigationController pushViewController:findPsdVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
