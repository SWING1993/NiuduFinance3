//
//  AddBankCardViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/8.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "OptionBankTypeView.h"
#import "ZHBPickerView.h"
#import "User.h"
#import "ProvincesViewController.h"
#import "Province.h"
#import "City.h"
#import "District.h"
#import "DepositBankViewController.h"

@interface AddBankCardViewController ()<ZHBPickerViewDataSource,ZHBPickerViewDelegate,UITextFieldDelegate,ChangeDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionBankTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *bankCardTextField;
@property (weak, nonatomic) IBOutlet UILabel *optionAddressLabel;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTextField;
@property (strong, nonatomic) IBOutlet OptionBankTypeView *optionBankCardView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic,strong)UIWindow *window;
@property (nonatomic,strong)ZHBPickerView *zhBPickerView;
@property (weak, nonatomic) IBOutlet UIButton *zhbBtn;

@property (nonatomic,strong)NSArray *bankTypeArr;
@property (nonatomic,strong)NSMutableArray *bankNameArr;
@property (nonatomic,strong)NSString *optionIdStr;
@property (nonatomic,assign)int districtId;

@property (nonatomic,strong)NSMutableDictionary *addressDic;
@end

@implementation AddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
//    [self backBarItem];
    
    [self setNaviBack];
    _nameLabel.text = [User userFromFile].realName;
    _commitBtn.layer.cornerRadius = 5.0f;
    _window = [[[UIApplication sharedApplication] windows] lastObject];
    _bankTypeArr = [NSArray array];
    _bankNameArr = [NSMutableArray array];
    _optionIdStr = nil;
    _districtId = 0;
    [self getBankTypeData];

}

#pragma mark 自定义NaviBack
- (void)setNaviBack
{
    [self setupBarButtomItemWithImageName:@"nav_back_normal.png" highLightImageName:@"nav_back_select.png" selectedImageName:nil target:self action:@selector(backClick) leftOrRight:YES];
}
- (void)backClick
{
    [_zhBPickerView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateAddress];
}

- (NSDictionary *)addressDic
{
    if (!_addressDic)
    {
        _addressDic = [NSMutableDictionary dictionary];
    }
    return _addressDic;
}

- (void)getBankTypeData
{
    [self.httpUtil requestArr4MethodName:@"fund/getbanktype" parameters:nil result:^(NSArray *arr, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
            _bankTypeArr = arr;
            
            for (int i = 0; i < _bankTypeArr.count; i ++) {
                _bankNameArr[i] = [_bankTypeArr[i] objectForKey:@"Name"];
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    } convertClassName:nil key:nil];
}

#pragma mark - Actions
- (IBAction)textDidChanged:(UITextField *)sender {
    
}

- (IBAction)optionBankType {
    
    [_bankCardTextField resignFirstResponder];
    [_bankNameTextField resignFirstResponder];
    
    if (_zhbBtn.tag == 1) {
        _zhbBtn.tag = 2;
        _zhBPickerView =  [[[NSBundle mainBundle] loadNibNamed:@"ZHBPickerView" owner:self options:nil] firstObject];
        
        _zhBPickerView.dataSource = self;
        _zhBPickerView.delegate = self;
        
        _zhBPickerView.frame = CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200);
        [_window addSubview:_zhBPickerView];
    }else{
        _zhbBtn.tag = 1;
        [_zhBPickerView removeFromSuperview];
    }
    
}
- (IBAction)optionAddress {
    
    [_zhBPickerView removeFromSuperview];
    [_bankCardTextField resignFirstResponder];
    [_bankNameTextField resignFirstResponder];
    
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
        _optionAddressLabel.text = [NSString stringWithFormat:@"%@-%@-%@",province.name,city.name,district.name];
        _optionAddressLabel.textColor = [UIColor colorWithHexString:@"#444444"];
        _districtId = district.Id;
    }
}

- (IBAction)optionBankName {
    
    if ([_optionBankTypeLabel.text isEqual:@"请选择所属银行"]) {
        [MBProgressHUD showMessag:@"请先选择所在银行" toView:self.view];
        return;
    }
    if ([_optionAddressLabel.text isEqual:@"请选择所在地"]) {
        [MBProgressHUD showMessag:@"请先选择所在地" toView:self.view];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestArr4MethodName:@"fund/getbankbranch" parameters:@{@"DistrictId":@(_districtId),@"BankTypeId":_optionIdStr} result:^(NSArray *arr, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            if (arr.count == 0) {
                [hud dismissMsgStatusString:@"没有所在开户行,请填写" hideAfterDelay:1.0];
            }else{
                [hud hide:YES];
                DepositBankViewController *depositBankVC = [DepositBankViewController new];
                depositBankVC.depositArr = arr;
                depositBankVC.delegate = self;
                [self.navigationController pushViewController:depositBankVC animated:YES];
            }
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    } convertClassName:nil key:nil];
    
}

- (IBAction)confirmAction {
    if (IsStrEmpty(_bankCardTextField.text) || IsStrEmpty(_bankNameTextField.text)) {
        [MBProgressHUD showMessag:@"信息不完整,请填写" toView:self.view];
        return;
    }
    
    if (_bankCardTextField.text.length > 23 || _bankCardTextField.text.length < 19) {
        [MBProgressHUD showMessag:@"银行卡位数不正确，请重新填写" toView:self.view];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    _commitBtn.userInteractionEnabled = NO;
    [self.httpUtil requestDic4MethodName:@"bankcard/add" parameters:@{@"RealName":_nameLabel.text,@"BankNumber":_bankCardTextField.text,@"BranchName":_bankNameTextField.text,@"BankTypeId":_optionIdStr,@"DistrictId":@(_districtId)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if ( status == 1 || status == 2) {
            [hud dismissSuccessStatusString:msg hideAfterDelay:1.0];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
            _commitBtn.userInteractionEnabled = YES;
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
            _commitBtn.userInteractionEnabled = YES;
        }
    }];
}

- (void)delayMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

//   zhBPickerView  delegate
- (NSInteger)numberOfComponentsInPickerView:(ZHBPickerView *)pickerView
{
    return 1;
}

- (NSArray *)pickerView:(ZHBPickerView *)pickerView titlesForComponent:(NSInteger)component
{
    if (component == 0) {
        return _bankNameArr;
    }
    return nil;
}

- (void)pickerView:(ZHBPickerView *)pickerView didSelectContent:(NSString *)content
{
    
    _optionBankTypeLabel.text = content;
    _optionBankTypeLabel.textColor = [UIColor colorWithHexString:@"#444444"];
    if ([content isEqual:@""]) {
        _optionBankTypeLabel.text = _bankNameArr[0];
        _optionIdStr = [_bankTypeArr[0] objectForKey:@"Id"];
    }else{
        for (int i = 0; i < _bankTypeArr.count; i ++) {
            if ([content isEqual:[_bankTypeArr[i] objectForKey:@"Name"]]) {
                _optionIdStr = [_bankTypeArr[i] objectForKey:@"Id"];
            }
        }
    }
}

- (void)cancelSelectPickerView:(ZHBPickerView *)pickerView
{
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_zhBPickerView removeFromSuperview];
}
//  开户行代理
- (void)changeTitle:(NSString *)changeStr
{
    _bankNameTextField.text = changeStr;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _bankCardTextField)
    {
        if (textField.text.length > 22)
        {
            return NO;
        }
        
        NSInteger textLenght = textField.text.length;
        if ((textLenght+1)%5 == 0 && ![string isEqualToString:@""])
        {
            textField.text = [textField.text stringByAppendingString:@" "];
        }
        
        if ([string isEqualToString:@""] && range.location >=5 && range.location%5 == 0)
        {
            textField.text = [textField.text stringByReplacingCharactersInRange:NSMakeRange(range.location-1, 2) withString:@""];
            return NO;
        }
    }
    return YES;
}

@end
