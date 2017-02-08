//
//  ProvincesViewController.m
//  PublicFundraising
//
//  Created by liuyong on 15/10/28.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "ProvincesViewController.h"
#import "Province.h"
#import "User.h"

@interface ProvincesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *provincesTableView;
@property (nonatomic,strong)NSArray *provinceArr;
@end

@implementation ProvincesViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"省份";
        self.hideBottomBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    [self getDataInfo];
}

- (void)getDataInfo
{
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestArr4MethodName:@"fund/getprovince" parameters:@{@"UserId":@([User userFromFile].userId)} result:^(NSArray *arr, int status, NSString *msg) {
        if(status == 1 || status == 2)
        {
            [hud hide:YES];
            _provinceArr = [NSArray arrayWithArray:arr];
            [_provincesTableView reloadData];
        }
        else
        {
            [hud dismissErrorStatusString:msg hideAfterDelay:1.2];
        }
    } convertClassName:@"Province" key:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _provinceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    Province *province = [_provinceArr objectAtIndex:indexPath.row];
    cell.textLabel.text = province.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Province *province = [_provinceArr objectAtIndex:indexPath.row];
    CitysViewController *cityVC = [CitysViewController new];
    cityVC.isOptionCity = _isOptionCity;
    cityVC.provinceId = [NSString stringWithFormat:@"%ld",(long)province.Id];
    cityVC.provinceName = province.name;
    [self.addressDic setValue:province forKey:kProvincesKey];
    cityVC.addressDic = self.addressDic;
    [self.navigationController pushViewController:cityVC animated:YES];
}

@end
