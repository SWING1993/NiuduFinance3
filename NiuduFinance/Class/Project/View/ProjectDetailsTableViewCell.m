//
//  ProjectDetailsTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/26.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "ProjectDetailsTableViewCell.h"
#import "ProjectDetailsViewController.h"
#import "NetWorkingUtil.h"

#import "NSString+Adding.h"

@interface ProjectDetailsTableViewCell ()<UITextFieldDelegate>

//   筛选红包
@property (nonatomic,strong)NSMutableArray *selectHongBaoArr;

//   筛选红包后的ID
@property (nonatomic,strong)NSMutableArray *selectIDHongBaoArr;

@end


@implementation ProjectDetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [_investTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    _investTextField.delegate = self;
    
    _window = [[[UIApplication sharedApplication] windows] lastObject];
    
//    _hongbaoArray = [NSMutableArray array];
//    [self loadHongBaoArray];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePickerView) name:@"hidePickerViewNoti" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginHidePickerView) name:@"TextBeginHidePickerViewNoti" object:nil];
}

- (NSMutableArray *)selectHongBaoArr
{
    if (!_selectHongBaoArr) {
        _selectHongBaoArr = [NSMutableArray array];
    }
    return _selectHongBaoArr;
}

- (NSMutableArray *)selectIDHongBaoArr
{
    if (!_selectIDHongBaoArr) {
        _selectIDHongBaoArr = [NSMutableArray array];
    }
    return _selectIDHongBaoArr;
}

- (void)hidePickerView{

    [_zhBPickerView removeFromSuperview];

}

- (void)textBeginHidePickerView
{
    [_selectHongBaoArr removeAllObjects];
    [_selectIDHongBaoArr removeAllObjects];
    
    _hongBaoButton.tag = 1;
    [_zhBPickerView removeFromSuperview];
}



//选择红包
- (IBAction)showRedEnvelope:(id)sender {
    
    if (!IsStrEmpty(_investTextField.text)) {
        
        NSString *noUseHongBao = @"不使用现金券";
        [self.selectHongBaoArr addObject:noUseHongBao];
        
        NSString *loanDateStr = @"";
        
        if ([[_dic objectForKey:@"PeriodTypeId"] integerValue] == 1) {
            loanDateStr = [NSString stringWithFormat:@"%ld",[[_dic objectForKey:@"LoanDate"] integerValue] / 30];
        }else if ([[_dic objectForKey:@"PeriodTypeId"] integerValue] == 2){
            loanDateStr = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"LoanDate"]];
        }else if ([[_dic objectForKey:@"PeriodTypeId"] integerValue] == 3){
            loanDateStr = [NSString stringWithFormat:@"%ld",[[_dic objectForKey:@"LoanDate"] integerValue] * 12];
        }
        
        for (int i = 0; i < _getHongBaoArray.count; i ++) {
            if ([_investTextField.text integerValue] >=[[_getHongBaoArray[i] objectForKey:@"bidamount"] integerValue] && [loanDateStr integerValue] >= [[_getHongBaoArray[i] objectForKey:@"loanperiod"] integerValue]) {
                
                [self.selectHongBaoArr addObject:[_hongbaoArray objectAtIndex:i + 1]];
                [self.selectIDHongBaoArr addObject:[_getHongBaoArray objectAtIndex:i]];
            }
        }
    }
    
    [_investTextField resignFirstResponder];
    
    if (_hongBaoButton.tag == 1) {
        _hongBaoButton.tag = 2;
        _zhBPickerView =  [[[NSBundle mainBundle] loadNibNamed:@"ZHBPickerView" owner:self options:nil] firstObject];
        _zhBPickerView.showHongBao = YES;
        _zhBPickerView.dataSource = self;
        _zhBPickerView.delegate = self;
        _zhBPickerView.frame = CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200);
        [_window addSubview:_zhBPickerView];
    }else{
        _hongBaoButton.tag = 1;
        [_zhBPickerView removeFromSuperview];
    }
    
}

//充值
- (IBAction)goEncash:(id)sender {
    
    [_zhBPickerView removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(projectTableViewCell:supportProject:)]) {
        [self.delegate projectTableViewCell:self supportProject:nil];
    }
}



- (void)setType:(NSString *)type
{
    _type = type;
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
}

- (void)setHongbaoTextField:(UILabel *)hongbaoTextField
{
    _hongbaoTextField = hongbaoTextField;
}

- (void)setHongbaoArray:(NSMutableArray *)hongbaoArray
{
    _hongbaoArray = hongbaoArray;
}

- (void)textFieldChange:(UITextField *)textField
{
    [_zhBPickerView removeFromSuperview];
    if (IsStrEmpty(textField.text)) {
        _earningsTextField.text = nil;
    }else{
        if ([_type isEqual:@"理财"]) {
            if ([[_dic objectForKey:@"LoanDate"] isEqual:@"天"]) {
                NSString *srcStr = [NSString stringWithFormat:@"%f",[textField.text floatValue] * [[_dic objectForKey:@"Rate"]floatValue] / 360 / 100 * [[_dic objectForKey:@"LoanPeriod"]intValue]];
                NSRange range = [srcStr rangeOfString:@"."];
                NSString *str = [srcStr substringToIndex:range.location + 3];
                _earningsTextField.text = str;
            }
            if ([[_dic objectForKey:@"LoanDate"] isEqual:@"个月"]) {
                NSString *srcStr = [NSString stringWithFormat:@"%f",[textField.text floatValue] * [[_dic objectForKey:@"Rate"]floatValue] / 12 / 100 * [[_dic objectForKey:@"LoanPeriod"]intValue]];
                NSRange range = [srcStr rangeOfString:@"."];
                NSString *str = [srcStr substringToIndex:range.location + 3];
                _earningsTextField.text = str;
            }
            if ([[_dic objectForKey:@"LoanDate"] isEqual:@"年"]) {
                NSString *srcStr = [NSString stringWithFormat:@"%f",[textField.text floatValue] * [[_dic objectForKey:@"Rate"]floatValue] / 100 * [[_dic objectForKey:@"LoanPeriod"]intValue]];
                NSRange range = [srcStr rangeOfString:@"."];
                NSString *str = [srcStr substringToIndex:range.location + 3];
                _earningsTextField.text = str;
            }
        }else{
            if ([[_dic objectForKey:@"RepaymentType"] isEqual:@"按月还款等额本息"]){
                NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
                [util requestDic4MethodName:@"project/counter" parameters:@{@"Rate":[_dic        objectForKey:@"LoanRate"],
                                @"TimeLimit":[_dic objectForKey:@"LoanDate"],
                                @"TimeType":[_dic objectForKey:@"PeriodTypeId"],
                                @"RepaymentTypeId":[_dic objectForKey:@"RepaymentTypeId"],
                                @"Principal":textField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
                                    if (status == 1 || status == 2) {
                                        float payment = [[dic objectForKey:@"Profit"]floatValue];
                                        _earningsTextField.text = [NSString stringWithFormat:@"%.2f",payment];
                                    }else{
                                        
                                    }
                                }];
                
            }else if ([[_dic objectForKey:@"RepaymentType"] isEqual:@"一次性还款"] || [[_dic objectForKey:@"RepaymentType"] isEqual:@"按月付息到期还本"]){
                
                if ([[_dic objectForKey:@"PeriodTypeId"]intValue] == 1) {
                    NSString *srcStr = [NSString stringWithFormat:@"%f",[textField.text floatValue] * [[_dic objectForKey:@"LoanRate"]floatValue] / 360 / 100 * [[_dic objectForKey:@"LoanDate"]intValue]];
                    NSRange range = [srcStr rangeOfString:@"."];
                    NSString *str = [srcStr substringToIndex:range.location + 3];
                    _earningsTextField.text = str;
                }
                if ([[_dic objectForKey:@"PeriodTypeId"]intValue] == 2) {
                    NSString *srcStr = [NSString stringWithFormat:@"%f",[textField.text floatValue] * [[_dic objectForKey:@"LoanRate"]floatValue] / 12 / 100 * [[_dic objectForKey:@"LoanDate"]intValue]];
                    NSRange range = [srcStr rangeOfString:@"."];
                    NSString *str = [srcStr substringToIndex:range.location + 3];
                    _earningsTextField.text = str;
                }
                if ([[_dic objectForKey:@"PeriodTypeId"] intValue] == 3) {
                    NSString *srcStr = [NSString stringWithFormat:@"%f",[textField.text floatValue] * [[_dic objectForKey:@"LoanRate"]floatValue] / 100 * [[_dic objectForKey:@"LoanDate"]intValue]];
                    NSRange range = [srcStr rangeOfString:@"."];
                    NSString *str = [srcStr substringToIndex:range.location + 3];
                    _earningsTextField.text = str;
                }
            }
        }
    }
}

- (void)setAvailableBalanceStr:(NSString *)availableBalanceStr
{
    _availableBalanceStr = availableBalanceStr;
    _availableLab.text = [[[NSString stringWithFormat:@"%.2f",[_availableBalanceStr floatValue]] strmethodComma] stringByAppendingString:@"元"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//   zhBPickerView  delegate
- (NSInteger)numberOfComponentsInPickerView:(ZHBPickerView *)pickerView
{
    return 1;
}

- (NSArray *)pickerView:(ZHBPickerView *)pickerView titlesForComponent:(NSInteger)component
{
    if (component == 0) {
        if (_selectHongBaoArr.count > 0) {
            return _selectHongBaoArr;
        }
        return self.hongbaoArray;
    }
    return nil;
}


- (void)pickerView:(ZHBPickerView *)pickerView didSelectContent:(NSString *)content
{
    if (IsStrEmpty(_investTextField.text)) {
        [MBProgressHUD showMessag:@"请先输入您投资的金额" toView:self.delegate.view];
        _hongBaoButton.tag = 1;
        [_zhBPickerView removeFromSuperview];
        return;
    }
    
    _hongBaoButton.tag = 1;
    
    _hongbaoTextField.text = content;
    _hongbaoTextField.textColor = [UIColor colorWithHexString:@"#444444"];
    
    NSDictionary *hongbaoDic;
    if (pickerView.isSelected == 0) {
        hongbaoDic = @{@"hongbao":@"不使用现金券"};
    }else{
        hongbaoDic = @{@"hongbao":_selectIDHongBaoArr[pickerView.isSelected - 1]};
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hongbaoNoti" object:nil userInfo:hongbaoDic];
    
    
    if ([content isEqual:@""]) {
        if (_selectHongBaoArr.count > 0) {
            _hongbaoTextField.text = _selectHongBaoArr[pickerView.isSelected];
        }else{
            _hongbaoTextField.text = _hongbaoArray[pickerView.isSelected];
        }
    }
    
    [_selectHongBaoArr removeAllObjects];
    [_selectIDHongBaoArr removeAllObjects];
}

- (void)cancelSelectPickerView:(ZHBPickerView *)pickerView
{
    [_selectHongBaoArr removeAllObjects];
    [_selectIDHongBaoArr removeAllObjects];
    
    _hongBaoButton.tag = 1;
    [_zhBPickerView removeFromSuperview];
}

@end
