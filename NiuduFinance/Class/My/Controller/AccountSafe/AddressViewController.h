//
//  AddressViewController.h
//  NiuduFinance
//
//  Created by andrewliu on 16/9/17.
//  Copyright © 2016年 liuyong. All rights reserved.
//

#import "BaseViewController.h"

@interface AddressViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;

@property (weak, nonatomic) IBOutlet UITextField *codeTextFiled;

@property (weak, nonatomic) IBOutlet UITextField *addressTextFiled;


@property (weak, nonatomic) IBOutlet UITextField *detailAddressTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (nonatomic,strong)NSString *mobileStr;

@property (nonatomic,strong) NSString *realName;


@end
