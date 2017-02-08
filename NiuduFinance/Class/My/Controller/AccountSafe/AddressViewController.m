//
//  AddressViewController.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/17.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "AddressViewController.h"
#import "ProvincesViewController.h"
#import "Province.h"
#import "City.h"
#import "District.h"
#import "NSString+Adding.h"

@interface AddressViewController ()
@property (nonatomic,strong)NSDictionary *addressDic;
//@property (nonatomic,assign)int districtId;
@end

@implementation AddressViewController
{
    NSInteger provinceid;
    NSInteger cityid ;
    NSInteger districtid;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self backBarItem];
    
    self.commitButton.layer.cornerRadius = 6.0f;
    self.commitButton.autoresizingMask = YES;
    self.phoneTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.addressTextFiled.userInteractionEnabled = NO;
    
    
    [self loadAddress];
}

#pragma mark -- 加载地址信息

- (void)loadAddress{

    
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    
    [self.httpUtil requestDic4MethodName:@"user/useraddress" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        
        if (status == 1 || status == 2) {
            [hud hide:YES];
            _addressDic = dic;
           
            provinceid = [[dic objectForKey:@"provinceid"] integerValue];
            
            cityid = [[dic objectForKey:@"cityid"] integerValue];
            
            districtid = [[dic objectForKey:@"districtid"] integerValue];
            [self setAddressInfo];
            
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
        
        
        
    }];
}

- (void)setAddressInfo{

    
    
    self.phoneTextFiled.text = [NSString stringWithFormat:@"%@",IsStrEmpty([_addressDic objectForKey:@"contactphone"])?@"":[_addressDic objectForKey:@"contactphone"]];
    self.codeTextFiled.text = [NSString stringWithFormat:@"%@",IsStrEmpty([_addressDic objectForKey:@"zipcode"])?@"":[_addressDic objectForKey:@"zipcode"]];
    if (IsStrEmpty([_addressDic objectForKey:@"provincename"])) {
        self.addressTextFiled.text = @"";
    }else{
    
        self.addressTextFiled.text = [NSString stringWithFormat:@"%@-%@-%@",[_addressDic objectForKey:@"provincename"],[_addressDic objectForKey:@"cityname"],[_addressDic objectForKey:@"districtname"]];
    }
    
    self.detailAddressTextFiled.text = [NSString stringWithFormat:@"%@",IsStrEmpty([_addressDic objectForKey:@"address"])?@"":[_addressDic objectForKey:@"address"]];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateAddress];
}

- (void)setMobileStr:(NSString *)mobileStr
{
    _mobileStr = mobileStr;
    
    //认证
}

- (void)setRealName:(NSString *)realName
{
    _realName = realName;
    if (realName) {
        _nameTextFiled.text = realName;
        [_nameTextFiled setTextColor:BlackCCCCCC];
        _nameTextFiled.userInteractionEnabled = NO;
    }
    
    
}

- (IBAction)choseAddress:(id)sender {
    
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
        
        _addressTextFiled.text = [NSString stringWithFormat:@"%@-%@-%@",province.name,city.name,district.name];
        _addressTextFiled.textColor = [UIColor colorWithHexString:@"#444444"];
        districtid = district.Id;
        provinceid = province.Id;
        cityid = city.Id;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitButton:(id)sender {
    
    [self.phoneTextFiled resignFirstResponder];
    [self.codeTextFiled resignFirstResponder];
    
    [self.detailAddressTextFiled resignFirstResponder];
    
    if (self.nameTextFiled.text.length == 0) {
        [MBProgressHUD showMessag:@"姓名不能为空" toView:self.view];
        return;
    }else if (self.phoneTextFiled.text.length == 0){
        [MBProgressHUD showMessag:@"手机号码不能为空" toView:self.view];
        return;
    }else if (self.codeTextFiled.text == 0 ){
        [MBProgressHUD showMessag:@"邮政编码不能为空" toView:self.view];
        return;
    }else if(self.addressTextFiled.text.length == 0){
    
        [MBProgressHUD showMessag:@"联系地址不能为空" toView:self.view];
        return;
    }else if (self.detailAddressTextFiled.text == 0){
        [MBProgressHUD showMessag:@"请输入详细地址" toView:self.view];
        return;
    }else if(![NSString isMobile:self.phoneTextFiled.text]){
        [self.detailAddressTextFiled resignFirstResponder];
        [MBProgressHUD showMessag:@"请输入正确的手机号码" toView:self.view];
        
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    NSDictionary *infoDic = @{@"contactname":[NSString stringWithFormat:@"%@",self.codeTextFiled.text],@"contactphone":self.phoneTextFiled.text,@"zipcode":[NSString stringWithFormat:@"%@",self.codeTextFiled.text],@"provinceid":@(provinceid),@"cityid":@(cityid),@"districtid":@(districtid),@"address":[NSString stringWithFormat:@"%@",self.detailAddressTextFiled.text]};
    
    [self.httpUtil requestDic4MethodName:@"user/modifyuseraddress" parameters:infoDic result:^(NSDictionary *dic, int status, NSString *msg) {

        if (status == 1 || status == 2) {
            
            [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
            
            _addressDic = dic;

            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
        
        
        
    }];
}

- (NSDictionary *)addressDic
{
    if (!_addressDic)
    {
        _addressDic = [NSDictionary dictionary];
    }
    return _addressDic;
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
