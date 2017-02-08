//
//  BenefitsCell.m
//  NiuduFinance
//
//  Created by andrewliu on 16/10/25.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "BenefitsCell.h"

@interface BenefitsCell()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
//全程通用 //起投期限
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
//有效期
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
//来源
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
//起投金额
@property (weak, nonatomic) IBOutlet UILabel *qiTouLabel;
//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation BenefitsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)creditorState:(HongbaoState)state model:(NSDictionary *)modelDic{
    
    
    if (state == HongbaoStateUsed || state == HongbaoStateAbandon) {
        
        UIImage *image = [UIImage imageNamed:@"hongbaotwo"];
        
        self.bgImageView.image = image;
        
        
    }else{
        
        self.bgImageView.image = [UIImage imageNamed:@"hongbao"];
    }
//    self.bgImageView.contentMode = UIViewContentModeCenter;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"BounsValue"]];
    if (SCREEN_HEIGHT == 480 || SCREEN_HEIGHT == 568) {
        self.moneyLabel.font = [UIFont systemFontOfSize:35];
    }
    self.dataLabel.text = [NSString stringWithFormat:@"有效期:%@",[modelDic objectForKey:@"ValidDate"]];
    self.sourceLabel.text = [NSString stringWithFormat:@"来源:%@",[modelDic objectForKey:@"SourceName"]];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
