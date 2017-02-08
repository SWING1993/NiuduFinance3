//
//  InvestSuccesViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/29.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "InvestSuccesViewController.h"
#import "AppDelegate.h"
#import "TabBarController.h"

@interface InvestSuccesViewController ()
@property (weak, nonatomic) IBOutlet UIButton *goBtn;
@property (weak, nonatomic) IBOutlet UIButton *myInvestBtn;
@property (weak, nonatomic) IBOutlet UILabel *investAmountLab;

@end

@implementation InvestSuccesViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"投资成功";
    }
    return self;
}

- (void)setAmountStr:(NSString *)amountStr
{
    _amountStr = amountStr;
    
//    _investAmountLab.text = [NSString stringWithFormat:@"%@元",_amountStr];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    
    _goBtn.layer.cornerRadius = 5.0f;
    _myInvestBtn.layer.cornerRadius = 5.0f;
    
}
//  继续投资
- (IBAction)continueInvestClick:(id)sender {
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 4] animated:YES];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}
//  我的投资
- (IBAction)myInvestClick:(id)sender {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    TabBarController *tabbarController = [[TabBarController alloc] init];
    tabbarController.selectedIndex = 3;
    app.window.rootViewController = tabbarController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
