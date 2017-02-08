//
//  DebtDetailsTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/26.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "DebtDetailsTableViewCell.h"
#import "NetWorkingUtil.h"
#import "DebtDetailsViewController.h"
#import "NSString+Adding.h"




@implementation DebtDetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    [_investTextField addTarget:self action:@selector(investFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)investFieldChange:(UITextField *)textField{

    NetWorkingUtil *util = [NetWorkingUtil netWorkingUtil];
    [util requestDic4MethodName:@"debtdeal/getinverster" parameters:@{@"Rate":[[_dic objectForKey:@"Project"] objectForKey:@"Rate"],
                        @"TimeLimit":[[_dic objectForKey:@"DebtDeal"] objectForKey:@"OwingNumber"],
                        @"TimeType":[[_dic objectForKey:@"Project"] objectForKey:@"Periodtypeid"],
                        @"RepaymentTypeId":[[_dic objectForKey:@"Project"] objectForKey:@"RepaymentTypeId"],
                        @"Principal":@([textField.text integerValue]*10)} result:^(NSDictionary *dic, int status, NSString *msg) {
                            
                            NSLog(@"=====%@",dic);
                            if (status == 1 || status == 2) {
                                    _getProfitLabel.text = [NSString stringWithFormat:@"%@",dic];
                                
                                }else{
                                                                        
                                }
    }];

}

- (void)setAvailableBalanceStr:(NSString *)availableBalanceStr
{
    _availableBalanceStr = availableBalanceStr;
    _availableLab.text = [[[NSString stringWithFormat:@"%.2f",[_availableBalanceStr floatValue]] strmethodComma] stringByAppendingString:@"元"];
    
}

//去充值
- (IBAction)goEncash:(id)sender {
    
    
    
    if ([self.delegate respondsToSelector:@selector(projectTableViewCell:supportProject:)]) {
        [self.delegate projectTableViewCell:self supportProject:nil];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
