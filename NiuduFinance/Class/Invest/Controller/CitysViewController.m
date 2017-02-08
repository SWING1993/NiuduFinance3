//
//  CitysViewController.m
//  PublicFundraising
//
//  Created by liuyong on 15/11/2.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "CitysViewController.h"
#import "City.h"
#import "User.h"

@interface CitysViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
@property (nonatomic,strong)NSArray *cityArr;
@end

@implementation CitysViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"城市";
    }
    return self;
}

- (void)setProvinceId:(NSString *)provinceId
{
    _provinceId = provinceId;
    
    //获取城市
    [self getDataInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backBarItem];
}

- (void)getDataInfo
{
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestArr4MethodName:@"fund/getcity" parameters:@{@"ProvinceId":_provinceId,@"UserId":@([User userFromFile].userId)} result:^(NSArray *arr, int status, NSString *msg) {
        if(status == 1 || status == 2)
        {
            [hud hide:YES];
            _cityArr = [NSArray arrayWithArray:arr];
            [_cityTableView reloadData];
        }
        else
        {
            [hud dismissErrorStatusString:msg hideAfterDelay:1.2];
        }
    } convertClassName:@"City" key:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cityArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    City *city = [_cityArr objectAtIndex:indexPath.row];
    cell.textLabel.text = city.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    City *city = [_cityArr objectAtIndex:indexPath.row];

    [self.addressDic setValue:city forKey:kCityKey];
    if (_isOptionCity)
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
        return;
    }
    DistrictViewController *countryVC = [DistrictViewController new];
    countryVC.cityId = [NSString stringWithFormat:@"%ld",(long)city.Id];
    countryVC.cityName = city.name;
    countryVC.addressDic = self.addressDic;
    [self.navigationController pushViewController:countryVC animated:YES];
}

@end
