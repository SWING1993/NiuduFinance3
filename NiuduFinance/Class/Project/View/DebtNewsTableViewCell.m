//
//  DebtNewsTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/26.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "DebtNewsTableViewCell.h"
#import "NSString+Adding.h"

@interface DebtNewsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *windDescribeLab;
@property (weak, nonatomic) IBOutlet UILabel *borrowDescribeLab;

@end

@implementation DebtNewsTableViewCell

- (void)awakeFromNib {
    
}

- (void)setDebtDic:(NSDictionary *)debtDic
{
    _debtDic = debtDic;
    
    _debtRateLab.text = [NSString stringWithFormat:@"%.2f%s",[[_debtDic objectForKey:@"CurrentRate"] floatValue],"%"];
}

- (void)setProjectDic:(NSDictionary *)projectDic
{
    _projectDic = projectDic;
    
    [self setLabStyle];
    
    _debtUserLab.text = [_projectDic objectForKey:@"UserName"];
    _debtHouseLab.text = [_projectDic objectForKey:@"Residence"];
    _debtCarLab.text = [_projectDic objectForKey:@"BuyCar"];
    _debtAmountLab.text = [NSString stringWithFormat:@"%.2f元",[[_projectDic objectForKey:@"Amount"] floatValue]];
    _debtUseLab.text = [_projectDic objectForKey:@"LoanUseName"];
}

- (void)setLabStyle
{
    if (IsStrEmpty([_projectDic objectForKey:@"Description"])) {
        _windDescribeLab.text = [NSString stringWithFormat:@"借款描述：%@",@" "];
    }else{
         _borrowDescribeLab.text = [NSString stringWithFormat:@"借款描述：%@",[_projectDic objectForKey:@"Description"]];
    }
   
    NSMutableAttributedString *borrowStr = [[NSMutableAttributedString alloc]initWithString:_borrowDescribeLab.text];
    [borrowStr beginEditing];
    [borrowStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0, 5)];
    _borrowDescribeLab.attributedText = borrowStr;
    CGSize borrowSize =[ _borrowDescribeLab.text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedSize:CGSizeMake(SCREEN_WIDTH - 60, 1000)];
    _borrowDescribeLab.size = borrowSize;
    _windDescribeLab.top = 213 + borrowSize.height + 8;
    
    
    if (IsStrEmpty([_projectDic objectForKey:@"RiskManagement"])) {
         _windDescribeLab.text = [NSString stringWithFormat:@"风控描述：%@",@" "];
    }else{
        _windDescribeLab.text = [NSString stringWithFormat:@"风控描述：%@",[self sortStr:[_projectDic objectForKey:@"RiskManagement"]]];
    }
    
    NSMutableAttributedString *windStr = [[NSMutableAttributedString alloc]initWithString:_windDescribeLab.text];
    [windStr beginEditing];
    [windStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0, 5)];
    _windDescribeLab.attributedText = windStr;
    CGSize windSize =[ _windDescribeLab.text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedSize:CGSizeMake(SCREEN_WIDTH - 60, 1000)];
    _windDescribeLab.size = windSize;
    
}

- (NSString *)sortStr:(NSString *)str
{
    NSString *contentStr = nil;
    NSScanner * scanner = [NSScanner scannerWithString:str];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        contentStr = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"p" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return contentStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
