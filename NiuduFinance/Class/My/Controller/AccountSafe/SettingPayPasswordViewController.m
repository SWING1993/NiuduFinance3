//
//  SettingPayPasswordOneViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/8.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "SettingPayPasswordViewController.h"
#import "PSPayTextField.h"
#import "IQKeyboardManager.h"
#import "IdentityTestViewController.h"

@interface SettingPayPasswordViewController ()<PSPayTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) PSPayTextField *payTextField;

@property (nonatomic,strong)NSString *psdStrOne;


@end

@implementation SettingPayPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置支付密码";
    _nextButton.layer.cornerRadius = 5.0f;
    [self backBarItem];
    [self addPayTextField];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    // 布局
    _payTextField.centerX = self.view.width * 0.5;
    _payTextField.top = 40;
    
    _nextButton.width = _payTextField.width - 8;
    _nextButton.top = _payTextField.bottom + 10;
    _nextButton.centerX = _payTextField.centerX;
    
    _forgetPasswordButton.top = _nextButton.bottom + 10;
    _forgetPasswordButton.left = CGRectGetMaxX(_nextButton.frame) - _forgetPasswordButton.width;
}

#pragma mark - Override
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_payTextField ps_resignFirstResponder];
}

#pragma mark - Set Up UI
- (void)addPayTextField
{
    PSPayTextField *textField = [PSPayTextField textFieldFromXib];
    textField.delegate = self;
    [self.view addSubview:textField];

    _payTextField = textField;
}

#pragma mark - Set & Get
- (void)setSettingStep:(SettingPayStep)settingStep
{
    _settingStep = settingStep;
    UILabel *laebl = self.view.subviews[0];
    if (_settingStep == SettingPayStepOne)
    {
        laebl.text = @"请设置6位数字密码";
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
    else if (_settingStep == SettingPayStepTwo)
    {
        laebl.text = @"请再次输入6位数字密码";
        [_nextButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    else
    {
        _forgetPasswordButton.hidden = YES;
    }
}

#pragma mark - PSPayTextFieldDelgate
- (void)ps_textField:(PSPayTextField *)textField textDidChange:(NSString *)text
{
    _psdStrOne = textField.text;
    
}

#pragma mark - Action
- (IBAction)nextAction {
    if(_settingStep == SettingPayStepOne)
    {
        SettingPayPasswordViewController *vc = [[SettingPayPasswordViewController alloc]init];
        vc.settingStep = SettingPayStepTwo;
        vc.psdStrTwo = _psdStrOne;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
       
        if (![_psdStrOne isEqual:_psdStrTwo]) {
            [MBProgressHUD showMessag:@"两次输入的密码不一致，请重新输入" toView:self.view];
            return;
        }
        MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
        [self.httpUtil requestDic4MethodName:@"user/resetepaymentpwd" parameters:@{@"RepaymentPwd":_psdStrTwo} result:^(NSDictionary *dic, int status, NSString *msg) {
            if (status == 1 || status == 2) {
                [hud dismissSuccessStatusString:msg hideAfterDelay:1.0];
                
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 4] animated:YES];
            }else{
                [hud dismissMsgStatusString:msg hideAfterDelay:1.0];
            }
        }];
    }
}

- (IBAction)forgetPayPassword
{
    // 跳转身份验证
    IdentityTestViewController *vc = [[IdentityTestViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
