//
//  MyCreditorActionViewControllerNext.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/19.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MyCreditorActionViewControllerNext.h"
#import "WebProtocolViewController.h"
#import "DXPopover.h"
#import "User.h"
#import "MyCreditorViewController.h"
@interface MyCreditorActionViewControllerNext ()
@property (weak, nonatomic) IBOutlet UILabel *serviceMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *getMoneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIImageView *serviceMoneyDetail;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIImageView *getMoneyDetail;

@property (strong, nonatomic) NSTimer *deadTimer;

@property (nonatomic,strong)NSDictionary *CodeDic;

@end

@implementation MyCreditorActionViewControllerNext
{
    int timerSecond;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backBarItem];
    
    self.title = @"投资以及收益";
    _CodeDic = [NSDictionary dictionary];
    timerSecond = 0;
    _commitButton.layer.cornerRadius = 5.0f;
    _getCodeButton.layer.cornerRadius = 3.0f;
    _agreeButton.tag = 1;
    _codeLabel.keyboardType = UIKeyboardTypeNumberPad;
    _commitButton.userInteractionEnabled = NO;
    _commitButton.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    [_codeLabel  addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self addImageViewGesture];
}

- (void)textFieldChange:(UITextField *)textField
{
    
    if (IsStrEmpty(_codeLabel.text)) {
        _commitButton.userInteractionEnabled = NO;
        _commitButton.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else {
        _commitButton.userInteractionEnabled = YES;
        _commitButton.backgroundColor = NaviColor;
    }
}

- (void)addImageViewGesture{

    _serviceMoneyDetail.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceMoneyGesture:)];
    
//    gesture.numberOfTapsRequired = 1;
    [_serviceMoneyDetail addGestureRecognizer:gesture];
    
    _getMoneyDetail.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getMoneyGesture:)];
    
    [_getMoneyDetail addGestureRecognizer:gesture2];
}

- (void)serviceMoneyGesture:(UISwipeGestureRecognizer*)recognizer{

    //展示服务费说明
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 180, 50)];
    textLabel.numberOfLines = 2;
    textLabel.text = @"转让手续费收取实际成交金额的0.1%";
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:textLabel];
    DXPopover *popover = [DXPopover popover];
    [popover showAtView:_serviceMoneyDetail
         popoverPostion:DXPopoverPositionUp
        withContentView:view
                 inView:self.view];
}

- (void)getMoneyGesture:(UISwipeGestureRecognizer*)recognizer{
    
    //到账金额说明
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 180, 50)];
    textLabel.numberOfLines = 2;
    textLabel.text = @"成交金额经过四舍五入,到账金额会略微浮动";
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:textLabel];
    DXPopover *popover = [DXPopover popover];
    [popover showAtView:_getMoneyDetail
         popoverPostion:DXPopoverPositionUp
        withContentView:view
                 inView:self.view];
}

- (IBAction)getCode:(id)sender {
  User *myAccount =  [User userFromFile];
    if (IsStrEmpty(myAccount.mobile)) {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"mobile/getverifycode" parameters:@{@"Mobile":myAccount.mobile,@"Type":@(8)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            
            _CodeDic = dic;
            
            _getCodeButton.userInteractionEnabled = NO;
            [self startTimer];
            [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    }];
}

#pragma mark get checkNumber
-(void)flashBtnStatus{
    timerSecond --;
    if (timerSecond == 0) {
        _getCodeButton.backgroundColor = [UIColor colorWithHexString:@"#fcf0ea"];
        [_getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [_getCodeButton setTitleColor:[UIColor colorWithHexString:@"#F1835F"] forState:UIControlStateNormal];
        _getCodeButton.userInteractionEnabled = YES;
        [self stopTimer];
    }else{
        
        [_getCodeButton setTitle:[NSString stringWithFormat:@"获取中(%d)",timerSecond] forState:UIControlStateNormal];
    }
}
-(void)stopTimer{
    [self.deadTimer invalidate];
    self.deadTimer = nil;
}
-(void)dealloc{
    [self stopTimer];
}
-(void)startTimer{
    if (!self.deadTimer) {
        timerSecond = 60;
        _getCodeButton.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [_getCodeButton setTitleColor:[UIColor colorWithHexString:@"#bfbfbf"] forState:UIControlStateNormal];
        [_getCodeButton setTitle:[NSString stringWithFormat:@"获取中(%d)",timerSecond] forState:UIControlStateNormal];
        _getCodeButton.userInteractionEnabled = NO;
        self.deadTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(flashBtnStatus) userInfo:nil repeats:YES];
    }
}

- (IBAction)agreeButton:(id)sender {
    
    if (_agreeButton.tag == 1) {
        [_agreeButton setImage:[UIImage imageNamed:@"no_check"] forState:UIControlStateNormal];
        _agreeButton.tag = 2;
    }else if (_agreeButton.tag == 2){
        [_agreeButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
        _agreeButton.tag = 1;
    }
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    _serviceMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"serviceMoneyL"] floatValue]];
    _getMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"getMoney"] floatValue]];
    
}

- (IBAction)showProtocolButton:(id)sender {
    
    WebProtocolViewController *webProtocolVC = [WebProtocolViewController new];
    webProtocolVC.title = @"债权转让协议";
    webProtocolVC.webAddressStr = [self.httpUtil requWebName:@"/transferagreement.jsp" parameters:nil];
    
    [self.navigationController pushViewController:webProtocolVC animated:NO];
    
}
- (IBAction)commitButton:(id)sender {
    
    if (_codeLabel.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入验证码" toView:self.view];
    }
    else if (_agreeButton.tag == 2) {
        [MBProgressHUD showError:@"请同意协议" toView:self.view];
        
    }
    
    else{
        
        MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
        [self.httpUtil requestDic4MethodName:@"debtdeal/add" parameters:@{@"ProjectId":[_dic objectForKey:@"ProjectId"],@"PriceForSale":[_dic objectForKey:@"PriceForSale"],@"Code":_codeLabel.text} result:^(NSDictionary *dic, int status, NSString *msg) {
                    if (status == 1 || status == 2) {
                        [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
                        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
                    }else{
                        
                        [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
                    }
                }];
        
    }
}
- (void)delayMethod
{
    [self.navigationController popViewControllerAnimated:YES];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MyCreditorViewController class]]) {
            MyCreditorViewController *revise =(MyCreditorViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
        }
        
    }
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
