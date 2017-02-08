//
//  ModifyPasswordViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/7.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "ValidateUtil.h"

@interface ModifyPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPsdTextField;
@property (weak, nonatomic) IBOutlet UITextField *newsPsdTextField;
@property (weak, nonatomic) IBOutlet UITextField *commitPsdTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改登录密码";
    [self backBarItem];
    
    _commitBtn.layer.cornerRadius = 5.0f;
    
    [_oldPsdTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_newsPsdTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_commitPsdTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldChange:(UITextField *)textField
{
    
    if (IsStrEmpty(_oldPsdTextField.text)) {
        _commitBtn.userInteractionEnabled = NO;
        _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (IsStrEmpty(_newsPsdTextField.text)){
        _commitBtn.userInteractionEnabled = NO;
        _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (IsStrEmpty(_commitPsdTextField.text)){
        _commitBtn.userInteractionEnabled = NO;
        _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (!IsStrEmpty(_oldPsdTextField.text) && !IsStrEmpty(_newsPsdTextField.text) && !IsStrEmpty(_commitPsdTextField.text)){
        _commitBtn.userInteractionEnabled = YES;
        _commitBtn.backgroundColor = NaviColor;
    }
}
- (IBAction)commitBtnClick:(id)sender {
    if (![_newsPsdTextField.text isEqual:_commitPsdTextField.text]) {
        [MBProgressHUD showError:@"您输入的两次密码不一致,请重新输入" toView:self.view];
        return;
    }
    
    if (_commitPsdTextField.text.length < 8) {
        [MBProgressHUD showError:@"请输入最小为8个字符的密码" toView:self.view];
        return;
    }
    if ([ValidateUtil characterCountOfString:_commitPsdTextField.text] == _commitPsdTextField.text.length || [ValidateUtil characterCharCountOfString:_commitPsdTextField.text] == _commitPsdTextField.text.length) {
        [MBProgressHUD showError:nil toView:self.view];
        NSArray *huds = [MBProgressHUD allHUDsForView:self.view];
        MBProgressHUD *hud = huds[0];
        hud.detailsLabelText = @"密码由字母，数字和特殊字符组成，且必须包含字母";
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"user/modifypwd" parameters:@{@"Password":_oldPsdTextField.text,@"NewPassword":_newsPsdTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [hud dismissSuccessStatusString:@"修改成功" hideAfterDelay:0.5];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    }];
}

- (void)delayMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
