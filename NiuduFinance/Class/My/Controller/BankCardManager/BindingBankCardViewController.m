//
//  BindingBankCardViewController.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/20.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "BindingBankCardViewController.h"
#import "ChoseBankCardCell.h"
#define ChoseBaknCardCellID @"ChoseBankCardCell"

@interface BindingBankCardViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *bankNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) NSArray *iconArr;
@property (nonatomic,strong) NSArray *bankNameArr;
@end

@implementation BindingBankCardViewController
{
    BOOL showChoseImage;
    NSInteger choseRow;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backBarItem];
    self.title = @"绑卡";
    showChoseImage = NO;
    choseRow = -1;
    
    [self loadViewStyle];
    
    _submitButton.userInteractionEnabled = NO;
    _submitButton.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
     [_bankNumLabel addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self addBankInfo];
    
}
- (void)textFieldChange:(UITextField *)textField
{
    
    if (IsStrEmpty(_bankNumLabel.text)) {
        _submitButton.userInteractionEnabled = NO;
        _submitButton.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else if (choseRow==-1){
        _submitButton.userInteractionEnabled = NO;
        _submitButton.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else{
        _submitButton.userInteractionEnabled = YES;
        _submitButton.backgroundColor = NaviColor;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.93f green:0.30f blue:0.26f alpha:1.0f]];
//     [[[self.navigationController.navigationBar subviews] objectAtIndex:1] setAlpha:1];
}

- (void)loadViewStyle{

    
    _bankNumLabel.keyboardType = UIKeyboardTypeNumberPad;
    self.submitButton.layer.cornerRadius = 10.0f;
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    _tableview.tableFooterView = [UIView new];
    [_tableview registerNib:[UINib nibWithNibName:ChoseBaknCardCellID bundle:nil] forCellReuseIdentifier:ChoseBaknCardCellID];
    
}

#pragma mark -- 可添加银行信息

- (void)addBankInfo{

    _iconArr = @[@"ABC",@"CCB",@"BOC",@"ICBC",@"CEB",@"SZPAB",@"SDTBNK",@"BOS",@"CIB",@"PSBC",@"CITIC",@"CBHB"];
    _bankNameArr = @[@"农业银行",@"建设银行",@"中国银行",@"工商银行",@"光大银行",@"平安银行",@"浦发银行",@"上海银行",@"兴业银行",@"储蓄银行",@"中信银行",@"渤海银行"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _iconArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:choseRow inSection:0];
     ChoseBankCardCell *lastcell = [tableView cellForRowAtIndexPath:lastIndexPath];
    lastcell.accessoryType = UITableViewCellAccessoryNone;
    
    ChoseBankCardCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    
    choseRow = indexPath.row;
    
//    ChoseBankCardCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"%ld",choseRow);
//    if (!showChoseImage) {
//        showChoseImage = NO;
//        cell.isChose  = YES;
//    }else{
//        showChoseImage = YES;
//        cell.isChose = NO;
//    }

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    ChoseBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:ChoseBaknCardCellID];
    
    cell.isChose = NO;
    cell.bankNameLabel.text = _bankNameArr[indexPath.row];
    cell.iconString = _iconArr[indexPath.row];
    if (indexPath.row == choseRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (IBAction)submit:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
