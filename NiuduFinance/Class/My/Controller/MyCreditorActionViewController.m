//
//  MyCreditorActionViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/10.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MyCreditorActionViewController.h"
#import "MyCreditorActionViewControllerNext.h"
#import "DXPopover.h"

@interface MyCreditorActionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *transferProjectNameLabel;

//转让价格
@property (weak, nonatomic) IBOutlet UITextField *transferPriceTextField;




@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


//借款人
@property (weak, nonatomic) IBOutlet UILabel *loanPeopleLabel;
//年利率
@property (weak, nonatomic) IBOutlet UILabel *yearRateLabel;

//持有本金
@property (weak, nonatomic) IBOutlet UILabel *haveMoneyLabel;
//持有时间
@property (weak, nonatomic) IBOutlet UILabel *haveDateLabel;
//债权价值
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
//剩余期限
@property (weak, nonatomic) IBOutlet UILabel *surplusDateLabel;
//已回款金额
@property (weak, nonatomic) IBOutlet UILabel *backMoneyLabel;
//待回款
@property (weak, nonatomic) IBOutlet UILabel *waitBackMoneyLabel;
//打折价格
@property (weak, nonatomic) IBOutlet UILabel *discountPriceLabel;
//转让总价
@property (weak, nonatomic) IBOutlet UILabel *transferSumPriceLabel;
//转让人收益率
@property (weak, nonatomic) IBOutlet UILabel *transferPeopleRateLabel;
//受让人收益率
@property (weak, nonatomic) IBOutlet UILabel *getPeopleRateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *introduceImageView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;




@property (nonatomic,strong) NSString *serviceMoney;
@property (nonatomic,strong) NSString *getMoney;

@end

@implementation MyCreditorActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    
    self.title = @"债权转让";
    
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
//    [self.view addGestureRecognizer:panGestureRecognizer];
//    self.view.userInteractionEnabled = YES;
    
    _confirmButton.layer.cornerRadius = 5.0f;
    _confirmButton.userInteractionEnabled = NO;
    _confirmButton.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    [_transferPriceTextField  addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    _transferPriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self addIntroductionViewGesture];
}

- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        
        if (translation.y>20) {
            return;
        }
        if (translation.y<-20) {
            return;
        }
        
        [view setCenter:(CGPoint){view.center.x , view.center.y - translation.y}];
            
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
        
       
    }
}

- (void)setProjectId:(NSString *)projectId
{
    _projectId = projectId;
    
    [self loadData];
}

- (void)loadData{
    

    [MBProgressHUD showStatus:@"" toView:self.view];
    [self.httpUtil requestDic4MethodName:@"debtdeal/buydetail" parameters:@{@"projectId":[NSString stringWithFormat:@"%@",_projectId]} result:^(NSDictionary *dic, int status, NSString *msg) {
        
        if (status == 1 || status == 2) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            _myCreditorDic = dic;
            
            [self setUI];
        }else{
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

- (void)setUI{

    _transferProjectNameLabel.text = [NSString stringWithFormat:@"   项目名称:%@/%@",[_myCreditorDic objectForKey:@"Title"],[_myCreditorDic objectForKey:@"ProjectId"]];
    _transferProjectNameLabel.backgroundColor =  [UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:1.00f];
    
    
    _loanPeopleLabel.text = [_myCreditorDic objectForKey:@"UserName"];
    _yearRateLabel.text =[NSString stringWithFormat:@"%.2f", [[_myCreditorDic objectForKey:@"Rate"] floatValue]];
    _yearRateLabel.text = [_yearRateLabel.text stringByAppendingString:@"%"];
    
    _haveMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",[[_myCreditorDic objectForKey:@"Successfulamount"] floatValue]];
    
    _haveDateLabel.text = [NSString stringWithFormat:@"%@天",[_myCreditorDic objectForKey:@"Holdday"]];
    _valueLabel.text = [NSString stringWithFormat:@"%.2f元",[[_myCreditorDic objectForKey:@"DebtdealValue"] floatValue]];
    
    _surplusDateLabel.text = [NSString stringWithFormat:@"%@天",[_myCreditorDic objectForKey:@"Residualday"]];
    
    _backMoneyLabel.text = [NSString stringWithFormat:@"%@元",[_myCreditorDic objectForKey:@"RepayAmount"]];
    
    _waitBackMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",[[_myCreditorDic objectForKey:@"ReceivableAmount"] floatValue]];
    
    _transferPriceTextField.placeholder = [NSString stringWithFormat:@"范围%@",[_myCreditorDic objectForKey:@"Range"]];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT+30);
}

- (void)textFieldChange:(UITextField *)textField
{
    
    if (IsStrEmpty(_transferSumPriceLabel.text)) {
        _confirmButton.userInteractionEnabled = NO;
        _confirmButton.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    }else {
        _confirmButton.userInteractionEnabled = YES;
        _confirmButton.backgroundColor = NaviColor;
    }
    
    [self.httpUtil requestDic4MethodName:@"debtdeal/buyinverster" parameters:@{@"ProjectId":_projectId,@"num":textField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        
        
        if (status == 1 || status == 2) {
           
            _serviceMoney = [NSString stringWithFormat:@"%@",[dic objectForKey:@"YJZRSXF"]];
            _getMoney = [NSString stringWithFormat:@"%@",[dic objectForKey:@"YJCJHDZ"]];
            
            _discountPriceLabel.text = [NSString stringWithFormat:@"%.2f元",[[dic
                                                                         objectForKey:@"ZJJE"] floatValue]];
            
            _transferSumPriceLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"ZRZJ"] floatValue]];
            
            _transferPeopleRateLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"ZRRSY"] floatValue]];
            
            _transferPeopleRateLabel.text = [_transferPeopleRateLabel.text stringByAppendingString:@"%"];
            
            _getPeopleRateLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"SRRSY"] floatValue]];
            _getPeopleRateLabel.text = [_getPeopleRateLabel.text stringByAppendingString:@"%"];
            
        }else{
        
            
        }
        
    }];
    

}



- (void)addIntroductionViewGesture{
    
    _introduceImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(introductionGesture)];
    
    [_introduceImageView addGestureRecognizer:gesture];
    
}



- (void)introductionGesture{
    
    //展示说明
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 180, 50)];
    textLabel.numberOfLines = 2;
    textLabel.text = @"牛伯伯每份债权单价10元";
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:textLabel];
    DXPopover *popover = [DXPopover popover];
    [popover showAtView:self.introduceImageView
         popoverPostion:DXPopoverPositionDown
        withContentView:view
                 inView:self.view];
}

- (void)setTransferInvest:(BOOL)transferInvest
{
    _transferInvest = transferInvest;
    
}

- (IBAction)commitBtnClick:(id)sender {
    if (_transferInvest == YES){
        
    
        NSString *minValue = [NSString stringWithFormat:@"%.3f",[[_myCreditorDic objectForKey:@"MinAmount"] doubleValue]];
        
        
        NSString *maxValue = [NSString stringWithFormat:@"%.3f",[[_myCreditorDic objectForKey:@"MaxAmount"] doubleValue]];
        
        

        if ([minValue floatValue] >[_transferPriceTextField.text doubleValue] || [maxValue floatValue] < [_transferPriceTextField.text doubleValue]) {
            [MBProgressHUD showMessag:@"转让价格需在建议价格范围内" toView:self.view];
            return;
        }
        
        MyCreditorActionViewControllerNext *nextVC = [[MyCreditorActionViewControllerNext alloc] init];
        
        NSDictionary *dic = @{@"serviceMoneyL":[NSString stringWithFormat:@"%@",_serviceMoney],@"getMoney":_getMoney,@"ProjectId":[NSString stringWithFormat:@"%@",[_myCreditorDic objectForKey:@"ProjectId"]],@"PriceForSale":[NSString stringWithFormat:@"%@",_transferPriceTextField.text]};
        
        nextVC.dic = dic;
        
        
        [self.navigationController pushViewController:nextVC animated:YES];
        
        
//        MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
//        [self.httpUtil requestDic4MethodName:@"DebtDeal/PostDebtDeal" parameters:@{@"ProjectId":[_myCreditorDic objectForKey:@"ProjectId"],@"CurrentRate":[_myCreditorDic objectForKey:@"Rate"],@"OwingPrincipal":[_myCreditorDic objectForKey:@"ReceivablePrincipal"],@"OwingNumber":[_myCreditorDic objectForKey:@"OwingNumber"],@"OwingInterest":[_myCreditorDic objectForKey:@"ReceivableInterest"],@"PriceForSale":_transferPriceTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
//            if (status == 1 || status == 2) {
//                [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
//                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
//            }else{
//                [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
//            }
//        }];
    }
    //撤销部分,这里用不到
//    else{
//        MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
//        [self.httpUtil requestDic4MethodName:@"DebtDeal/TransferRevoke" parameters:@{@"DebtDealId":[_myCreditorDic objectForKey:@"DebtDealId"]} result:^(NSDictionary *dic, int status, NSString *msg) {
//            if (status == 1 || status == 2) {
//                [hud dismissSuccessStatusString:msg hideAfterDelay:0.5];
//                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
//            }else{
//                [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
//            }
//        }];
//    }
}

- (void)delayMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
