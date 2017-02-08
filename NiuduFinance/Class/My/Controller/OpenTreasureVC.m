//
//  OpenTreasureVC.m
//  NiuduFinance
//
//  Created by andrewliu on 16/10/13.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "OpenTreasureVC.h"
#import "TreasureStatuVC.h"

@interface OpenTreasureVC ()

@end

@implementation OpenTreasureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"富友开户";
    self.hideBottomBar = YES;
    
    [self backBarItem];
    
    [self addLeftBarButton];
}

- (void)addLeftBarButton{
    
     [self setupBarButtomItemWithTitle:@"确定开通" target:self action:@selector(isOpanTreasure) leftOrRight:NO];
}

- (void)isOpanTreasure{

    TreasureStatuVC *vc = [[TreasureStatuVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
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
