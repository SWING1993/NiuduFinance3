//
//  BankViewController.m
//  NiuduFinance
//
//  Created by 123 on 17/2/7.
//  Copyright © 2017年 liuyong. All rights reserved.
//

#import "BankViewController.h"

@interface BankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * bankLabel;
@property (nonatomic, strong) UIImageView * iconLabel1;
@property (nonatomic, strong) UIImageView * iconLabel2;
//单笔
@property (nonatomic, strong) UILabel * singleLabel;
//单日
@property (nonatomic, strong) UILabel * singleDayLabel;


//单笔价格
@property (nonatomic, strong) UILabel * singlLabel;
//单日价格
@property (nonatomic, strong) UILabel * singlDayLabel;




@end

@implementation BankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_tableView];
    
    _imageView       = [UIImageView new];
    _nameLabel       = [UILabel new];
    _bankLabel       = [UILabel new];
    _singleLabel     = [UILabel new];
    _singlLabel      = [UILabel new];
    _singleDayLabel  = [UILabel new];
    _singlDayLabel   = [UILabel new];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell addSubview:_imageView];
        _imageView.backgroundColor = [UIColor orangeColor];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@14);
            make.left.equalTo(@15);
            make.size.mas_equalTo(CGSizeMake(65, 65));
        }];
        
        [cell addSubview:_nameLabel];
        _nameLabel.backgroundColor = [UIColor orangeColor];
        [_nameLabel setFont:[UIFont systemFontOfSize:15]];
        _nameLabel.text = @"建设银行";
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@25);
            make.left.equalTo(_imageView.mas_right).with.offset(19);
            make.height.mas_equalTo(15);
        }];
        
        [cell addSubview:_bankLabel];
        _bankLabel.backgroundColor = [UIColor orangeColor];
        [_bankLabel setFont:[UIFont systemFontOfSize:15]];
        _bankLabel.text = @"4200***********23";
        [_bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).with.offset(12);
            make.left.equalTo(_imageView.mas_right).with.offset(19);
            make.height.mas_equalTo(15);
        }];
    }
    
    if (indexPath.section == 1 ) {
        if (indexPath.row == 0) {
            [cell addSubview:_singleLabel];
            _singleLabel.text = @"单笔限额(万元)";
            _singleLabel.backgroundColor = [UIColor orangeColor];
            [_singleLabel setFont:[UIFont systemFontOfSize:16]];
            [_singleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@16);
                make.left.equalTo(@15);
                make.height.mas_equalTo(17);
            }];
            
            [cell addSubview:_singlLabel];
            _singlLabel.text = @"20.00";
            [_singlLabel setTextAlignment:2];
            _singlLabel.backgroundColor = [UIColor orangeColor];
            [_singlLabel setFont:[UIFont systemFontOfSize:15]];
            [_singlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.mas_right).with.offset(-15);
                make.top.equalTo(@17);
                make.height.mas_equalTo(12);
            }];
            
        }else if (indexPath.row == 1)
        {
            
            [cell addSubview:_singleDayLabel];
            _singleDayLabel.text = @"单笔限额(万元)";
            _singleDayLabel.backgroundColor = [UIColor orangeColor];
            [_singleDayLabel setFont:[UIFont systemFontOfSize:16]];
            [_singleDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@16);
                make.left.equalTo(@15);
                make.height.mas_equalTo(17);
            }];
            
            [cell addSubview:_singlDayLabel];
            _singlDayLabel.text = @"2000.00";
            [_singlDayLabel setTextAlignment:2];
            _singlDayLabel.backgroundColor = [UIColor orangeColor];
            [_singlDayLabel setFont:[UIFont systemFontOfSize:15]];
            [_singlDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.mas_right).with.offset(-15);
                make.top.equalTo(@17);
                make.height.mas_equalTo(12);
            }];
            
        }
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row==0) {
        return 93;
    }else{
        return 45;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    //其他代码
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

        return 10;
}
@end
