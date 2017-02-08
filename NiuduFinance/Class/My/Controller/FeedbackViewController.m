//
//  FeedbackViewController.m
//  NiuduFinance
//
//  Created by zhoupushan on 16/3/8.
//  Copyright © 2016年 liuyong. All rights reserved.
//
#define TEXT_MAXLENGTH           @"100"
#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UILabel *placeHouderLab;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self backBarItem];
    [self setupTextView];
    
    _commitBtn.layer.cornerRadius = 5.0f;
}

- (void)setupTextView
{
    _textView.layer.borderColor = [UIColor colorWithHexString:@"#DEDEDE"].CGColor;
    _textView.layer.borderWidth = 2.0;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (![textView.text isEqualToString:@""]) {
        _placeHouderLab.hidden = YES;
        _commitBtn.userInteractionEnabled = YES;
        _commitBtn.backgroundColor = NaviColor;
    }
    if ([textView.text isEqualToString:@""]) {
        _placeHouderLab.hidden = NO;
        _commitBtn.userInteractionEnabled = NO;
        _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    }
    
    if (_textView.text.length > 100) {
        [MBProgressHUD showError:@"已经超过最大字数" toView:self.view];
        NSRange rgs = {0,TEXT_MAXLENGTH.intValue};
        NSString *s = [textView.text substringWithRange:rgs];
        [textView setText:[textView.text stringByReplacingOccurrencesOfString:textView.text withString:s]];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        _placeHouderLab.hidden = YES;
        _commitBtn.userInteractionEnabled = YES;
        _commitBtn.backgroundColor = NaviColor;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        _placeHouderLab.hidden = NO;
        _commitBtn.userInteractionEnabled = NO;
        _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    }
    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger res = TEXT_MAXLENGTH.intValue -[new length];
    NSLog(@"%ld",(long)res);
    if ([text length] > (TEXT_MAXLENGTH.intValue - textView.text.length)) {
        [MBProgressHUD showError:@"已经超过最大字数" toView:self.view];
        return NO;
    }else{
        if(res >= 0){
            return YES;
        }else{
            NSRange rg = {0,[text length]+res};
            //            NSLog(@"---%lu",[text length]+res);
            //            NSLog(@"==%lu",(unsigned long)rg.length);
            if (rg.length > 0) {
                NSRange rgs = {0,TEXT_MAXLENGTH.intValue};
                NSString *s = [textView.text substringWithRange:rgs];
                [textView setText:[textView.text stringByReplacingOccurrencesOfString:textView.text withString:s]];
                return NO;
            }
            return NO;
        }
    }
    return YES;
}

- (IBAction)confirmAction
{
    if (_textView.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入反馈内容" toView:self.view];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"user/feedback" parameters:@{@"Contents":_textView.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        
        
        if (status == 1 || status == 2) {
            [hud dismissSuccessStatusString:@"提交成功" hideAfterDelay:0.5];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
        }else{
            [hud dismissErrorStatusString:msg hideAfterDelay:1.0];
        }
    }];
}

- (void)delayMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
