//
//  NSAttributedString+HTML.m
//  NiuDuZPro
//
//  Created by liuyong on 15/9/29.
//  Copyright (c) 2015年 aifeng. All rights reserved.
//

#import "NSAttributedString+HTML.h"
#import <UIKit/UIKit.h>
@implementation NSAttributedString (HTML)
+ (NSAttributedString*)attributedStringWithHTMLString:(NSString*)htmlString
{
//    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title><p></p></head><body style=\"background:transparent;\">"];
//    [html appendString:htmlString];
//    [html appendString:@"</body></html>"];
    return [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                     options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType
                                                    } documentAttributes:nil error:nil];
}
@end
