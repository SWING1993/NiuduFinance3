//
//  ProjectInvestTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/2/25.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectProgressView;
@class ProjectModel;
@interface ProjectInvestTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *projectRateLab;
@property (weak, nonatomic) IBOutlet UILabel *projectPeriodLab;

@property (weak, nonatomic) IBOutlet UILabel *periodTypeLab;
@property (weak, nonatomic) IBOutlet UIButton *projectDetailClick;



@property (weak, nonatomic) IBOutlet  ProjectProgressView *progressView;





//@property (weak, nonatomic) IBOutlet UILabel *stateIdLab;


//  新手标
@property (nonatomic,strong)ProjectModel *isNewProject;

//  散标
@property (nonatomic,strong)ProjectModel *noNewProject;
@end
