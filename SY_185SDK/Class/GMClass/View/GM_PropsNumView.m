//
//  GM_PropsNumView.m
//  SY_GMSDK
//
//  Created by 燚 on 2017/10/18.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "GM_PropsNumView.h"
#import "GM_ViewModel.h"

#define Vertical_Screen (kSCREEN_HEIGHT > kSCREEN_WIDTH ? YES : NO)
#define TextField_Vertical (self.textField.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 5))
#define TextField_Horizontal (self.textField.center = CGPointMake(kSCREEN_WIDTH / 2, 44))

#define CompleteButton_Vertical (self.completeButton.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 5 + 60))
#define CompleteButton_Horizontal (self.completeButton.center = CGPointMake(kSCREEN_WIDTH / 2, 44 + 60))

@interface GM_PropsNumView () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *completeButton;

@end

@implementation GM_PropsNumView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.backgroundColor = RGBACOLOR(55, 55, 55, 155);
    [self addSubview:self.textField];
    [self addSubview:self.completeButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    Vertical_Screen ? TextField_Vertical : TextField_Horizontal;
    Vertical_Screen ? CompleteButton_Vertical : CompleteButton_Horizontal;
}

- (void)clearNumber {
    self.textField.text = @"";
}

#pragma mark - responds
- (void)propsNumViewInputeFinished {

    [self.textField resignFirstResponder];

    //验证输入
//    NSString *number = @"^[0-9]*$";
    NSString *numberZ = @"^+[1-9][0-9]*$";
    NSPredicate *regextestmobilez = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberZ];

    NSString *numberF = @"^-[1-9][0-9]*$";
    NSPredicate *regextestmobilef = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberF];

    if ([regextestmobilez evaluateWithObject:self.textField.text] || [regextestmobilef evaluateWithObject:self.textField.text]) {

        if (self.delegate && [self.delegate respondsToSelector:@selector(GMPropsNumView:completeInputWithString:)]) {
            [self.delegate GMPropsNumView:self completeInputWithString:self.textField.text];
        }

        [self removeFromSuperview];

    } else {
        SDK_MESSAGE(@"请输入数字");
    }

}


#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self propsNumViewInputeFinished];
    return YES;
}

//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.textField) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.textField.text.length >= 16) {
            self.textField.text = [textField.text substringToIndex:16];
            return NO;
        }
    }

    return YES;
}


#pragma mark - getter
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.bounds = CGRectMake(0, 0, k_WIDTH * 0.8, 44);
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.placeholder = @"请输入数量";
    }
    return _textField;
}

- (UIButton *)completeButton {
    if (!_completeButton) {
        _completeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _completeButton.bounds = CGRectMake(0, 0, k_WIDTH * 0.8, 44);
        _completeButton.layer.cornerRadius = 8;
        _completeButton.layer.masksToBounds = YES;
        _completeButton.backgroundColor = RGBCOLOR(199, 176, 41);
        [_completeButton setTitle:@"完成" forState:(UIControlStateNormal)];
        [_completeButton addTarget:self action:@selector(propsNumViewInputeFinished) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _completeButton;
}



@end










