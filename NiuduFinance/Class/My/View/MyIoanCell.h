//
//  MuyIoanCell.h
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/9.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,IoanState)
{
    IoanStateRefunding,
    IoanStateSuccess,
    IoanStatefail
};
@interface MyIoanCell : UITableViewCell
@property (assign, nonatomic) IoanState ioanState;

@property (nonatomic,strong)NSDictionary *myIoanDic;

@property (nonatomic,strong)NSString *state;
@end
