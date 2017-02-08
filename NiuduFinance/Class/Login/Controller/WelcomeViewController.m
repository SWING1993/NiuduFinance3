//
//  WelcomeViewController.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/18.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AppDelegate.h"

@interface WelcomeViewController ()

@property (strong, nonatomic) UIScrollView *adScroll;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float height = SCREEN_HEIGHT;
    self.adScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.adScroll];
    self.adScroll.pagingEnabled = YES;
    self.adScroll.showsHorizontalScrollIndicator = NO;
    self.adScroll.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT);
    for (int i=0; i<3; i++) {
        UIImageView *showImge = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        showImge.userInteractionEnabled = YES;
        [self.adScroll  addSubview:showImge];
        NSString *picName = @"";
        if (height == 480) {
            picName = [NSString stringWithFormat:@"welcome4%d.png",i+1];
        }
        if (height == 568) {
            picName = [NSString stringWithFormat:@"welcome5%d.png",i+1];
        }
        if (height == 667) {
            
            picName = [NSString stringWithFormat:@"welcome6%d.png",i+1];
            
        }
        
        if (height == 736) {
            picName = [NSString stringWithFormat:@"welcome6p%d.png",i+1];
        }
        showImge.image = [UIImage imageNamed:picName];
        
        
        if (i == 2) {
            if (height == 480) {
                UIButton *experienceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                experienceBtn.frame = CGRectMake(SCREEN_WIDTH / 2 - 60, SCREEN_HEIGHT - 125, 120, 40);
   
                [experienceBtn addTarget:self action:@selector(experienceBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [showImge addSubview:experienceBtn];
            }
            if (height == 568) {
                UIButton *experienceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                experienceBtn.frame = CGRectMake(SCREEN_WIDTH / 2 - 60, SCREEN_HEIGHT - 165, 120, 40);
                
                [experienceBtn addTarget:self action:@selector(experienceBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [showImge addSubview:experienceBtn];
            }
            if (height == 667) {
                
                UIButton *experienceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                experienceBtn.frame = CGRectMake(SCREEN_WIDTH / 2 - 60, SCREEN_HEIGHT - 185, 120, 40);
                
                [experienceBtn addTarget:self action:@selector(experienceBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [showImge addSubview:experienceBtn];
            }
            if (height == 736) {
                UIButton *experienceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                experienceBtn.frame = CGRectMake(SCREEN_WIDTH / 2 - 60, SCREEN_HEIGHT - 210, 120, 50);
                
                
                [experienceBtn addTarget:self action:@selector(experienceBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [showImge addSubview:experienceBtn];
            }
        }
    }
}

- (void)experienceBtnClick
{
    [AppDelegate loginMain];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
