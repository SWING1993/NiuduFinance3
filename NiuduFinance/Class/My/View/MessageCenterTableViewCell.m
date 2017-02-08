//
//  MessageCenterTableViewCell.m
//  NiuduFinance
//
//  Created by liuyong on 16/3/21.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "MessageCenterTableViewCell.h"
#import "NSString+Adding.h"
@implementation MessageCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMsgCenterDic:(NSDictionary *)msgCenterDic
{
    _msgCenterDic = msgCenterDic;
    
    _msgDataLab.text = [_msgCenterDic objectForKey:@"CreationDate"];
    
    if (!IsStrEmpty([_msgCenterDic objectForKey:@"Title"])) {
        _msgTitleLab.text = [_msgCenterDic objectForKey:@"Title"];
    }else{
        
        _msgTitleLab.text = @"系统消息";
    }
    
    if ([[_msgCenterDic objectForKey:@"IsReadId"] integerValue] == 2) {
        _msgTitleLab.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    
    NSString *contentStr = nil;
    NSScanner * scanner = [NSScanner scannerWithString:[_msgCenterDic objectForKey:@"Content"]];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        contentStr = [[_msgCenterDic objectForKey:@"Content"] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"p" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"br/" withString:@"\n"];
    
    _msgContentLab.text = contentStr;
    CGSize borrowSize =[ _msgContentLab.text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedSize:CGSizeMake(SCREEN_WIDTH - 30, 5000)];
    _msgContentLab.size = CGSizeMake(SCREEN_WIDTH - 30, borrowSize.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
