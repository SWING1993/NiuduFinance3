//
//  IdentityTestViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/8.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "IdentityTestViewController.h"
#import "SettingPayPasswordViewController.h"

@interface IdentityTestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mobileLab;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *idNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic,strong)NSDictionary *codeDic;
@end

@implementation IdentityTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份验证";
    [self backBarItem];
    
    _codeDic = [NSDictionary dictionary];
    
    _nextBtn.userInteractionEnabled = NO;
    _nextBtn.layer.cornerRadius = 5.0f;
    
    [_codeTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_idNumberTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldChange:(UITextField *)textField
{
    
    if (IsStrEmpty(_codeTextField.text)) {
        _nextBtn.userInteractionEnabled = NO;
        _nextBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (IsStrEmpty(_idNumberTextField.text)){
        _nextBtn.userInteractionEnabled = NO;
        _nextBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (!IsStrEmpty(_codeTextField.text) && !IsStrEmpty(_idNumberTextField.text)){
        _nextBtn.userInteractionEnabled = YES;
        _nextBtn.backgroundColor = NaviColor;
    }
}

- (void)setMobileStr:(NSString *)mobileStr
{
    _mobileStr = mobileStr;
    
    _mobileLab.text = [NSString stringWithFormat:@"短信验证码已发送到%@",[_mobileStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
    
    [self getCodeData];
}

- (void)getCodeData
{
    [self.httpUtil requestDic4MethodName:@"mobile/getVerifycode" parameters:@{@"Mobile":_mobileStr,@"Type":@(8)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
            _codeDic = dic;
            
            NSLog(@"------%@",_codeDic);
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (IBAction)nextAction
{
    [self.httpUtil requestDic4MethodName:@"user/repaymentpwd" parameters:@{@"Code":_codeTextField.text,@"IdNumber":_idNumberTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            SettingPayPasswordViewController *vc = [[SettingPayPasswordViewController alloc] init];
            vc.codeStr = _codeTextField.text;
            vc.idNumStr = _idNumberTextField.text;
            vc.settingStep = SettingPayStepOne;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
    
}

@end
