//
//  ResetPsdViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/1.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ResetPsdViewController.h"
#import "ValidateUtil.h"

@interface ResetPsdViewController ()
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UITextField *firstPsdTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondPsdTextField;


@end

@implementation ResetPsdViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"重置密码";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    
    _finishBtn.layer.cornerRadius = 5.0f;
    _finishBtn.userInteractionEnabled = NO;
    
    [_firstPsdTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_secondPsdTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldChange:(UITextField *)textField
{
    if (IsStrEmpty(_firstPsdTextField.text)) {
        _finishBtn.userInteractionEnabled = NO;
        _finishBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (IsStrEmpty(_secondPsdTextField.text)){
        _finishBtn.userInteractionEnabled = NO;
        _finishBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (!IsStrEmpty(_firstPsdTextField.text) && !IsStrEmpty(_secondPsdTextField.text)){
        _finishBtn.userInteractionEnabled = YES;
        _finishBtn.backgroundColor = NaviColor;
    }
}
- (IBAction)finishClickEvent:(id)sender {
    if (![_firstPsdTextField.text isEqual:_secondPsdTextField.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致，请重新输入" toView:self.view];
        return;
    }
    if (_secondPsdTextField.text.length < 8) {
        [MBProgressHUD showError:@"请输入最小为8个字符的密码" toView:self.view];
        return;
    }
    if ([ValidateUtil characterCountOfString:_secondPsdTextField.text] == _secondPsdTextField.text.length || [ValidateUtil characterCharCountOfString:_secondPsdTextField.text] == _secondPsdTextField.text.length) {
        [MBProgressHUD showError:nil toView:self.view];
        NSArray *huds = [MBProgressHUD allHUDsForView:self.view];
        MBProgressHUD *hud = huds[0];
        hud.detailsLabelText = @"密码由字母，数字和特殊字符组成，且必须包含字母";
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"user/resetpwd" parameters:@{@"UserName":_accountStr,@"Password":_secondPsdTextField.text,@"Mobile":_iphoneStr} result:^(NSDictionary *dic, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
            
            [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    }];
}

- (void)delayMethod
{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
