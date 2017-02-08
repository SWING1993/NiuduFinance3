//
//  LoginViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/1.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterFirstViewController.h"
#import "FindPsdViewController.h"
#import "User.h"
#import "AppDelegate.h"
#import "PCCircleViewConst.h"
#import "TabBarController.h"
#import "GestureViewController.h"
#import "IOSmd5.h"


#import "RegisterFirsViewController.h"

@interface LoginViewController ()<GestureViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic,strong)User *user;
@end

@implementation LoginViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"登录";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loginBtn.layer.cornerRadius = 5.0f;
    _loginBtn.userInteractionEnabled = NO;
    
    [_accountTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_passwordTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self setNaviBack];
}

- (void)textFieldChange:(UITextField *)textField
{
    
    if (IsStrEmpty(_accountTextField.text)) {
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (IsStrEmpty(_passwordTextField.text)){
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (!IsStrEmpty(_accountTextField.text) && !IsStrEmpty(_passwordTextField.text)){
        _loginBtn.userInteractionEnabled = YES;
        _loginBtn.backgroundColor = Nav019BFF;
    }
}

#pragma mark 自定义NaviBack
- (void)setNaviBack
{
    [self setupBarButtomItemWithImageName:@"nav_back_normal.png" highLightImageName:@"nav_back_select.png" selectedImageName:nil target:self action:@selector(backClick) leftOrRight:YES];
}
- (void)backClick
{
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    if ([_typeStr isEqual:@"exit"] || [_typeStr isEqual:@"tabbar"]){
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        TabBarController *tabbarController = [[TabBarController alloc] init];
        tabbarController.selectedIndex = 0;
        app.window.rootViewController = tabbarController;
    }else{
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)loginClickEvent:(id)sender {
    
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    
//    [self.httpUtil requestDic4MethodName:@"user/login" parameters:@{@"UserName":_accountTextField.text,@"Password":_passwordTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
//       
//        if (status == 1|| status == 2) {
//           
//            
//        }else{
//        
//            
//        }
//    }];
    
    [self.httpUtil requestObj4MethodName:@"user/login" parameters:@{@"UserName":_accountTextField.text,@"Password":_passwordTextField.text} result:^(id obj, int status, NSString *msg) {
        NSLog(@"--------------%@",self.httpUtil);
        if (status == 1 || status == 2) {
            _user = (User *)obj;
            _user.password = _passwordTextField.text;
            
            [_user saveUser];

            [_user saveLogin];
            [AppDelegate loginMain];

//            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
            [hud hide:YES];
        }else{
            
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
        
    }
    convertClassName:@"User" key:nil];
    NSLog(@"--------------%@",self.httpUtil);

    
}

- (void)delayMethod
{
    if (_user.gestureStatus == YES) {
        [PCCircleViewConst saveGesture:_user.gesture Key:gestureFinalSaveKey];
        if ([_typeStr isEqual:@"exit"] || [_typeStr isEqual:@"forget"]){
            [AppDelegate loginMain];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        gestureVc.type = GestureViewControllerTypeSetting;
        gestureVc.delegate = self;
        [self.navigationController pushViewController:gestureVc animated:YES];
    }
}

#pragma mark GestureViewControllerDelegate
- (void)createLockSuccess:(NSString *)lockPwd
{
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:nil];
    NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
    [util requestDic4MethodName:@"user/gesture" parameters:@{@"Gesture":lockPwd} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            _user.gesture = [IOSmd5 md5:lockPwd];
            [PCCircleViewConst saveGesture:[IOSmd5 md5:lockPwd] Key:gestureFinalSaveKey];
            [hud hide:YES];
            [self performSelector:@selector(delayMethodLogin) withObject:nil afterDelay:0.5f];
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    }];
}

- (void)delayMethodLogin
{
    [AppDelegate loginMain];
}

- (IBAction)forgetPsdClickEvent:(id)sender {
    FindPsdViewController *findPsdVC = [FindPsdViewController new];
    [self.navigationController pushViewController:findPsdVC animated:YES];

}
- (IBAction)registerClickEvent:(id)sender {
    RegisterFirsViewController *findPsdVC = [RegisterFirsViewController new];
    [self.navigationController pushViewController:findPsdVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
