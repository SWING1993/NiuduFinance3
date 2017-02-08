//
//  PSPayTextField.m
//  支付密码
//
//  Created by zhoupushan on 16/3/7.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "PSPayTextField.h"
@interface PSPayTextField()
@property (weak, nonatomic) IBOutlet UIImageView *editBorderImageView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *passwordLabels;
@property (strong, nonatomic) UITextField *textField;
@end
@implementation PSPayTextField

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PSPayTextField class]) owner:nil options:nil] lastObject];
        
        [self setup];
    }
    return self;
}

+ (instancetype)textFieldFromXib
{
    PSPayTextField *textField = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PSPayTextField class]) owner:nil options:nil] lastObject];
    [textField setup];
    return textField;
}

- (void)setFrame:(CGRect)frame
{
    frame.size = CGSizeMake(308, 49);
    [super setFrame:frame];
}

- (void)setup
{
    [self addTextField];
    [self addTapGesture];
}

- (void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)addTextField
{
    _textField = [[UITextField alloc]init];
    [_textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_textField];
}

- (void)textDidChange:(UITextField *)textField
{
    NSLog(@"newTextField============%@",textField.text);
    NSInteger textLength = textField.text.length;
    if (textLength > 6 )
    {
        textField.text = [textField.text substringToIndex:6];
        NSLog(@"changeTextField============%@",textField.text);
        return;
    }
    else
    {
        //1 ~ 6
        NSInteger oldTextLength = _text.length;//1  0
        
        if (textLength > oldTextLength)
        {
            //显示
            UILabel *pointLabel = _passwordLabels[textLength - 1];
            pointLabel.hidden = NO;
        }
        else
        {
            //隐藏
            UILabel *pointLabel = _passwordLabels[oldTextLength - 1];
            pointLabel.hidden = YES;
        }
        
    }
    _text = textField.text;
    if ([self.delegate respondsToSelector:@selector(ps_textField:textDidChange:)])
    {
        [self.delegate ps_textField:self textDidChange:_text];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length > 5)
    {
        return NO;
    }
    return YES;
}

#pragma mark - Actions
- (void)tapAction
{
    if (![_textField isFirstResponder])
    {
        [_textField becomeFirstResponder];
        _editBorderImageView.hidden = NO;
    }
}

#pragma mark - Public
- (BOOL)ps_resignFirstResponder
{
    BOOL resign = NO;
    if ([_textField isFirstResponder])
    {
        _editBorderImageView.hidden = YES;
        resign = [_textField resignFirstResponder];
    }
    return resign;
}
@end
