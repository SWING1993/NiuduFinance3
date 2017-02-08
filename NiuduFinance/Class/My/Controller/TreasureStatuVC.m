//
//  TreasureStatuVC.m
//  NiuduFinance
//
//  Created by andrewliu on 16/10/13.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "TreasureStatuVC.h"

@interface TreasureStatuVC ()
@property (weak, nonatomic) IBOutlet UIButton *myAccountBtn;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation TreasureStatuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开户状态";
    [self backBarItem];
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
