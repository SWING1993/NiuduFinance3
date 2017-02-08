//
//  CountryViewController.m
//  PublicFundraising
//
//  Created by liuyong on 15/11/3.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "DistrictViewController.h"
#import "District.h"
#import "User.h"

@interface DistrictViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *countryTableView;
@property (nonatomic,strong)NSArray *districtArr;
@end

@implementation DistrictViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"区县";
    }
    return self;
}

- (void)setCityId:(NSString *)cityId
{
    _cityId = cityId;
    
    //获取区县
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
    [self.httpUtil requestArr4MethodName:@"fund/getdistrict" parameters:@{@"CityId":_cityId,@"UserId":@([User userFromFile].userId),@"TypeId":@(1)} result:^(NSArray *arr, int status, NSString *msg) {
        if(status == 1 || status == 2)
        {
            [hud hide:YES];
            
            _districtArr = [NSArray arrayWithArray:arr];
            [_countryTableView reloadData];
        }
        else
        {
            [hud dismissErrorStatusString:msg hideAfterDelay:1.2];
        }
    } convertClassName:@"District" key:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _districtArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    District *district = [_districtArr objectAtIndex:indexPath.row];
    cell.textLabel.text = district.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    District *district = [_districtArr objectAtIndex:indexPath.row];
    [self.addressDic setValue:district forKey:kDistrictKey];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 4] animated:YES];
}

@end
