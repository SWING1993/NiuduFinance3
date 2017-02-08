//
//  CodeTableViewCell.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/18.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "CodeTableViewCell.h"
#import "NetWorkingUtil.h"
@interface CodeTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *pleaseCodeLabel;

@property (weak, nonatomic) IBOutlet UILabel *hyperlinksLabel;


@end

@implementation CodeTableViewCell


- (void)setMsgDic:(NSDictionary *)msgDic
{
    _msgDic = msgDic;
    //设置链接为超链接
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[msgDic objectForKey:@"InvitationUrl"]];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    self.hyperlinksLabel.attributedText = content;
    
    [NetWorkingUtil setImage:self.iconImageView url:[NSString stringWithFormat:@"%@",[msgDic objectForKey:@"InvitationQrcode"] ] defaultIconName:nil];
    
    self.imageView.contentMode  = UIViewContentModeTop;
    
    self.pleaseCodeLabel.text = [msgDic objectForKey:@"InvitationCode"];
    
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.button.layer.cornerRadius = 3.0f;
    self.button.autoresizingMask = YES;
    
    
}
- (IBAction)copyLinkButton:(id)sender {
    
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[[self hyperlinksLabel]text]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"copysuccessNoti" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
