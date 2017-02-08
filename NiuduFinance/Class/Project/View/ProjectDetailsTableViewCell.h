//
//  ProjectDetailsTableViewCell.h
//  NiuduFinance
//
//  Created by liuyong on 16/2/26.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHBPickerView.h"
@class ProjectDetailsViewController;

@interface ProjectDetailsTableViewCell : UITableViewCell<ZHBPickerViewDataSource,ZHBPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *availableLab;
@property (weak, nonatomic) IBOutlet UITextField *investTextField;
@property (weak, nonatomic) IBOutlet UITextField *earningsTextField;


@property (weak, nonatomic) IBOutlet UILabel *hongbaoTextField;
@property (weak, nonatomic) IBOutlet UIButton *hongBaoButton;

@property (nonatomic,strong)NSString *availableBalanceStr;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSDictionary *dic;
@property (nonatomic,strong)NSString *optionIdStr;
@property (nonatomic,strong)UIWindow *window;
@property (nonatomic,strong)ZHBPickerView *zhBPickerView;

@property (nonatomic,strong) NSMutableArray *hongbaoArray;

@property (nonatomic,strong) NSMutableArray *getHongBaoArray;

@property (nonatomic,weak)ProjectDetailsViewController *delegate;
@end
