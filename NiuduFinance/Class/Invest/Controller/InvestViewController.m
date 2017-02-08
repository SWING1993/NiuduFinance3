//
//  InvestViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/24.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "InvestViewController.h"
#import "ProvincesViewController.h"
#import "ZHPickView.h"
#import "ZHBPickerView.h"
#import "Province.h"
#import "City.h"
#import "District.h"
#import "User.h"
#import "RealNameCertificationViewController.h"
#import "MoreViewController.h"

@interface InvestViewController ()<ZHPickViewDelegate,ZHBPickerViewDataSource,ZHBPickerViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *borrowBtn;
@property (weak, nonatomic) IBOutlet UIButton *realNameCheckBtn;
@property (weak, nonatomic) IBOutlet UITextField *sexTextField;
@property (weak, nonatomic) IBOutlet UITextField *loanPeriodTextField;
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *loanMoneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *incomeTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UILabel *realNameLab;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic,strong)ZHPickView *zhPickView;
@property (nonatomic,strong)ZHBPickerView *zhBPickerView;

@property (nonatomic,strong)NSArray *sexArr;
@property (nonatomic,strong)NSArray *loanPeriodArr;

@property (nonatomic,strong)UIWindow *window;

@property (nonatomic,strong)NSMutableDictionary *addressDic;

@property (nonatomic,assign)BOOL pickBool;

@property (nonatomic,assign)BOOL zhPickBool;
@property (nonatomic,assign)BOOL zhBPickBool;
@end

@implementation InvestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _borrowBtn.layer.cornerRadius = 5.0f;
    
    _pickBool = NO;
    _zhPickBool = NO;
    _zhBPickBool = NO;
    
    _window = [[[UIApplication sharedApplication] windows] lastObject];
}



- (NSDictionary *)addressDic
{
    if (!_addressDic)
    {
        _addressDic = [NSMutableDictionary dictionary];
    }
    return _addressDic;
}

- (IBAction)moreClickEvent:(id)sender {
    [_zhPickView remove];
    [_zhBPickerView removeFromSuperview];
    [_iphoneTextField resignFirstResponder];
    [_loanMoneyTextField resignFirstResponder];
    [_incomeTextField resignFirstResponder];
    MoreViewController *moreVC = [MoreViewController new];
    moreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreVC animated:YES];
}
//  选择城市
- (IBAction)selectCityClick:(id)sender {
    [_zhPickView remove];
    [_zhBPickerView removeFromSuperview];
    [_iphoneTextField resignFirstResponder];
    [_loanMoneyTextField resignFirstResponder];
    [_incomeTextField resignFirstResponder];
    ProvincesViewController *provinceVC = [ProvincesViewController new];
    self.addressDic = [NSMutableDictionary dictionary];
    provinceVC.addressDic = self.addressDic;
    [self.navigationController pushViewController:provinceVC animated:YES];
}

- (void)updateAddress
{
    if ([[self.addressDic allKeys] containsObject:kDistrictKey])
    {
        
        Province *province =[_addressDic valueForKey:kProvincesKey];
        City *city = [_addressDic valueForKey:kCityKey];
        District *district = [_addressDic valueForKey:kDistrictKey];
        _cityTextField.text = [NSString stringWithFormat:@"%@-%@-%@",province.name,city.name,district.name];
        
    }
}

//  去实名认证
- (IBAction)realNameCheckClick:(id)sender {
    [_zhPickView remove];
    [_zhBPickerView removeFromSuperview];
    [_iphoneTextField resignFirstResponder];
    [_loanMoneyTextField resignFirstResponder];
    [_incomeTextField resignFirstResponder];
    if ([_realNameLab.text isEqual:@"需要先实名认证"]) {
        //   跳转到实名认证页面
        RealNameCertificationViewController *realNameVC = [RealNameCertificationViewController new];
        [self.navigationController pushViewController:realNameVC animated:YES];
    }
}
//  称谓
- (IBAction)sexClick:(id)sender {
    [_zhPickView remove];
    [_zhBPickerView removeFromSuperview];
    [_iphoneTextField resignFirstResponder];
    [_loanMoneyTextField resignFirstResponder];
    [_incomeTextField resignFirstResponder];
    
    
    if (_zhPickBool == NO) {
        _zhPickBool = YES;
        self.tabBarController.tabBar.hidden = YES;
        _zhBPickerView =  [[[NSBundle mainBundle] loadNibNamed:@"ZHBPickerView" owner:self options:nil] firstObject];
        
        _zhBPickerView.dataSource = self;
        _zhBPickerView.delegate = self;
        _zhBPickerView.frame = CGRectMake(0, SCREEN_HEIGHT - 150, SCREEN_WIDTH, 150);
        _zhBPickerView.tag = 1;
        [_window addSubview:_zhBPickerView];
        
        self.sexArr = @[@"男士",@"女士"];
    }else{
        _zhPickBool = NO;
        self.tabBarController.tabBar.hidden = NO;
        [_zhBPickerView removeFromSuperview];
    }
    
}
//  选择日历
- (IBAction)calendarClick:(id)sender {
    self.tabBarController.tabBar.hidden = NO;
    [_zhBPickerView removeFromSuperview];
    [_iphoneTextField resignFirstResponder];
    [_loanMoneyTextField resignFirstResponder];
    [_incomeTextField resignFirstResponder];
    
    if (_pickBool == NO) {
        _pickBool = YES;
        NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000000];
        _zhPickView=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
        [_zhPickView setTintColor:[UIColor colorWithHexString:@"#007AFF"]];
        [_zhPickView setToolbarTintColor:[UIColor whiteColor]];
        _zhPickView.delegate=self;
        [_zhPickView show];
    }else{
        _pickBool = NO;
        [_zhPickView remove];
    }
    
}
//   ZHPickView delegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    NSString *dateStr = [NSString stringWithFormat:@"%@",[resultString substringToIndex:10]];
    self.dateTextField.text = dateStr;
}
//  借款期限
- (IBAction)borrowTimeClick:(id)sender {
    [_zhPickView remove];
    [_zhBPickerView removeFromSuperview];
    [_iphoneTextField resignFirstResponder];
    [_loanMoneyTextField resignFirstResponder];
    [_incomeTextField resignFirstResponder];
    
    
    if (_zhBPickBool == NO) {
        _zhBPickBool = YES;
        self.tabBarController.tabBar.hidden = YES;
        _zhBPickerView =  [[[NSBundle mainBundle] loadNibNamed:@"ZHBPickerView" owner:self options:nil] firstObject];
        
        _zhBPickerView.dataSource = self;
        _zhBPickerView.delegate = self;
        _zhBPickerView.frame = CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200);
        _zhBPickerView.tag = 2;
        [_window addSubview:_zhBPickerView];
        
        self.loanPeriodArr = @[@"1个月",@"2个月",@"3个月",@"4个月",@"5个月",@"6个月",@"7个月",@"8个月",@"9个月",@"10个月",@"11个月",@"1年",@"2年",@"3年",@"4年",@"5年",@"6年",@"7年",@"8年",@"9年",@"10年"];
    }else{
        _zhBPickBool = NO;
        self.tabBarController.tabBar.hidden = NO;
        [_zhBPickerView removeFromSuperview];
    }
    
}
//   zhBPickerView  delegate
- (NSInteger)numberOfComponentsInPickerView:(ZHBPickerView *)pickerView
{
    return 1;
}

- (NSArray *)pickerView:(ZHBPickerView *)pickerView titlesForComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
        if (component == 0) {
            return _sexArr;
        }
    }else if (pickerView.tag == 2){
        if (component == 0) {
            return _loanPeriodArr;
        }
    }
    return nil;
}

- (void)pickerView:(ZHBPickerView *)pickerView didSelectContent:(NSString *)content
{
    self.tabBarController.tabBar.hidden = NO;
    if (pickerView.tag == 1) {
        _sexTextField.text = content;
        if ([content isEqual:@""]) {
            _sexTextField.text = _sexArr[0];
        }
    }else if (pickerView.tag == 2){
        _loanPeriodTextField.text = content;
        if ([content isEqual:@""]) {
            _loanPeriodTextField.text = _loanPeriodArr[0];
        }
    }
}

- (void)cancelSelectPickerView:(ZHBPickerView *)pickerView
{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.tabBarController.tabBar.hidden = NO;
    [_zhPickView remove];
    [_zhBPickerView removeFromSuperview];
}
- (IBAction)applyClickEvent:(id)sender {
    if (IsStrEmpty(_cityTextField.text) || IsStrEmpty(_iphoneTextField.text) || IsStrEmpty(_sexTextField.text) || IsStrEmpty(_loanMoneyTextField.text) || IsStrEmpty(_loanPeriodTextField.text) || IsStrEmpty(_incomeTextField.text) || IsStrEmpty(_dateTextField.text) || [_realNameLab.text isEqual:@"需要先实名认证"]) {
        [MBProgressHUD showMessag:@"信息不完整，请重新填写" toView:self.view];
        return;
    }
    NSString *loanPeriodStr = [_loanPeriodTextField.text substringToIndex:1];
    if ([[_loanPeriodTextField.text substringFromIndex:1] isEqual:@"年"]) {
        loanPeriodStr = [NSString stringWithFormat:@"%d",loanPeriodStr.intValue * 12];
    }
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    _borrowBtn.userInteractionEnabled = NO;
    [self.httpUtil requestDic4MethodName:@"Project/PostLoan" parameters:@{@"Birthday":_dateTextField.text,@"Amount":_loanMoneyTextField.text,@"LoanPeriod":loanPeriodStr,@"Income":_incomeTextField.text,@"City":_cityTextField.text,@"ContactName":_realNameLab.text,@"ContactMobile":_iphoneTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            _borrowBtn.userInteractionEnabled = NO;
            _borrowBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
            [_borrowBtn setTitle:@"借款申请处理中,请等待..." forState:UIControlStateNormal];
            [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
        }else{
            [_borrowBtn setTitle:@"立即申请" forState:UIControlStateNormal];
            _borrowBtn.backgroundColor = [UIColor colorWithHexString:@"#F5635D"];
            _borrowBtn.userInteractionEnabled = YES;
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hideNaviBar = YES;
    [self updateAddress];
    [self getInfoMsg];
    
    if (IsStrEmpty([User userFromFile].realName)) {
        _realNameLab.text = @"需要先实名认证";
    }else{
        _realNameLab.text = [User userFromFile].realName;
    }
    
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0) {
        CGFloat scaleW = 1 - offsetY / 150;
        CGFloat scaleH = 1 - offsetY / 70;
        self.headerView.transform = CGAffineTransformMakeScale(scaleW, scaleH);
    }
}

- (void)getInfoMsg
{
    [self.httpUtil requestDic4MethodName:@"project/ispostloan" parameters:@{@"UserId":@([User userFromFile].userId)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            if ([[dic objectForKey:@"ApplyCount"] intValue] == 1) {
                [_borrowBtn setTitle:@"借款申请处理中,请等待..." forState:UIControlStateNormal];
                _borrowBtn.userInteractionEnabled = NO;
                _borrowBtn.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
            }else{
                [_borrowBtn setTitle:@"立即申请" forState:UIControlStateNormal];
                _borrowBtn.backgroundColor = [UIColor colorWithHexString:@"#F5635D"];
                _borrowBtn.userInteractionEnabled = YES;
            }
        }else{
            _borrowBtn.userInteractionEnabled = YES;
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.hideNaviBar = NO;
}

#pragma mark  UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.tabBarController.tabBar.hidden = NO;
    [_zhPickView remove];
    [_zhBPickerView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
