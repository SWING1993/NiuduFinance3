//
//  PSExtern.m
//  PublicFundraising
//
//  Created by zhoupushan on 15/10/28.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "PSExtern.h"

NSArray *getAllTradeTypeList(void)
{
    static NSArray *list = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        list = [[NSArray alloc] initWithObjects:
                @"angry",
                @"anthomaniac",
                @"appall",
                @"arrogant",
                @"awesome",
                @"awkward",
                @"bored",
                @"collapse",
                @"cool",
                @"cute",
                @"dinner",
                @"dizzy",
                @"doubt",
                @"gifts",
                @"giggle",
                @"grimace",
                @"helpless",
                @"hot",
                @"jiong",
                @"kink",
                @"laughter",
                @"narcissism",
                @"ok",
                @"petrifaction",
                @"proud",
                @"prurience",
                @"refuse",
                @"request",
                @"rewarding",
                @"ridicule",
                @"roar",
                @"shake_hands",
                @"shame",
                @"shy",
                @"sleep",
                @"smile",
                @"smirk",
                @"speechless",
                @"tears",
                @"think",
                @"trance",
                @"vomit",
                @"welcome",
                @"yeah",
                nil];
    });
    return list;
}