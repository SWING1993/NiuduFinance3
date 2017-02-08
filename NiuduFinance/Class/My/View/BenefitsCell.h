//
//  BenefitsCell.h
//  NiuduFinance
//
//  Created by andrewliu on 16/10/25.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,HongbaoState)
{
    HongbaoStateCanUser,
    HongbaoStateUsed,
    HongbaoStateAbandon
};


@interface BenefitsCell : UITableViewCell



- (void)creditorState:(HongbaoState)state model:(NSDictionary *)modelDic;
@end
