//
//  RegisterFirsViewController.m
//  NiuduFinance
//
//  Created by 123 on 17/2/5.
//  Copyright © 2017年 liuyong. All rights reserved.
//

#import "RegisterFirsViewController.h"
//#import "RegisterSecondViewController.h"
#import "ValidateUtil.h"
#import "GestureViewController.h"
#import "User.h"
#import "AppDelegate.h"
#import "PCCircleViewConst.h"

@interface RegisterFirsViewController ()<UITableViewDataSource,UITableViewDelegate,GestureViewControllerDelegate,UITextFieldDelegate>{
    
    int timerSecond;

}
@property (strong, nonatomic) NSTimer *deadTimer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *heardView;
@property (nonatomic, strong) UILabel * phoneLabel;
@property (nonatomic, strong) UITextField * phoneTextField;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UITextField * nameTextField;
@property (nonatomic, strong) UILabel * pwsLabel;
@property (nonatomic, strong) UITextField * pwsTextField;
@property (nonatomic, strong) UILabel * surePwsLabel;
@property (nonatomic, strong) UITextField * surePwsTextField;
@property (nonatomic, strong) UILabel * invitationLabel;
@property (nonatomic, strong) UITextField * invitationTextField;
@property (nonatomic, strong) UILabel * verificationLabel;
@property (nonatomic, strong) UITextField * verificationTextField;
@property (nonatomic, strong) UIButton * verifiBtn;

@property (nonatomic, strong) UILabel * yanLabel;
@property (nonatomic, strong) UIButton * yanBtn;

@property (nonatomic,strong) NSDictionary *numDic;
@property (nonatomic,strong) User * user;

@end
#define kHeaderViewHeight 166

@implementation RegisterFirsViewController

#pragma mark get checkNumber
-(void)flashBtnStatus{
    timerSecond --;
    if (timerSecond == 0) {
        _verifiBtn.backgroundColor = [UIColor colorWithHexString:@"#fcf0ea"];
        [_verifiBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [_verifiBtn setTitleColor:[UIColor colorWithHexString:@"#F1835F"] forState:UIControlStateNormal];
        _verifiBtn.userInteractionEnabled = YES;
        [self stopTimer];
    }else{
        
        [_verifiBtn setTitle:[NSString stringWithFormat:@"获取中(%d)",timerSecond] forState:UIControlStateNormal];
    }
}
-(void)startTimer{
    if (!self.deadTimer) {
        timerSecond = 120;
        _verifiBtn.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [_verifiBtn setTitleColor:[UIColor colorWithHexString:@"#bfbfbf"] forState:UIControlStateNormal];
        [_verifiBtn setTitle:[NSString stringWithFormat:@"获取中(%d)",timerSecond] forState:UIControlStateNormal];
        _verifiBtn.userInteractionEnabled = NO;
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
    _numDic = [NSDictionary dictionary];
    
    if (SCREEN_WIDTH == 320) {
        _heardView.height = 105;
    }if (SCREEN_WIDTH == 375) {
        _heardView.height = 166;
    }
    
    [self setupNavi];
    [self setupTableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    _phoneLabel = [UILabel new];
    _phoneLabel.text = @"手机号码：";
    _phoneLabel.font = [UIFont systemFontOfSize:15];
    
    _phoneTextField = [UITextField new];
    _phoneTextField.placeholder = @"请输入手机号码";
    _phoneTextField.font = [UIFont systemFontOfSize:14];
    [_phoneTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"用  户  名:";
    _nameLabel.font = [UIFont systemFontOfSize:15];
    
    _nameTextField = [UITextField new];
    _nameTextField.placeholder = @"请输入用户名";
    _nameTextField.font = [UIFont systemFontOfSize:14];

    _pwsLabel = [UILabel new];
    _pwsLabel.text = @"密        码:";
    _pwsLabel.font = [UIFont systemFontOfSize:15];
    
    _pwsTextField = [UITextField new];
    _pwsTextField.placeholder = @"请输入密码";
    _pwsTextField.font = [UIFont systemFontOfSize:14];
    [_pwsTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    _surePwsLabel = [UILabel new];
    _surePwsLabel.text = @"确认密码:";
    _surePwsLabel.font = [UIFont systemFontOfSize:15];
    
    _surePwsTextField = [UITextField new];
    _surePwsTextField.placeholder = @"请再次输入密码";
    _surePwsTextField.font = [UIFont systemFontOfSize:14];
    [_surePwsTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    _invitationLabel = [UILabel new];
    _invitationLabel.text = @"邀  请  人:";
    _invitationLabel.font = [UIFont systemFontOfSize:15];
    
    _invitationTextField = [UITextField new];
    _invitationTextField.placeholder = @"请输入码，可以为空";
    _invitationTextField.font = [UIFont systemFontOfSize:14];
    
    _verificationLabel = [UILabel new];
    _verificationLabel.text = @"验  证  码:";
    _verificationLabel.font = [UIFont systemFontOfSize:15];
    
    _verificationTextField = [UITextField new];
    _verificationTextField.placeholder = @"请输入验证码";
    _verificationTextField.font = [UIFont systemFontOfSize:14];
    [_verificationTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    _verifiBtn = [UIButton new];
    _verifiBtn.layer.cornerRadius = 5.0f;
    //交互性
    _verifiBtn.userInteractionEnabled = YES;
    _verifiBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _verifiBtn.backgroundColor = [UIColor colorWithHexString:@"#019BFF"];
    [_verifiBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verifiBtn addTarget:self action:@selector(verifiBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//    _yanLabel = [UILabel new];
//    _yanLabel.text = @"* 验证码已发送，请120s后再次获取";
//    _yanLabel.font = [UIFont systemFontOfSize:13];
//    _yanLabel.textColor = [UIColor colorWithHexString:@"#019BFF"];
//    [_tableView addSubview: _yanLabel];
//    if (SCREEN_WIDTH == 320) {
//        _yanLabel.height = 278;
//    }if (SCREEN_WIDTH == 375) {
//        _yanLabel.height = 338;
//    }
//    [_yanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_tableView.mas_top).with.offset(_yanLabel.height);
//        make.left.mas_equalTo(19);
//
//    }];
    
    _yanBtn = [UIButton new];
    _yanBtn.layer.cornerRadius = 4.0f;
    _yanBtn.userInteractionEnabled = YES;
    _yanBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_yanBtn setTitle:@"注册即享100元现金" forState:UIControlStateNormal];
    _yanBtn.backgroundColor = [UIColor colorWithHexString:@"#019BFF"];
    [_yanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yanBtn addTarget:self action:@selector(yanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:_yanBtn];
    if (SCREEN_WIDTH == 320) {
        _yanBtn.height = 310;
    }if (SCREEN_WIDTH == 375) {
        _yanBtn.height = 369;
    }
    [_yanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_top).with.offset(_yanBtn.height);
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(45);
    }];
    
    
}

- (void)viewDidLayoutSubviews
{
    // headerView
    [_heardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView).offset(-_heardView.height);
        make.left.width.equalTo(self.tableView);
        make.height.equalTo(@(_heardView.height));
    }];
    
}



- (void)textFieldChange:(UITextField *)textField
{
    if (IsStrEmpty(_phoneTextField.text)) {
        _yanBtn.userInteractionEnabled = YES;
//        _yanBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (IsStrEmpty(_verificationTextField.text)){
        _yanBtn.userInteractionEnabled = YES;
//        _yanBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (IsStrEmpty(_nameTextField.text)){
        _yanBtn.userInteractionEnabled = YES;
//        _yanBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (IsStrEmpty(_pwsTextField.text)){
        _yanBtn.userInteractionEnabled = YES;
//        _yanBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (IsStrEmpty(_surePwsTextField.text)){
        _yanBtn.userInteractionEnabled = YES;
//        _yanBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    } else if (!IsStrEmpty(_phoneTextField.text) && !IsStrEmpty(_verificationTextField.text) && !IsStrEmpty(_pwsTextField.text) && !IsStrEmpty(_surePwsTextField.text)
               ){
        _yanBtn.userInteractionEnabled = YES;
//        _yanBtn.backgroundColor = NaviColor;
    }
}



- (void)verifiBtn:(UIButton *)btn{
    //  获取验证码增加判断
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodNam:@"v2/open/verifycode/getRegisterVerifyCode" parameters:@{@"mobile":_phoneTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        
        NSLog(@"-------%@",_phoneTextField.text);
        if (status == 1 || status == 2) {
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];

        }else{
            _numDic = dic;
            _verifiBtn.userInteractionEnabled = YES;
            [self startTimer];
            [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
        }
    }];
//    [self startTimer]
    NSLog(@"1234165");
}

- (void)yanBtnClick:(UIButton *)btn{
    
    

    NSLog(@"66666666");
    if (_phoneTextField.text.length<11) {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
        return;
    }else if (![self isValidateUsername] || _nameTextField.text.length < 6 || _nameTextField.text.length > 15)
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
    }else if (_pwsTextField.text.length < 8)
        
    {
        [MBProgressHUD showError:@"请输入最小为8个字符的密码" toView:self.view];
        return;
    }else  if ([ValidateUtil characterCountOfString:_pwsTextField.text] == _pwsTextField.text.length || [ValidateUtil characterCharCountOfString:_pwsTextField.text] == _pwsTextField.text.length)
        
    {
        [MBProgressHUD showError:nil toView:self.view];
        NSArray *huds = [MBProgressHUD allHUDsForView:self.view];
        MBProgressHUD *hud = huds[0];
        hud.detailsLabelText = @"密码由字母，数字和特殊字符组成，且必须包含字母";
        return;
    }else if (![_pwsTextField.text isEqual:_surePwsTextField.text])
        
    {
        [MBProgressHUD showError:@"两次输入的密码不一致，请重新输入" toView:self.view];
        return;
    }else if (_verificationTextField.text.length != 6){
        [MBProgressHUD showError:@"验证码错误" toView:self.view];
        return;
    }
    
    
    [self.httpUtil requestDic4MethodNam:@"v2/open/user/register" parameters:@{@"verifyCode":_verificationTextField.text,@"mobile":_phoneTextField.text,@"username":_nameTextField.text,@"password":_pwsTextField.text,@"inviter":_invitationTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        
        if (status == 1 || status == 2) {

            [AppDelegate loginMain];
        }else{

            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.2];
        }
    }];
}



- (void)delayMethod
{
    [self.httpUtil requestObj4MethodName:@"user/login" parameters:@{@"UserName":_nameTextField.text,@"Password":_pwsTextField.text} result:^(id obj, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD showError:msg toView:self.view];
        }else{
            _user = (User *)obj;
            _user.password = _pwsTextField.text;
            [_user saveUser];
            [_user saveLogin];
            [AppDelegate loginMain];
        }
    } convertClassName:@"User" key:nil];
}

- (void)setupNavi
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.title = @"注册";
    
    UIButton *customView = [UIButton buttonWithType:UIButtonTypeCustom];
    customView.frame = CGRectMake(0, 0, 44, 44);
    customView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [customView setImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal];
    [customView addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
}

- (void)setupTableView
{
    self.tableView.contentInset = UIEdgeInsetsMake(_heardView.height, 0, 0,0);
    [self.tableView addSubview:_heardView];
    //禁止滚动
//    self.tableView.scrollEnabled = NO;

    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * celldentifier = @"celldentifier";
     UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:celldentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celldentifier];
    }
    
    if (indexPath.row == 0) {
        [cell addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(20);
        }];
        
        [cell addSubview:_phoneTextField];
        [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.equalTo(@109);
            make.width.mas_equalTo(120);
        }];
        
    }else if (indexPath.row == 1){
        
        [cell addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(20);
        }];
        
        [cell addSubview:_nameTextField];
        [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.equalTo(@109);
            make.width.mas_equalTo(120);
        }];
    }else if (indexPath.row == 2){
        
        [cell addSubview:_pwsLabel];
        [_pwsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(20);
        }];
        
        [cell addSubview:_pwsTextField];
        [_pwsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.equalTo(@109);
            make.width.mas_equalTo(120);
        }];
        
    }else if (indexPath.row == 3){
        
        [cell addSubview:_surePwsLabel];
        [_surePwsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(20);
        }];
        
        [cell addSubview:_surePwsTextField];
        [_surePwsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.equalTo(@109);
            make.width.mas_equalTo(120);
        }];
    }else if (indexPath.row == 4){
        
        [cell addSubview:_invitationLabel];
        [_invitationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(20);
        }];
        
        [cell addSubview:_invitationTextField];
        [_invitationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.equalTo(@109);
            make.width.mas_equalTo(150);
        }];
        
    }else if (indexPath.row == 5){
        
        [cell addSubview:_verificationLabel];
        [_verificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(20);
        }];
        
        [cell addSubview:_verificationTextField];
        [_verificationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.equalTo(@109);
            make.width.mas_equalTo(95);
        }];
        
        [cell addSubview:_verifiBtn];
        [_verifiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(11);
            make.left.equalTo(@218);
            make.width.mas_equalTo(95);
        }];
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    
    if (SCREEN_WIDTH == 320) {
        return 45;
    }else
    
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (BOOL)isValidateUsername;
{
    NSString *regex = @"^[a-zA-Z0-9_]*[a-zA-Z]+[a-zA-Z0-9_]*$";   //以A开头，e结尾
    //    @"name MATCHES %@",regex
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //    [regextestmobile evaluateWithObject:_userNameTextField.text];
    
    return [regextestmobile evaluateWithObject:_nameTextField.text];
}

@end
