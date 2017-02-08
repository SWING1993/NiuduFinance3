//
//  ProjectNewTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/3/24.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleAnimationView;
@class ProjectModel;
@class ProjectProgressView;
@interface ProjectNewTableViewCell : UITableViewCell
//中建供应链第八期
@property (weak, nonatomic) IBOutlet UILabel *projectTitleNewLab;

@property (weak, nonatomic) IBOutlet UILabel *tuLabel;
//预期年化
@property (weak, nonatomic) IBOutlet UILabel *projectNewRateLab;
//投资期限
@property (weak, nonatomic) IBOutlet UILabel *projectNewPeriodLab;
//投资几个月
@property (weak, nonatomic) IBOutlet UILabel *projectNewPeriodTypeLab;
//@property (weak, nonatomic) IBOutlet CircleAnimationView *projectNewAnimationView;
@property (weak, nonatomic) IBOutlet UIButton *projectDetailClick;
//ProjectProgressView==?HProjectProgressView投资进度条
@property (weak, nonatomic) IBOutlet ProjectProgressView *progressView;
//起投金额
@property (weak, nonatomic) IBOutlet UILabel *projectNewAmountLab;
//剩余可投
@property (weak, nonatomic) IBOutlet UILabel *projectSurplusMoneyLab;

// 首页
@property (nonatomic,strong)ProjectModel *homeProject;

//  新手标
@property (nonatomic,strong)ProjectModel *isNewProject;

//  散标
@property (nonatomic,strong)ProjectModel *noNewProject;
@end
