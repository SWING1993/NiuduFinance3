//
//  BackMoneyViewController.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/9.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "BackMoneyViewController.h"
#import "ReturnMoneyTableViewCell.h"

@interface BackMoneyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)  UITableView *debtTableView;

@property (nonatomic,strong)  NSMutableArray *debtDataArr;
@end

@implementation BackMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
   
    self.title = @"回款计划";
    
    [self setTableViewInfo];
    
    _debtDataArr = [NSMutableArray array];
}



- (void)setBackPlayArr:(NSArray *)backPlayArr
{
    _backPlayArr = backPlayArr;
    
    [_debtDataArr addObjectsFromArray:backPlayArr];
}


- (void)setTableViewInfo{

    _debtTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _debtTableView.delegate = self;
    _debtTableView.dataSource = self;
    
//    _debtTableView.tableHeaderView = 
    
    _debtTableView.tableFooterView = [UIView new];
    
    [self.view addSubview:_debtTableView];
    
    [_debtTableView registerNib:[UINib nibWithNibName:@"ReturnMoneyTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReturnMoneyTableViewCell"];
}

- (void)setDebtId:(int)debtId
{
    _debtId = debtId;
    
    
}



#pragma mark -- tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.debtDataArr.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *cellId = @"ReturnMoneyTableViewCell";
    ReturnMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell ==nil) {
        cell = [[ReturnMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.selectionStyle = UITableViewScrollPositionNone;
    if (_debtDataArr.count > 0 && indexPath.row > 0) {
    cell.debtRepayDic = _debtDataArr[indexPath.row-1];
        
    }
    return cell;
    
}

@end
