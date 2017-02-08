//
//  RegisterSecondViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/1.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "RegisterSecondViewController.h"
#import "GestureViewController.h"
#import "AppDelegate.h"
#import "ValidateUtil.h"
#import "User.h"
#import "PCCircleViewConst.h"

@interface RegisterSecondViewController ()<GestureViewControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *setPsdTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@property (nonatomic,strong)User *user;

@end

@implementation RegisterSecondViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"注册";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    
    _nextStepBtn.layer.cornerRadius = 5.0f;
    _nextStepBtn.userInteractionEnabled = NO;
    
    [_accountTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_setPsdTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.httpUtil requestDic4MethodName:@"user/checkusername" parameters:@{@"UserName":_accountTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            
        }else{
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
    return YES;
}

- (void)textFieldChange:(UITextField *)textField
{
    if (IsStrEmpty(_accountTextField.text)) {
        _nextStepBtn.userInteractionEnabled = NO;
        _nextStepBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (IsStrEmpty(_setPsdTextField.text)){
        _nextStepBtn.userInteractionEnabled = NO;
        _nextStepBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (!IsStrEmpty(_accountTextField.text) && !IsStrEmpty(_setPsdTextField.text)){
        _nextStepBtn.userInteractionEnabled = YES;
        _nextStepBtn.backgroundColor = NaviColor;
    }
}
- (IBAction)nextStepClickEvent:(id)sender {

    // 判断用户名是否 合法
    if (![self isValidateUsername] || _accountTextField.text.length < 6 || _accountTextField.text.length > 15)
    {
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.detailsLabelText = @"用户名由6-15个字符组成，包含字母、数字、下划线，且必须包含字母";
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
        // 1.5秒之后再消失
        [hud hide:YES afterDelay:1];
        
        return;
    }
    
    if (_setPsdTextField.text.length < 8) {
        [MBProgressHUD showError:@"请输入最小为8个字符的密码" toView:self.view];
        return;
    }
    if ([ValidateUtil characterCountOfString:_setPsdTextField.text] == _setPsdTextField.text.length || [ValidateUtil characterCharCountOfString:_setPsdTextField.text] == _setPsdTextField.text.length) {
        [MBProgressHUD showError:nil toView:self.view];
        NSArray *huds = [MBProgressHUD allHUDsForView:self.view];
        MBProgressHUD *hud = huds[0];
        hud.detailsLabelText = @"密码由字母，数字和特殊字符组成，且必须包含字母";
        return;
    }
    
    [self.httpUtil requestDic4MethodName:@"user/checkusername" parameters:@{@"UserName":_accountTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 0 || status == 0) {
            GestureViewController *gestureVc = [[GestureViewController alloc] init];
            gestureVc.type = GestureViewControllerTypeSetting;
            gestureVc.delegate = self;
            [self.navigationController pushViewController:gestureVc animated:YES];
        }else{
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

#pragma mark GestureViewControllerDelegate
- (void)createLockSuccess:(NSString *)lockPwd
{
    
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"user/register" parameters:@{@"UserName":_accountTextField.text,@"Password":_setPsdTextField.text,@"Mobile":[NSString stringWithFormat:@"%@",_iphoneStr],@"GesturePwd":[NSString stringWithFormat:@"%@",lockPwd],@"TypeId":@(1),@"InvitationCode":[NSString stringWithFormat:@"%@",_inviteCode]} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.2];
            
        }else{
            
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    }];
}

- (void)delayMethod
{
    [self.httpUtil requestObj4MethodName:@"user/login" parameters:@{@"UserName":_accountTextField.text,@"Password":_setPsdTextField.text} result:^(id obj, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            _user = (User *)obj;
            _user.password = _setPsdTextField.text;
            [_user saveUser];
            [_user saveLogin];
            [PCCircleViewConst saveGesture:_user.gesture Key:gestureFinalSaveKey];
            [AppDelegate loginMain];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    } convertClassName:@"User" key:nil];
}

- (BOOL)isValidateUsername;
{
    NSString *regex = @"^[a-zA-Z0-9_]*[a-zA-Z]+[a-zA-Z0-9_]*$";   //以A开头，e结尾
    //    @"name MATCHES %@",regex
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //    [regextestmobile evaluateWithObject:_userNameTextField.text];
    
    return [regextestmobile evaluateWithObject:_accountTextField.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
