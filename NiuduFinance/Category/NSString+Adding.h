//
//  NSString+Adding.h
//  PublicFundraising
//
//  Created by liuyong on 15/10/20.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (Adding)

- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size;
- (NSString *)strmethodComma;
- (NSString *)wanStrmethodComma;
-(int)convertToInt:(NSString*)strtemp;
- (NSMutableAttributedString *)attributedText:(NSString *)text beginIndex:(NSInteger)index length:(NSInteger)length colorStr:(NSString *)color font:(CGFloat)font;
+ (BOOL) isMobile:(NSString *)mobileNumbel;
+ (BOOL)isValidateEmail:(NSString *)email;

@end
