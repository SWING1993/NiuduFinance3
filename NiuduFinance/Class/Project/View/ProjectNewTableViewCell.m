//
//  ProjectNewTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/24.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ProjectNewTableViewCell.h"
#import "ProjectModel.h"
#import "CircleAnimationView.h"
#import "NetWorkingUtil.h"
#import "NSString+Adding.h"
#import "ProjectProgressView.h"

@implementation ProjectNewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    _projectDetailClick.layer.cornerRadius = 2.0f;
    _projectDetailClick.layer.masksToBounds = YES;
    
    _progressView.layer.cornerRadius = 2.0f;
    _progressView.layer.masksToBounds = YES;
    _progressView.backgroundColor = BlackCCCCCC;
    
    
    //设置图片边框颜色
    _tuLabel.layer.borderColor = [[UIColor orangeColor]CGColor];
    //设置边框宽度
    _tuLabel.layer.borderWidth =0.5f;
    //设置边框圆角
    _tuLabel.layer.cornerRadius = 2.0f;
    _tuLabel.layer.masksToBounds = YES;
    
}

//   首页
- (void)setHomeProject:(ProjectModel *)homeProject
{
    _homeProject = homeProject;
    
    [NetWorkingUtil setImage:nil url:_homeProject.iconUrl defaultIconName:nil];
    _projectTitleNewLab.text = _homeProject.name;
    _projectNewRateLab.text = _homeProject.rate;
    _projectNewPeriodLab.text = [NSString stringWithFormat:@"%d",_homeProject.loanPeriod];
    if (_homeProject.periodTypeId == 1) {
        _projectNewPeriodTypeLab.text = @"天";
    }else if (_homeProject.periodTypeId == 2){
        _projectNewPeriodTypeLab.text = @"个月";
    }else if (_homeProject.periodTypeId == 3){
        _projectNewPeriodTypeLab.text = @"年";
    }

    _progressView.backgroundColor = BlackCCCCCC;
    _progressView.progressValue = _homeProject.progress;
    _progressView.isShowProgressText = NO;
    
    if (_homeProject.minAmount / 10000 >= 1) {
        _projectNewAmountLab.text = [NSString stringWithFormat:@"起投金额：%.2f万元",_homeProject.minAmount / 10000];
    }else{
        _projectNewAmountLab.text = [NSString stringWithFormat:@"%.2f元起投",_homeProject.minAmount];
    }
    
    _projectNewAmountLab.attributedText = [_projectNewAmountLab.text attributedText:_projectNewAmountLab.text beginIndex:0 length:3 colorStr:@"#999999" font:12.0];

    if (_homeProject.surplusAmountTypeId == 1) {
        _projectSurplusMoneyLab.text = [NSString stringWithFormat:@"剩余可投：%@元",_homeProject.surplusAmount];
    }else{
        _projectSurplusMoneyLab.text = [NSString stringWithFormat:@"剩余可投：%@万元",_homeProject.surplusAmount];
    }
}

//   新手标
- (void)setIsNewProject:(ProjectModel *)isNewProject
{
    _isNewProject = isNewProject;
    
    [NetWorkingUtil setImage:nil url:_isNewProject.iconUrl defaultIconName:nil];

    
    
    _projectTitleNewLab.text = _isNewProject.title;
//    _projectNewRateLab.text = [NSString stringWithFormat:@"%@",_isNewProject.loanRate];
    _projectNewPeriodLab.text = [NSString stringWithFormat:@"%d",_isNewProject.loanDate];
    
    _progressView.progressValue = _isNewProject.progress;
    _progressView.isShowProgressText = NO;
    
    if (_isNewProject.statusId == 2) {
        
        [_projectDetailClick setTitle:@"未开始" forState:UIControlStateNormal];
        _projectDetailClick.backgroundColor = BlackCCCCCC;
        
    }else if (_isNewProject.statusId == 3){
        [_projectDetailClick setTitle:@"详情" forState:UIControlStateNormal];
        _projectDetailClick.backgroundColor = BlackCCCCCC;
    }else{
        [_projectDetailClick setTitle:@"投资" forState:UIControlStateNormal];
        _projectDetailClick.backgroundColor = NaviColor;
    }
    
    if (_isNewProject.minAmount / 10000 >= 1) {
        _projectNewAmountLab.text = [NSString stringWithFormat:@"起投金额：%.2f万元",_isNewProject.minAmount / 10000];
    }else{
        _projectNewAmountLab.text = [NSString stringWithFormat:@"%.2f元起投",_isNewProject.minAmount];
    }
    
    _projectNewAmountLab.textColor  = Black999999;
    
    if (_isNewProject.periodTypeId == 1) {
        _projectNewPeriodTypeLab.text = @"天";
    }else if (_isNewProject.periodTypeId == 2){
        _projectNewPeriodTypeLab.text = @"个月";
    }else if (_isNewProject.periodTypeId == 3){
        _projectNewPeriodTypeLab.text = @"年";
    }
    
    if (_isNewProject.surplusAmountTypeId == 1) {
        _projectSurplusMoneyLab.text = [NSString stringWithFormat:@"剩余可投：%@元",_isNewProject.surplusAmount];
    }else{
        _projectSurplusMoneyLab.text = [NSString stringWithFormat:@"剩余可投：%@万元",_isNewProject.surplusAmount];
    }
}

//  散标
- (void)setNoNewProject:(ProjectModel *)noNewProject
{
    
    _noNewProject = noNewProject;
    
    [NetWorkingUtil setImage:nil url:_noNewProject.iconUrl defaultIconName:nil];
    
    _projectTitleNewLab.text = _noNewProject.title;
//    _projectNewRateLab.text = [NSString stringWithFormat:@"%@",_noNewProject.loanRate];
    _projectNewPeriodLab.text = [NSString stringWithFormat:@"%d",_noNewProject.loanDate];
    
    _progressView.progressValue = _noNewProject.progress;
    _progressView.isShowProgressText = NO;
    
    
    if (_noNewProject.statusId == 2) {
        
        
        [_projectDetailClick setTitle:@"未开始" forState:UIControlStateNormal];
        _projectDetailClick.backgroundColor = BlackCCCCCC;
        
    }else if (_noNewProject.statusId == 3){
        [_projectDetailClick setTitle:@"详情" forState:UIControlStateNormal];
        _projectDetailClick.backgroundColor = BlackCCCCCC;
    }else{
        
        [_projectDetailClick setTitle:@"投资" forState:UIControlStateNormal];
        _projectDetailClick.backgroundColor = NaviColor;
    }
    
    
    if (_noNewProject.minAmount / 10000 >= 1) {
        _projectNewAmountLab.text = [NSString stringWithFormat:@"起投金额：%.2f万元",_noNewProject.minAmount / 10000];
    }else{
        _projectNewAmountLab.text = [NSString stringWithFormat:@"%.2f元起投",_noNewProject.minAmount];
    }
    
    _projectNewAmountLab.textColor  = Black999999;
    
    if (_noNewProject.periodTypeId == 1) {
        _projectNewPeriodTypeLab.text = @"天";
    }else if (_noNewProject.periodTypeId == 2){
        _projectNewPeriodTypeLab.text = @"个月";
    }else if (_noNewProject.periodTypeId == 3){
        _projectNewPeriodTypeLab.text = @"年";
    }
    
    if (_noNewProject.surplusAmountTypeId == 1) {
        _projectSurplusMoneyLab.text = [NSString stringWithFormat:@"剩余可投：%@元",_noNewProject.surplusAmount];
    }else{
        _projectSurplusMoneyLab.text = [NSString stringWithFormat:@"剩余可投：%@万元",_noNewProject.surplusAmount];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
