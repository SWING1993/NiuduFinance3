//
//  WindDescribeTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/2/29.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "WindDescribeTableViewCell.h"
#import "NSString+Adding.h"
#import "NSAttributedString+HTML.h"

@implementation WindDescribeTableViewCell


- (void)awakeFromNib {
    
}

- (void)setWindDescribeStr:(NSString *)windDescribeStr
{
    _windDescribeStr = windDescribeStr;
    
    NSString *contentStr = nil;
    NSScanner * scanner = [NSScanner scannerWithString:_windDescribeStr];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        contentStr = [_windDescribeStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"p" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"br/" withString:@"\n"];
    
    _windDescribeLab.text = contentStr;
    CGSize borrowSize =[ _windDescribeLab.text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedSize:CGSizeMake(SCREEN_WIDTH-20, 15000)];
  
    _windDescribeLab.size = borrowSize;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
