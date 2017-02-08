//
//  HomeTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/25.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "NetWorkingUtil.h"
#import "ProjectModel.h"
#import "CircleAnimationView.h"
#import "NSString+Adding.h"
#import "ProjectProgressView.h"
@implementation HomeTableViewCell

- (void)awakeFromNib {
 
    
    _projectDetailClick.layer.borderWidth = 1.0;
    _projectDetailClick.layer.cornerRadius = 2.0f;
    _projectDetailClick.layer.masksToBounds = YES;
    _projectDetailClick.layer.borderColor = [UIColor colorWithHexString:@"#f5635d"].CGColor;
    
    
    _progressView.layer.cornerRadius = 2.0f;
    _progressView.layer.masksToBounds = YES;
    
    //设置图片边框颜色
    _radiusLabel.layer.borderColor = [[UIColor orangeColor]CGColor];
    //设置边框宽度
    _radiusLabel.layer.borderWidth =0.5f;
    //设置边框圆角
    _radiusLabel.layer.cornerRadius = 2.0f;
    _radiusLabel.layer.masksToBounds = YES;
}

- (void)setProjectFinancial:(ProjectModel *)projectFinancial
{

    
    _projectFinancial = projectFinancial;
    
    _projectImageView.image = [UIImage imageNamed:@"home_youxuan"];
    _projectNameLab.text = [NSString stringWithFormat:@"%@%@",_projectFinancial.name,_projectFinancial.productNum];
    _projectRateLab.text = _projectFinancial.planRate;
    _projectPeriodLab.text = [NSString stringWithFormat:@"%d",_projectFinancial.loanPeriod];
    
    
    _progressView.progressValue = _projectFinancial.progress;
    _progressView.isShowProgressText = NO;
    
    if (_projectFinancial.periodTypeId == 1) {
        _periodTypeLab.text = @"天";
    }else if (_projectFinancial.periodTypeId == 2){
        _periodTypeLab.text = @"个月";
    }else if (_projectFinancial.periodTypeId == 3){
        _periodTypeLab.text = @"年";
    }
    if (_projectFinancial.statusId == 1) {

        [_projectDetailClick setTitle:@"投资" forState:UIControlStateNormal];
        [_projectDetailClick setTintColor:[UIColor redColor]];
        _projectDetailClick.backgroundColor = NaviColor;
        _projectDetailClick.layer.borderColor = [UIColor colorWithHexString:@"#f5635d"].CGColor;
        
        
    }else if (_projectFinancial.statusId == 3 || _projectFinancial.statusId == 4 || _projectFinancial.statusId == 5 || _projectFinancial.statusId == 6 || _projectFinancial.statusId == 7){
        
        [_projectDetailClick setTitle:@"售罄" forState:UIControlStateNormal];
        [_projectDetailClick setTintColor:[UIColor grayColor]];
        _projectDetailClick.backgroundColor = BlackCCCCCC;
        _projectDetailClick.layer.borderColor = BlackCCCCCC.CGColor;
        
    }else if(_projectFinancial.statusId == 2){
        
        [_projectDetailClick setTitle:@"投资" forState:UIControlStateNormal];
        [_projectDetailClick setTintColor:[UIColor redColor]];
        _projectDetailClick.backgroundColor = NaviColor;
        _projectDetailClick.layer.borderColor = [UIColor colorWithHexString:@"#f5635d"].CGColor;
    }
    
    _beginBidLab.text = [NSString stringWithFormat:@"起投金额：%@元",_projectFinancial.bidAmountTimes];
    _beginBidLab.attributedText = [_beginBidLab.text attributedText:_beginBidLab.text beginIndex:0 length:3 colorStr:@"#999999" font:12.0];
    if (_projectFinancial.overplusTypeId == 1) {
        _surplusBidLab.text = [NSString stringWithFormat:@"剩余可投：%@元",_projectFinancial.overplus];
    
    }else{
        _surplusBidLab.text = [NSString stringWithFormat:@"剩余可投：%@万元",_projectFinancial.overplus];
    }
    _surplusBidLab.attributedText = [_surplusBidLab.text attributedText:_surplusBidLab.text beginIndex:0 length:3 colorStr:@"#999999" font:12.0];
    
    
}

- (void)setHomeProject:(ProjectModel *)homeProject
{
    _homeProject = homeProject;
    
    if (_homeProject.type == 1) {
        _projectImageView.image = [UIImage imageNamed:@"home_new"];
    }else{
        _projectImageView.image = [UIImage imageNamed:@"home_youxuan"];
        
    }
    _projectNameLab.text = _homeProject.name;
    _projectRateLab.text = _homeProject.rate;
    
    _projectPeriodLab.text = [NSString stringWithFormat:@"%d",_homeProject.loanPeriod];
    if (homeProject.periodTypeId == 1) {
        _periodTypeLab.text = @"天";
    }else if (homeProject.periodTypeId == 2){
        _periodTypeLab.text = @"个月";
    }else if (homeProject.periodTypeId == 3){
        _periodTypeLab.text = @"年";
    }

    
    _progressView.progressValue = _homeProject.progress;
    _progressView.isShowProgressText = NO;
    
    if (_homeProject.minAmount / 10000 >= 1) {
        _beginBidLab.text = [NSString stringWithFormat:@"起投金额：%.2f万元",_homeProject.minAmount / 10000];
    }else{
        _beginBidLab.text = [NSString stringWithFormat:@"起投金额：%.2f元",_homeProject.minAmount];
    }
    
    if (_homeProject.surplusAmountTypeId == 1) {
        _surplusBidLab.text = [NSString stringWithFormat:@"剩余可投：%@元",_homeProject.surplusAmount];
    }else{
        _surplusBidLab.text = [NSString stringWithFormat:@"剩余可投：%@万元",_homeProject.surplusAmount];
    }
}

- (void)setProjectNewModel:(ProjectModel *)projectNewModel
{
//    _stateIdLab.hidden = YES;
    
    _projectNewModel = projectNewModel;
    
    _projectImageView.image = [UIImage imageNamed:@"home_youxuan"];
    _projectNameLab.text = _projectNewModel.title;
    _projectRateLab.text = [NSString stringWithFormat:@"%@",_projectNewModel.loanRate];
    _projectPeriodLab.text = [NSString stringWithFormat:@"%d",_projectNewModel.loanDate];
    
    
    
    _progressView.progressValue = _projectNewModel.progress;
    _progressView.isShowProgressText = NO;

    
    if (_projectNewModel.statusId == 1) {
        
        
    }else if (_projectNewModel.statusId == 3 || _projectNewModel.statusId == 4 || _projectNewModel.statusId == 5 || _projectNewModel.statusId == 6 || _projectNewModel.statusId == 7){
        
    }
    
    if (_projectNewModel.periodTypeId == 1) {
        _periodTypeLab.text = @"天";
    }else if (_projectNewModel.periodTypeId == 2){
        _periodTypeLab.text = @"个月";
    }else if (_projectNewModel.periodTypeId == 3){
        _periodTypeLab.text = @"年";
    }
    if (_projectNewModel.minAmount / 10000 >= 1) {
        _beginBidLab.text = [NSString stringWithFormat:@"起投金额：%.2f万元",_projectNewModel.minAmount / 10000];
    }else{
        _beginBidLab.text = [NSString stringWithFormat:@"起投金额：%.2f元",_projectNewModel.minAmount];
    }
    if (_projectNewModel.surplusAmountTypeId == 1) {
        _surplusBidLab.text = [NSString stringWithFormat:@"剩余可投：%@元",_projectNewModel.surplusAmount];
    }else{
        _surplusBidLab.text = [NSString stringWithFormat:@"剩余可投：%@万元",_projectNewModel.surplusAmount];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
