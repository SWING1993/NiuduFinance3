//
//  HongBaoCell.m
//  NiuduFinance
//
//  Created by andrewliu on 16/9/13.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "HongBaoCell.h"

@implementation HongBaoCell

- (void)creditorState:(HongbaoState)state model:(NSDictionary *)modelDic{

    [self setHongbaoState:state];
    
    
    
}


- (void)setHongbaoState:(HongbaoState)hongbaoState
{
    _hongbaoState = hongbaoState;
    self.myView.backgroundColor = [UIColor colorWithHexString:@"#F0EFF5"];
    self.myView.contentMode = UIViewContentModeCenter;
    
    if (hongbaoState == HongbaoStateUsed || hongbaoState == HongbaoStateAbandon) {
        
        UIImage *image = [UIImage imageNamed:@"youhuiquan21"];
        
        self.bgImageView.image = image;
        
        
    }else{
        
        self.bgImageView.image = [UIImage imageNamed:@"youhuiquan1"];
    }
    self.bgImageView.contentMode = UIViewContentModeCenter;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
