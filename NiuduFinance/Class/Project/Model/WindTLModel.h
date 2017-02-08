//
//  WindTLModel.h
//  NiuduFinance
//
//  Created by liuyong on 16/3/1.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLAttributedLabel.h"


@interface WindTLModel : NSObject

@property (nonatomic, assign) TLSwitchState state;
@property (nonatomic, copy) NSString *riskManagement;
@property (nonatomic, assign) NSUInteger numberOfLines;
@end
