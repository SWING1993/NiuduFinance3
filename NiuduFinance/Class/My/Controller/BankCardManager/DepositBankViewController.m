//
//  DepositBankViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/17.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "DepositBankViewController.h"

@interface DepositBankViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *depositTableView;

@end

@implementation DepositBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开户行";
    [self backBarItem];
    
    _depositTableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _depositArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewScrollPositionNone;
    cell.textLabel.text = [_depositArr[indexPath.row] objectForKey:@"Name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeTitle:)]) {
        [self.delegate changeTitle:[_depositArr[indexPath.row] objectForKey:@"Name"]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
