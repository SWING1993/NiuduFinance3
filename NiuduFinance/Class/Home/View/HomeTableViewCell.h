//
//  HomeTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/2/25.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleAnimationView;
@class ProjectModel;
@class ProjectProgressView;
@class ProjectViewController;
@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLab;//中建
@property (weak, nonatomic) IBOutlet UILabel *projectRateLab;//预期年化率
@property (weak, nonatomic) IBOutlet UILabel *projectPeriodLab;//投资期限
//@property (weak, nonatomic) IBOutlet CircleAnimationView *projectProgressView;

@property (weak, nonatomic) IBOutlet ProjectProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIButton *projectDetailClick;//立即投资按钮

@property (weak, nonatomic) IBOutlet UILabel *beginBidLab;//起投金额
@property (weak, nonatomic) IBOutlet UILabel *surplusBidLab;//剩余可投
@property (weak, nonatomic) IBOutlet UILabel *periodTypeLab;//个月
//@property (weak, nonatomic) IBOutlet UILabel *stateIdLab;
//点击进入新手区按钮
@property (weak, nonatomic) IBOutlet UIButton *xinShouButton;
//国资出品
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;

//  优选
@property (nonatomic,strong)ProjectModel *projectFinancial;

//  首页
@property (nonatomic,strong)ProjectModel *homeProject;

//  新手优选
@property (nonatomic,strong)ProjectModel *projectNewModel;
@end
