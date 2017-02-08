//
//  ProjectInvestTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/25.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ProjectInvestTableViewCell.h"
#import "NetWorkingUtil.h"
#import "CircleAnimationView.h"
#import "ProjectModel.h"
#import "NSString+Adding.h"
#import "ProjectProgressView.h"


@implementation ProjectInvestTableViewCell

- (void)awakeFromNib {
  
    [super awakeFromNib];
    _projectDetailClick.layer.borderWidth = 1.0;
    _projectDetailClick.layer.cornerRadius = 2.0f;
    _projectDetailClick.layer.masksToBounds = YES;
    _projectDetailClick.layer.borderColor = [UIColor colorWithHexString:@"#f5635d"].CGColor;
    _progressView.layer.cornerRadius = 2.0f;
    _progressView.layer.masksToBounds = YES;
    
}

- (void)setIsNewProject:(ProjectModel *)isNewProject
{
    _isNewProject = isNewProject;
    
    [NetWorkingUtil setImage:_projectImageView url:_isNewProject.iconUrl defaultIconName:nil];
    _projectNameLab.text = _isNewProject.title;
    _projectRateLab.text = [NSString stringWithFormat:@"%@",_isNewProject.loanRate];
    _projectPeriodLab.text = [NSString stringWithFormat:@"%d",_isNewProject.loanDate];
   
    _progressView.progressValue = _isNewProject.progress;
    _progressView.isShowProgressText = NO;
    
    if (_isNewProject.statusId == 0) {

        [_projectDetailClick setTitle:@"预审" forState:UIControlStateNormal];
        [_projectDetailClick setTintColor:[UIColor grayColor]];
        _projectDetailClick.backgroundColor = BlackCCCCCC;
        _projectDetailClick.layer.borderColor = BlackCCCCCC.CGColor;

    }else if (_isNewProject.statusId == 2){
        [_projectDetailClick setTitle:@"已满" forState:UIControlStateNormal];
        [_projectDetailClick setTintColor:[UIColor grayColor]];
        _projectDetailClick.backgroundColor = BlackCCCCCC;
         _projectDetailClick.layer.borderColor = BlackCCCCCC.CGColor;
    }else if (_isNewProject.statusId == 3){
        [_projectDetailClick setTitle:@"还款中" forState:UIControlStateNormal];
        [_projectDetailClick setTintColor:[UIColor grayColor]];
        _projectDetailClick.backgroundColor = BlackCCCCCC;
        _projectDetailClick.layer.borderColor = BlackCCCCCC.CGColor;
        
    }else if (_isNewProject.statusId == 4){
        [_projectDetailClick setTitle:@"还清" forState:UIControlStateNormal];
        [_projectDetailClick setTintColor:[UIColor grayColor]];
        _projectDetailClick.backgroundColor = BlackCCCCCC;
        _projectDetailClick.layer.borderColor = BlackCCCCCC.CGColor;
        
    }else if (_isNewProject.statusId == 5 || _isNewProject.statusId == 6 || _isNewProject.statusId == 7){
        [_projectDetailClick setTitle:@"失败" forState:UIControlStateNormal];
        [_projectDetailClick setTintColor:[UIColor grayColor]];
        _projectDetailClick.backgroundColor = BlackCCCCCC;
        _projectDetailClick.layer.borderColor = BlackCCCCCC.CGColor;
        
    }else{
        [_projectDetailClick setTitle:@"投资" forState:UIControlStateNormal];
        [_projectDetailClick setTintColor:[UIColor whiteColor]];
        _projectDetailClick.backgroundColor = NaviColor;
    }
    
    if (_isNewProject.amountTypeId == 1) {
        _amountLab.text = [NSString stringWithFormat:@"金额：%@元",_isNewProject.amount];
    }else{
        _amountLab.text = [NSString stringWithFormat:@"金额：%@万元",_isNewProject.amount];
    }
    
    _amountLab.textColor  = Black999999;
    
    if (_isNewProject.periodTypeId == 1) {
        _periodTypeLab.text = @"天";
    }else if (_isNewProject.periodTypeId == 2){
        _periodTypeLab.text = @"个月";
    }else if (_isNewProject.periodTypeId == 3){
        _periodTypeLab.text = @"年";
    }
}

- (void)setNoNewProject:(ProjectModel *)noNewProject
{
    
    _noNewProject = noNewProject;
    
    [NetWorkingUtil setImage:_projectImageView url:_noNewProject.iconUrl defaultIconName:nil];
    
    _projectNameLab.text = _noNewProject.title;
    _projectRateLab.text = [NSString stringWithFormat:@"%@",_noNewProject.loanRate];
    _projectPeriodLab.text = [NSString stringWithFormat:@"%d",_noNewProject.loanDate];
    
    _progressView.progressValue = _noNewProject.progress;
    _progressView.isShowProgressText = NO;
    
    
    if (_noNewProject.statusId == 0) {
        
        
        [_projectDetailClick setTitle:@"预审" forState:UIControlStateNormal];
        [_projectDetailClick setTintColor:[UIColor grayColor]];
        _projectDetailClick.backgroundColor = BlackCCCCCC;
        _projectDetailClick.layer.borderColor = [BlackCCCCCC CGColor];
        
    }else if (_noNewProject.statusId == 2){
        [_projectDetailClick setTitle:@"已满" forState:UIControlStateNormal];
        [_projectDetailClick setTintColor:[UIColor grayColor]];
        _projectDetailClick.backgroundColor = BlackCCCCCC;
        _projectDetailClick.layer.borderColor = [BlackCCCCCC CGColor];
    }else if (_noNewProject.statusId == 3){
        [_projectDetailClick setTitle:@"还款中" forState:UIControlStateNormal];
        [_projectDetailClick setTintColor:[UIColor grayColor]];
        _projectDetailClick.backgroundColor = BlackCCCCCC;
        _projectDetailClick.layer.borderColor = BlackCCCCCC.CGColor;
        
    }else if (_noNewProject.statusId == 4){
        [_projectDetailClick setTitle:@"还清" forState:UIControlStateNormal];
        [_projectDetailClick setTintColor:[UIColor grayColor]];
        _projectDetailClick.backgroundColor = BlackCCCCCC;
        _projectDetailClick.layer.borderColor = BlackCCCCCC.CGColor;
        
    }else if (_noNewProject.statusId == 5 || _isNewProject.statusId == 6 || _isNewProject.statusId == 7){
        [_projectDetailClick setTitle:@"失败" forState:UIControlStateDisabled];
        [_projectDetailClick setTintColor:[UIColor grayColor]];
        _projectDetailClick.backgroundColor = BlackCCCCCC;
        _projectDetailClick.layer.borderColor = BlackCCCCCC.CGColor;
    }else{
        
        [_projectDetailClick setTitle:@"投资" forState:UIControlStateNormal];
        [_projectDetailClick setTintColor:[UIColor whiteColor]];
        _projectDetailClick.backgroundColor = NaviColor;
        _projectDetailClick.layer.borderColor = [UIColor colorWithHexString:@"#f5635d"].CGColor;
    }
    
   
    
    if (_noNewProject.amountTypeId == 1) {
        _amountLab.text = [NSString stringWithFormat:@"金额：%@元",_noNewProject.amount];
    }else{
        _amountLab.text = [NSString stringWithFormat:@"金额：%@万元",_noNewProject.amount];
    }
  _amountLab.textColor  = Black999999;
    
    if (_noNewProject.periodTypeId == 1) {
        _periodTypeLab.text = @"天";
    }else if (_noNewProject.periodTypeId == 2){
        _periodTypeLab.text = @"个月";
    }else if (_noNewProject.periodTypeId == 3){
        _periodTypeLab.text = @"年";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
