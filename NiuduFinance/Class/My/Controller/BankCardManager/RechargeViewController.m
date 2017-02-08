//
//  RechargeViewController.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/18.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "RechargeViewController.h"
#import "MaskView.h"
#import "AppDelegate.h"



@interface RechargeViewController ()
@property (nonatomic ,strong)MaskView *maskView;
//单笔限额

@property (nonatomic,strong) UILabel *singleLimitLabel;

//单卡单日限额

@property (nonatomic,strong) UILabel *dailyLimitLabel;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    [self backBarItem];
    self.submitButton.layer.cornerRadius = 5.0f;
    self.moneyLabel.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)setBankCardsArr:(NSMutableArray *)bankCardsArr
{
    _bankCardsArr = bankCardsArr;
    
    //数据绑定
    //    NSDictionary *dic = _bankCardsArr[indexPath.row];
    //    [NetWorkingUtil setImage:cell.bankCardImageView url:[dic objectForKey:@"BackIconUrl"] defaultIconName:nil];
    //    cell.bankCardNameLab.text = [dic objectForKey:@"BankTypeName"];
    //    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    NSString *numberStr = [dic objectForKey:@"BankNumber"];
    //    cell.bankCardNumberLab.text = [NSString stringWithFormat:@"尾号 %@",[numberStr substringFromIndex:numberStr.length -4]];
    
    NSDictionary *dic = bankCardsArr[0];
    [NetWorkingUtil setImage:self.iconImageView url:[dic objectForKey:@"BackIconUrl"]  defaultIconName:nil];
    self.bankNameLabel.text = [dic objectForKey:@"BankTypeName"];
    NSString *numberStr = [dic objectForKey:@"BankNumber"];
    self.accountNumLabel.text = [NSString stringWithFormat:@"尾号 %@",[numberStr substringFromIndex:numberStr.length -4]];
    
    //计算手续费,和预计到账的前
    
}
//查看限额
- (IBAction)showQuota:(id)sender {
    
    if ([self.bankNameLabel.text isEqualToString:@"农业银行"]) {
        
        [self addMaskView:@"50,000.00" andDailyLimit:@"100,000.00"];
    }else if([self.bankNameLabel.text isEqualToString:@"光大银行"]){
        [self addMaskView:@"50,000.00" andDailyLimit:@"500,000.00"];
    }else if([self.bankNameLabel.text isEqualToString:@"建设银行"]){
        [self addMaskView:@"500,000.00" andDailyLimit:@"500,000.00"];
    }else if ([self.bankNameLabel.text isEqualToString:@"平安银行"]){
        [self addMaskView:@"5,000.00" andDailyLimit:@"5,000.00"];
    }else if ([self.bankNameLabel.text isEqualToString:@"浦发银行"]){
        [self addMaskView:@"5,000.00" andDailyLimit:@"5,000.00"];
    }else if ([self.bankNameLabel.text isEqualToString:@"上海银行"]){
        [self addMaskView:@"5,000.00" andDailyLimit:@"50,000.00"];
    }else if ([self.bankNameLabel.text isEqualToString:@"兴业银行"]){
        [self addMaskView:@"50,000.00" andDailyLimit:@"50,000.00"];
    }else if([self.bankNameLabel.text isEqualToString:@"中信银行"]){
        [self addMaskView:@"500,000.00" andDailyLimit:@"500,000.00"];
    }else if ([self.bankNameLabel.text isEqualToString:@"中国银行"]){
        [self addMaskView:@"50,000.00" andDailyLimit:@"100,000.00"];
    }else if([self.bankNameLabel.text isEqualToString:@"渤海银行"]){
        [self addMaskView:@"500,000.00" andDailyLimit:@"500,000.00"];
    }else if([self.bankNameLabel.text isEqualToString:@"工商银行"]){
        [self addMaskView:@"50,000.00" andDailyLimit:@"50,000.00"];
    }else{
        [self addMaskView:@"5,000.00" andDailyLimit:@"5,000.00"];
    }
}

#pragma mark -- 充值额度说明
- (void)addMaskView:(NSString *)singleLimit andDailyLimit:(NSString *)dailyLimit{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 130, SCREEN_WIDTH-40, 260)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10.0f;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 45)];
    titleView.backgroundColor = [UIColor colorWithRed:0.18f green:0.45f blue:0.74f alpha:1.00f];
    
    [view addSubview:titleView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 2, 100, 41)];
    titleLabel.text = @"查看限额";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [titleView addSubview:titleLabel];
    
    UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 0, 50, 45)];
    deleteLabel.textColor = [UIColor whiteColor];
    deleteLabel.text = @"X";
    deleteLabel.font = [UIFont systemFontOfSize:19];
    [titleView addSubview:deleteLabel];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 80, view.frame.size.width-40, 150)];
    contentView.backgroundColor = [UIColor whiteColor];
    [view addSubview:contentView];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    descLabel.textColor = BlackCCCCCC;
    descLabel.text = @"请关注您的充值金额是否超限:";
    descLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:descLabel];
    
    UILabel *singleLimitDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 270, 40)];
    
    singleLimitDesc.backgroundColor = [UIColor colorWithRed:0.92f green:0.94f blue:0.96f alpha:1.00f];
    singleLimitDesc.text = @"    单笔限额(元)        单卡单日限额(元)  ";
    singleLimitDesc.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:singleLimitDesc];
    
    _singleLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 115, 40)];
    _singleLimitLabel.text = [NSString stringWithFormat:@"   %@",singleLimit];
    _singleLimitLabel.layer.borderColor = BlackCCCCCC.CGColor;
    _singleLimitLabel.layer.borderWidth = 1.0f;
    [contentView addSubview:_singleLimitLabel];
    
    _dailyLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 75, 270-115, 40)];
    _dailyLimitLabel.text = [NSString stringWithFormat:@"      %@",dailyLimit];
    _dailyLimitLabel.layer.borderColor = BlackCCCCCC.CGColor;
    _dailyLimitLabel.layer.borderWidth = 1.0f;
    [contentView addSubview:_dailyLimitLabel];
    //添加蒙层,以及蒙层上放的控件
    _maskView = [MaskView makeViewWithMask:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+65) andView:view];
    
}

- (IBAction)submit:(id)sender {
    
    //充值
    if (self.moneyLabel.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入充值金额" toView:self.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
