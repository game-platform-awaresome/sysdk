//
//  SY_ForgetPasswordView.m
//  SDK185SY
//
//  Created by 石燚 on 2017/7/13.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SY_ForgetPasswordView.h"
#import "UserModel.h"

#define LOGIN_BACK_WIDTH FLOAT_MENU_WIDTH
#define LOGIN_BACK_HEIGHT LOGIN_BACK_WIDTH * 0.8

typedef enum : NSUInteger {
    checkPhoneNumber = 0,
    checkCode,
    resetPassword,
} resetPasswordType;

@interface SY_ForgetPasswordView ()<UITextFieldDelegate>


/** 修改密码的状态 */
@property (nonatomic, assign) resetPasswordType resetPWType;
/** 提示标签 */
@property (nonatomic, strong) UILabel *resetPromptLabel;
/** 手机号\验证码\第一次密码 */
@property (nonatomic, strong) UITextField *restFirstTextField;
/** 发送验证码短信 */
@property (nonatomic, strong) UIButton *restSendMessageBtn;
/** 确定密码 */
@property (nonatomic, strong) UITextField *restConfirmTextField;
/** 下一步按钮 */
@property (nonatomic, strong) UIButton *restNextButton;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *restBackButton;
/** 电话号码 */
@property (nonatomic, strong) NSString *resetPhoneNumber;
/** token */
@property (nonatomic, strong) NSString *resetToken;


#pragma mark - timer
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timerTime;


@end

@implementation SY_ForgetPasswordView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.frame = CGRectMake(0, 0, LOGIN_BACK_WIDTH, LOGIN_BACK_HEIGHT);


    self.backgroundColor = LOGIN_BACKGROUNDCOLOR;

    //返回按钮
    [self addSubview:self.restBackButton];
    //提示标签
    [self addSubview:self.resetPromptLabel];
    //第二个输入框
    [self addSubview:self.restConfirmTextField];
    //第一个输入框
    [self addSubview:self.restFirstTextField];
    //发送验证码按钮
    [self addSubview:self.restSendMessageBtn];
    //下一步
    [self addSubview:self.restNextButton];
}

//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.restFirstTextField) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.restFirstTextField.text.length >= 16) {
            self.restFirstTextField.text = [textField.text substringToIndex:16];
            return NO;
        }
    } else if (textField == self.restConfirmTextField) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.restConfirmTextField.text.length >= 16) {
            self.restConfirmTextField.text = [textField.text substringToIndex:16];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - rsponds
/** 关闭重置密码页面 */
- (void)respondsToRestBackButton {
    [self removeFromSuperview];
    self.resetPWType = checkPhoneNumber;
    _resetPhoneNumber = nil;
    _resetToken = nil;
    self.restConfirmTextField.text = @"";
}

/** 点击下一步按钮 */
/* */
- (void)respondsToRSNextButton {
    switch (_resetPWType) {
        case checkPhoneNumber: {
            //检查手机号
            if (![self isPhoneNumber:self.restFirstTextField.text]) {
                [InfomationTool showAlertMessage:@"请输入正确的手机号" dismissTime:0.5 dismiss:nil];
                break;
            }

            SDK_START_ANIMATION;

            [UserModel isRegisterWithphoneNumber:self.restFirstTextField.text Completion:^(NSDictionary *content, BOOL success) {

                SDK_STOP_ANIMATION;
                if (success) {
                    NSString *state = SDK_CONTENT_DATA[@"is_exsists"];
                    if (state.integerValue == 1) {
                        self.resetPWType = checkCode;
                        [self respondsToRPWSendmessageBtn];
                    } else {
                        [InfomationTool showAlertMessage:@"手机号码没有注册或绑定" dismissTime:0.5 dismiss:nil];
                    }
                } else {
                    [InfomationTool showAlertMessage:[NSString stringWithFormat:@"%@",content[@"msg"]] dismissTime:0.5 dismiss:nil];
                }
            }];

            break;
        }

        case checkCode: {
            //检查验证码
            if (![self isSendMessageCode:self.restFirstTextField.text]) {
                [InfomationTool showAlertMessage:@"请输入6位数字验证码" dismissTime:0.7 dismiss:nil];
                break;
            }

            SDK_START_ANIMATION;
            [UserModel resetPasswordVerificationWithCode:self.restFirstTextField.text PhoneNumber:_resetPhoneNumber completion:^(NSDictionary *content, BOOL success) {

                SDK_STOP_ANIMATION;
                if (success) {

                    _resetToken = SDK_CONTENT_DATA[@"token"];
                    [UserModel currentUser].uid = SDK_CONTENT_DATA[@"id"];
                    self.resetPWType = resetPassword;
                    [self.timer invalidate];
                    self.timer = nil;
                    [self.restSendMessageBtn setTitle:@"发送验证码" forState:(UIControlStateNormal)];

                } else {

                    [InfomationTool showAlertMessage:[NSString stringWithFormat:@"%@",content[@"msg"]] dismissTime:0.7 dismiss:nil];
                }
            }];

            break;
        }
        case resetPassword: {
            //验证密码是否相同
            if (![self.restFirstTextField.text isEqualToString:self.restConfirmTextField.text]) {
                [InfomationTool showAlertMessage:@"两次输入的密码不相等" dismissTime:0.7 dismiss:nil];
                break;
            }

            SDK_START_ANIMATION;
            [UserModel ResetPasswordWithToken:_resetToken PhoneNumber:_resetPhoneNumber Password:self.restFirstTextField.text completion:^(NSDictionary *content, BOOL success) {

                SDK_STOP_ANIMATION;
                if (success) {

                    self.userInteractionEnabled = NO;

                    [InfomationTool showAlertMessage:@"密码重置成功" dismissTime:0.7 dismiss:^{
                        self.userInteractionEnabled = YES;
                        //关闭找回密码页面
                        [self respondsToRestBackButton];
                    }];

                } else {
                    [InfomationTool showAlertMessage:[NSString stringWithFormat:@"%@",content[@"msg"]] dismissTime:0.7 dismiss:nil];
                }
            }];

            break;
        }

        default:
            break;
    }
}
/* */

/** 点击下一步测试用的 *
 - (void)respondsToRSNextButton {
     switch (_resetPWType) {
         case checkPhoneNumber: {

             self.resetPWType = checkCode;
             break;
         }

         case checkCode: {

             self.resetPWType = resetPassword;
             break;
         }
         case resetPassword: {

             self.resetPWType = checkPhoneNumber;
             break;
         }

         default:
             break;
     }
 }
* */

/** 设置页面 */
- (void)setResetPWType:(resetPasswordType)resetPWType {
    _resetPWType = resetPWType;
    switch (resetPWType) {
        case checkPhoneNumber: {
            self.resetPromptLabel.text = @"请输入绑定的手机号码:";
            self.restFirstTextField.text = @"";
            self.restFirstTextField.placeholder = @"请输入手机号:";
            //            self.restConfirmTextField.frame = self.restFirstTextField.frame;
            [UIView animateWithDuration:0.3 animations:^{
                self.restConfirmTextField.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.9, LOGIN_BACK_HEIGHT * 0.175);
                self.restConfirmTextField.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.4);

                self.resetPromptLabel.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.9, LOGIN_BACK_HEIGHT * 0.175);
                self.resetPromptLabel.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.15);

                self.restSendMessageBtn.bounds = CGRectMake(0, 0, 0, LOGIN_BACK_HEIGHT * 0.175);

                self.restFirstTextField.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.9, LOGIN_BACK_HEIGHT * 0.175);
                self.restFirstTextField.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.4);


            } completion:^(BOOL finished) {

            }];
            break;
        }

        case checkCode: {
            _resetPhoneNumber = [self.restFirstTextField.text copy];
            self.resetPromptLabel.text = [NSString stringWithFormat:@"绑定手机号 :%@",_resetPhoneNumber];
            self.restFirstTextField.text = @"";
            self.restFirstTextField.placeholder = @"请输入6位验证码";

            CGRect rect = self.restFirstTextField.frame;
            rect.size.width = LOGIN_BACK_WIDTH * 0.6;

            [UIView animateWithDuration:0.3 animations:^{

                self.restFirstTextField.frame = rect;

                self.restConfirmTextField.frame = self.restFirstTextField.frame;

                self.restSendMessageBtn.frame = CGRectMake(CGRectGetMaxX(rect) + 10, rect.origin.y, LOGIN_BACK_WIDTH * 0.3 - 10, rect.size.height);

            } completion:^(BOOL finished) {

            }];


            break;
        }
        case resetPassword: {
            self.resetPromptLabel.text = @"请输入新的密码,并且确认";
            self.restFirstTextField.text = @"";
            self.restFirstTextField.placeholder = @"请输入新密码:";
            [UIView animateWithDuration:0.3 animations:^{
                self.resetPromptLabel.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.15);

                self.restFirstTextField.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.9, LOGIN_BACK_HEIGHT * 0.175);
                self.restFirstTextField.center = CGPointMake(LOGIN_BACK_WIDTH * 0.5, LOGIN_BACK_HEIGHT * 0.3);

                self.restConfirmTextField.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.9, LOGIN_BACK_HEIGHT * 0.175);
                self.restConfirmTextField.center = CGPointMake(LOGIN_BACK_WIDTH * 0.5 , LOGIN_BACK_HEIGHT * 0.5);

                self.restSendMessageBtn.bounds = CGRectMake(0, 0, 0, LOGIN_BACK_HEIGHT * 0.175);

            } completion:^(BOOL finished) {

            }];


            break;
        }

        default:
            break;
    }
}

/** 发送找回密码短信 */
- (void)respondsToRPWSendmessageBtn {

    self.restSendMessageBtn.userInteractionEnabled = NO;
    self.timerTime = 59;
    [self.restSendMessageBtn setTitle:@"60s" forState:(UIControlStateNormal)];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(respondsToResetPassword) userInfo:nil repeats:YES];

    [UserModel phoneResetPasswordCodeWithPhoneNumber:_resetPhoneNumber completion:^(NSDictionary *content, BOOL success) {
//        syLog(@"%@",content);
    }];
}

/** 找回密码(重置密码)时验证码等待 */
- (void)respondsToResetPassword {
    if (self.timerTime > 1) {
        [self.restSendMessageBtn setTitle:[NSString stringWithFormat:@"%lds",(long)self.timerTime] forState:(UIControlStateNormal)];
    } else {
        [self.restSendMessageBtn setTitle:@"发送验证码" forState:(UIControlStateNormal)];
        [self.timer invalidate];
        self.timer = nil;
        self.restSendMessageBtn.userInteractionEnabled = YES;
    }
    self.timerTime--;
}

/** 检查是否是手机号码 */
- (BOOL)isPhoneNumber:(NSString *)phoneNumber {

    NSString *MOBILE = @"^1(3[0-9]|4[0-9]|5[0-35-9]|8[0-9]|7[0-9])\\d{8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];

    return [regextestmobile evaluateWithObject:phoneNumber];

}

/** 检查验证码 */
- (BOOL)isSendMessageCode:(NSString *)messageCode {

    NSString *MOBILE = @"^[0-9]{6}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];

    return [regextestmobile evaluateWithObject:messageCode];

}

#pragma mark - getter
/** 提示标签 */
- (UILabel *)resetPromptLabel {
    if (!_resetPromptLabel) {
        _resetPromptLabel = [[UILabel alloc] init];
        _resetPromptLabel.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.9, LOGIN_BACK_HEIGHT * 0.15);
        _resetPromptLabel.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.15);
        _resetPromptLabel.textAlignment = NSTextAlignmentLeft;

        _resetPromptLabel.text = @"请输入绑定的手机号码:";
        _resetPromptLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _resetPromptLabel;
}

/** 第一个输入框 */
- (UITextField *)restFirstTextField {
    if (!_restFirstTextField) {
        _restFirstTextField = [[UITextField alloc] init];
        _restFirstTextField.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.9, LOGIN_BACK_HEIGHT * 0.175);
        _restFirstTextField.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.4);
        _restFirstTextField.placeholder = @"请输入手机号:";
        _restFirstTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

        _restFirstTextField.returnKeyType = UIReturnKeyDone;
        _restFirstTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _restFirstTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

        _restFirstTextField.borderStyle = UITextBorderStyleNone;
        _restFirstTextField.layer.borderWidth = 1;
        _restFirstTextField.layer.borderColor = RGBCOLOR(223, 202, 211).CGColor;
        _restFirstTextField.layer.cornerRadius = 5;
        _restFirstTextField.layer.masksToBounds = YES;

        _restFirstTextField.delegate = self;
        //        _restFirstTextField.secureTextEntry = YES;
        [_restFirstTextField setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    }
    return _restFirstTextField;
}

/** 发送验证码按钮 */
- (UIButton *)restSendMessageBtn {
    if (!_restSendMessageBtn) {
        _restSendMessageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _restSendMessageBtn.bounds = CGRectMake(0, 0, 0, LOGIN_BACK_HEIGHT * 0.175);
        _restSendMessageBtn.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.4);

        _restSendMessageBtn.backgroundColor = BUTTON_GREEN_COLOR;
        _restSendMessageBtn.layer.cornerRadius = 8;
        _restSendMessageBtn.layer.masksToBounds = YES;
        [_restSendMessageBtn setTitle:@"发送验证码" forState:(UIControlStateNormal)];
        _restSendMessageBtn.titleLabel.font = [UIFont systemFontOfSize:14];

        [_restSendMessageBtn addTarget:self action:@selector(respondsToRPWSendmessageBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _restSendMessageBtn;
}

/** 确认密码 */
- (UITextField *)restConfirmTextField {
    if (!_restConfirmTextField) {
        _restConfirmTextField = [[UITextField alloc] init];
        _restConfirmTextField.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.9 , LOGIN_BACK_HEIGHT * 0.175);
        _restConfirmTextField.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.4);
        _restConfirmTextField.placeholder = @"请确认密码:";
        _restConfirmTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

        _restConfirmTextField.returnKeyType = UIReturnKeyDone;
        _restConfirmTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;

        _restConfirmTextField.borderStyle = UITextBorderStyleNone;
        _restConfirmTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _restConfirmTextField.layer.borderWidth = 1;
        _restConfirmTextField.layer.borderColor = RGBCOLOR(223, 202, 211).CGColor;
        _restConfirmTextField.layer.cornerRadius = 5;
        _restConfirmTextField.layer.masksToBounds = YES;

        _restConfirmTextField.delegate = self;

        [_restConfirmTextField setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    }
    return _restConfirmTextField;
}

/** 下一步 */
- (UIButton *)restNextButton {
    if (!_restNextButton) {
        _restNextButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _restNextButton.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.9 , LOGIN_BACK_HEIGHT * 0.15);
        _restNextButton.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.7);
        [_restNextButton setTitle:@"下一步" forState:(UIControlStateNormal)];
        [_restNextButton setBackgroundColor:BUTTON_GREEN_COLOR];

        _restNextButton.layer.cornerRadius = 8;
        _restNextButton.layer.masksToBounds = YES;

        [_restNextButton addTarget:self action:@selector(respondsToRSNextButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _restNextButton;
}

/** 返回关闭按钮 */
- (UIButton *)restBackButton {
    if (!_restBackButton) {
        _restBackButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _restBackButton.frame = CGRectMake(CGRectGetMinX(self.restNextButton.frame), CGRectGetMaxY(self.restNextButton.frame) + 15, LOGIN_BACK_WIDTH / 2, 30);

        [_restBackButton setTitle:@"<<< 我想起来了" forState:(UIControlStateNormal)];
        [_restBackButton setTitleColor:TEXTCOLOR forState:(UIControlStateNormal)];
        [_restBackButton addTarget:self action:@selector(respondsToRestBackButton) forControlEvents:(UIControlEventTouchUpInside)];
        _restBackButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_restBackButton sizeToFit];
    }
    return _restBackButton;
}




@end









