//
//  SY_RegistView.m
//  SDK185SY
//
//  Created by 石燚 on 2017/7/13.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SY_RegistView.h"
#import "FBShimmeringView.h"

#import "UserModel.h"


#define LOGIN_BACK_WIDTH FLOAT_MENU_WIDTH
#define LOGIN_BACK_HEIGHT LOGIN_BACK_WIDTH * 0.8


@interface SY_RegistView ()<UITextFieldDelegate>

/** 是否手机注册 */
@property (nonatomic, assign) BOOL isPhoneRegister;
/** 账号 */
@property (nonatomic, strong) UITextField *registeAccount;
/** 密码 */
@property (nonatomic, strong) UITextField *registePassword;
/** 手机验证码 */
@property (nonatomic, strong) UITextField *messageCode;
/** 发送验证码按钮 */
@property (nonatomic, strong) UIButton *sendMessageBtn;
/** 注册按钮 */
@property (nonatomic, strong) UIButton *registeButton;
/** 跳转到登录页面 */
@property (nonatomic, strong) UIButton *gotoLogin;
/** 手机注册闪光 */
@property (nonatomic, strong) FBShimmeringView *phoneRegisterShimmeringView;
/** 手机账号注册 */
@property (nonatomic, strong) UIButton *phoneRegister;

#pragma mark - timer
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timerTime;

@end

@implementation SY_RegistView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    _isPhoneRegister = NO;

    self.frame = CGRectMake(-LOGIN_BACK_WIDTH, 0, LOGIN_BACK_WIDTH, LOGIN_BACK_HEIGHT);
    self.backgroundColor = LOGIN_BACKGROUNDCOLOR;
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;

    [self addSubview:self.registeAccount];
    [self addSubview:self.registePassword];
    [self addSubview:self.registeButton];
    [self addSubview:self.gotoLogin];
    [self addSubview:self.phoneRegisterShimmeringView];
    [self addSubview:self.messageCode];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self inputResignFirstResponder];
}

- (void)inputResignFirstResponder {
    [self.registeAccount resignFirstResponder];
    [self.registePassword resignFirstResponder];
    [self.messageCode resignFirstResponder];
}

#pragma mark - view method
/** 切换手机注册和账号注册 */
- (void)clickPhoneRegister:(UIButton *)sender {
    [self.registeAccount resignFirstResponder];
    [self.registePassword resignFirstResponder];

    self.userInteractionEnabled = NO;
    if (!_isPhoneRegister) {
        [UIView animateWithDuration:0.3 animations:^{
            [sender setTitle:@">>用户账号注册" forState:(UIControlStateNormal)];
            self.registeAccount.placeholder = @"请输入手机号";
            self.registeAccount.center = CGPointMake(self.registeAccount.center.x, LOGIN_BACK_HEIGHT * (0.1 + 0.04));
            self.registeAccount.keyboardType = UIKeyboardTypePhonePad;
            self.registePassword.center = CGPointMake(LOGIN_BACK_WIDTH / 2, CGRectGetMaxY(self.messageCode.frame) + self.registePassword.frame.size.height / 2);

            CGRect frame = self.messageCode.frame;
            frame.origin.y = CGRectGetMaxY(self.registeAccount.frame);
            self.messageCode.frame = frame;

            frame = self.registePassword.frame;
            frame.origin.y = CGRectGetMaxY(self.messageCode.frame);
            self.registePassword.frame = frame;
            self.messageCode.alpha = 1;
        } completion:^(BOOL finished) {
            _isPhoneRegister = YES;
            self.userInteractionEnabled = YES;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [sender setTitle:@">>手机账号注册" forState:(UIControlStateNormal)];
            self.registeAccount.center = CGPointMake(self.registeAccount.center.x, LOGIN_BACK_HEIGHT * (0.1 + 0.0875));
            self.registeAccount.placeholder = @"请输入账号";
            self.registeAccount.keyboardType = UIKeyboardTypeDefault;
            self.registePassword.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.4);

            self.messageCode.alpha = 0;
        } completion:^(BOOL finished) {
            _isPhoneRegister = NO;
            self.userInteractionEnabled = YES;
        }];
    }
    self.registeAccount.text = @"";
    self.registePassword.text = @"";
}

- (void)respondsToSendMessageBtn {
    //手机注册
    if (self.registeAccount.text.length < 11) {
        [InfomationTool showAlertMessage:@"手机号长度不正确" dismissTime:0.7 dismiss:nil];
        return;
    }

    NSString *MOBILE = @"^1(3[0-9]|4[0-9]|5[0-35-9]|8[0-9]|7[0-9])\\d{8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //手机号有误
    if (![regextestmobile evaluateWithObject:self.registeAccount.text]) {
        [InfomationTool showAlertMessage:@"输入的手机号码有误" dismissTime:0.5 dismiss:nil];
        return;
    }

    self.sendMessageBtn.userInteractionEnabled = NO;
    self.timerTime = 59;
    [self.sendMessageBtn setTitle:@"60s" forState:(UIControlStateNormal)];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(respondsToRegisterTimer) userInfo:nil repeats:YES];

    [UserModel phoneRegisterCodeWithPhoneNumber:self.registeAccount.text completion:nil];
}

/** 手机注册时验证码等待 timer */
- (void)respondsToRegisterTimer {
    if (self.timerTime > 1) {
        [self.sendMessageBtn setTitle:[NSString stringWithFormat:@"%lds",(long)self.timerTime] forState:(UIControlStateNormal)];
    } else {
        [self.sendMessageBtn setTitle:@"发送验证码" forState:(UIControlStateNormal)];
        [self.timer invalidate];
        self.timer = nil;
        self.sendMessageBtn.userInteractionEnabled = YES;
    }
    self.timerTime--;
}

- (void)respondsToRegisterBtn {
    if (_isPhoneRegister) {
        if (self.registDelegate && [self.registDelegate respondsToSelector:@selector(SYregistViewRegistWithPhoneNunber:Passsword:Code:)]) {
            [self.registDelegate SYregistViewRegistWithPhoneNunber:self.registeAccount.text Passsword:self.registePassword.text Code:self.messageCode.text];
        }
    } else {
        if (self.registDelegate && [self.registDelegate respondsToSelector:@selector(SYregistViewRegistWithUsername:Password:)]) {
            [self.registDelegate SYregistViewRegistWithUsername:self.registeAccount.text Password:self.registePassword.text];
        }
    }
}


#pragma mark - text field delegate
//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (_isPhoneRegister) {
        if (textField == self.registeAccount) {
            if (range.length == 1 && string.length == 0) {
                return YES;
            } else if (self.registeAccount.text.length >= 11) {
                self.registeAccount.text = [textField.text substringToIndex:11];
                return NO;
            }
        } else if (textField == self.registePassword) {
            if (range.length == 1 && string.length == 0) {
                return YES;
            } else if (self.registePassword.text.length >= 16) {
                self.registePassword.text = [textField.text substringToIndex:16];
                return NO;
            }
        } else if(textField == self.messageCode) {
            if (range.length == 1 && string.length == 0) {
                return YES;
            } else if (self.messageCode.text.length >= 6) {
                self.messageCode.text = [textField.text substringToIndex:6];
                return NO;
            }
        }
    } else {
        if (textField == self.registeAccount) {
            if (range.length == 1 && string.length == 0) {
                return YES;
            } else if (self.registeAccount.text.length >= 16) {
                self.registeAccount.text = [textField.text substringToIndex:16];
                return NO;
            }
        } else if (textField == self.registePassword) {
            if (range.length == 1 && string.length == 0) {
                return YES;
            } else if (self.registePassword.text.length >= 16) {
                self.registePassword.text = [textField.text substringToIndex:16];
                return NO;
            }
        }
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.registeAccount) {
        [self.registeAccount canResignFirstResponder];
        [self.registePassword becomeFirstResponder];
    } else if (textField == self.registePassword) {
        [self.registePassword resignFirstResponder];
        [self respondsToRegisterBtn];
    }

    return YES;
}

- (void)resignFirstResponsder {

}


#pragma mark - getter
- (UITextField *)registeAccount {
    if (!_registeAccount) {
        _registeAccount = [[UITextField alloc] init];
//        _registeAccount.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.85, LOGIN_BACK_HEIGHT * 0.15);
//        _registeAccount.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.15);

        _registeAccount.frame = CGRectMake(LOGIN_BACK_WIDTH * 0.05, LOGIN_BACK_HEIGHT * 0.1, LOGIN_BACK_WIDTH * 0.9, LOGIN_BACK_HEIGHT * 0.175);
        
        _registeAccount.placeholder = @":请输入账号";
        _registeAccount.clearButtonMode = UITextFieldViewModeWhileEditing;
        _registeAccount.autocapitalizationType = UITextAutocapitalizationTypeNone;

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LOGIN_BACK_HEIGHT * 0.12, LOGIN_BACK_HEIGHT * 0.12)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:SDK_IMAGE(@"SDK_login_Account")];
        imageView.center = CGPointMake(LOGIN_BACK_HEIGHT * 0.06, LOGIN_BACK_HEIGHT * 0.06);
        [view addSubview:imageView];
        _registeAccount.leftView = view;
        _registeAccount.leftViewMode = UITextFieldViewModeAlways;

        _registeAccount.borderStyle = UITextBorderStyleNone;
        _registeAccount.layer.borderWidth = 1;
        _registeAccount.layer.borderColor = RGBCOLOR(223, 202, 211).CGColor;
        _registeAccount.layer.cornerRadius = 5;
        _registeAccount.layer.masksToBounds = YES;
        _registeAccount.delegate = self;

        _registeAccount.returnKeyType = UIReturnKeyNext;

        [_registeAccount setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    }
    return _registeAccount;
}

/** 注册验证码 */
- (UITextField *)messageCode {
    if (!_messageCode) {

        _messageCode = [[UITextField alloc] init];

//        _messageCode.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.85, LOGIN_BACK_HEIGHT * 0.15);
//        _messageCode.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.325);

        _messageCode.frame = CGRectMake(CGRectGetMinX(self.registeAccount.frame), CGRectGetMaxY(self.registeAccount.frame), self.registeAccount.frame.size.width, self.registeAccount.frame.size.height);

        _messageCode.clearButtonMode = UITextFieldViewModeWhileEditing;
        _messageCode.secureTextEntry = YES;
        _messageCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _messageCode.placeholder = @":验证码";

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LOGIN_BACK_HEIGHT * 0.12, LOGIN_BACK_HEIGHT * 0.12)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:SDK_IMAGE(@"SDK_login_Code")];
        imageView.center = CGPointMake(LOGIN_BACK_HEIGHT * 0.06, LOGIN_BACK_HEIGHT * 0.06);
        [view addSubview:imageView];
        _messageCode.leftView = view;
        _messageCode.leftViewMode = UITextFieldViewModeAlways;

        _messageCode.borderStyle = UITextBorderStyleNone;
        _messageCode.layer.borderWidth = 1;
        _messageCode.layer.borderColor = RGBCOLOR(223, 202, 211).CGColor;
        _messageCode.layer.cornerRadius = 5;
        _messageCode.layer.masksToBounds = YES;
        _messageCode.delegate = self;
        [_messageCode setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];

        _messageCode.rightView = self.sendMessageBtn;
        _messageCode.rightViewMode = UITextFieldViewModeAlways;

        _messageCode.keyboardType = UIKeyboardTypeNumberPad;

        _messageCode.alpha = 0;


    }
    return _messageCode;
}

/** 发送验证码按钮 */
- (UIButton *)sendMessageBtn {
    if (!_sendMessageBtn) {
        _sendMessageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sendMessageBtn.backgroundColor = BUTTON_GREEN_COLOR;

        [_sendMessageBtn setTitle:@"发送验证码" forState:(UIControlStateNormal)];
        [_sendMessageBtn addTarget:self action:@selector(respondsToSendMessageBtn) forControlEvents:(UIControlEventTouchUpInside)];
        _sendMessageBtn.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH * 0.24, self.registeAccount.bounds.size.height);
        _sendMessageBtn.layer.cornerRadius = 2;
        _sendMessageBtn.layer.masksToBounds = YES;

        _sendMessageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _sendMessageBtn;
}



- (UITextField *)registePassword {
    if (!_registePassword) {
        _registePassword = [[UITextField alloc] init];
//        _registePassword.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.85, LOGIN_BACK_HEIGHT * 0.15);
//        _registePassword.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.4);
        _registePassword.frame = CGRectMake(CGRectGetMinX(self.registeAccount.frame), CGRectGetMaxY(self.registeAccount.frame) + 3, self.registeAccount.frame.size.width, self.registeAccount.frame.size.height);

        _registePassword.placeholder = @"请输入密码";
        _registePassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        _registePassword.secureTextEntry = YES;
        _registePassword.autocapitalizationType = UITextAutocapitalizationTypeNone;

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LOGIN_BACK_HEIGHT * 0.12, LOGIN_BACK_HEIGHT * 0.12)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:SDK_IMAGE(@"SDK_login_Password")];
        imageView.center = CGPointMake(LOGIN_BACK_HEIGHT * 0.06, LOGIN_BACK_HEIGHT * 0.06);
        [view addSubview:imageView];
        _registePassword.leftView = view;
        _registePassword.leftViewMode = UITextFieldViewModeAlways;

        _registePassword.borderStyle = UITextBorderStyleNone;
        _registePassword.layer.borderWidth = 1;
        _registePassword.layer.borderColor = RGBCOLOR(223, 202, 211).CGColor;
        _registePassword.layer.cornerRadius = 5;
        _registePassword.layer.masksToBounds = YES;
        _registePassword.delegate = self;
        _registePassword.returnKeyType = UIReturnKeyDone;
        [_registePassword setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    }
    return _registePassword;
}

- (UIButton *)registeButton {
    if (!_registeButton) {
        _registeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];

//        _registeButton.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH * 0.35 , LOGIN_BACK_HEIGHT * 0.12);
//        _registeButton.center = CGPointMake(FLOAT_MENU_WIDTH / 4, FLOAT_MENU_HEIGHT * 0.55);


        _registeButton.frame = CGRectMake(CGRectGetMinX(self.registeAccount.frame), 0, LOGIN_BACK_WIDTH * 0.45  - 13, FLOAT_MENU_HEIGHT * 0.12);
        _registeButton.center = CGPointMake(_registeButton.center.x, CGRectGetMidY(self.phoneRegisterShimmeringView.frame));
        
        [_registeButton setTitle:@"注册" forState:(UIControlStateNormal)];

        _registeButton.layer.cornerRadius = 8;
        _registeButton.layer.masksToBounds = YES;

        [_registeButton setBackgroundColor:BUTTON_GREEN_COLOR];
        [_registeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateHighlighted)];

        [_registeButton addTarget:self action:@selector(respondsToRegisterBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _registeButton;
}

/** 手机账号注册 */
- (UIButton *) phoneRegister {
    if (!_phoneRegister) {
        _phoneRegister = [UIButton buttonWithType:(UIButtonTypeCustom)];

        _phoneRegister.frame = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.4, FLOAT_MENU_WIDTH * 0.1);
        [_phoneRegister setTitle:@">>手机账号注册" forState:(UIControlStateNormal)];
        [_phoneRegister addTarget:self action:@selector(clickPhoneRegister:) forControlEvents:(UIControlEventTouchUpInside)];
        _phoneRegister.titleLabel.font = [UIFont systemFontOfSize:15];
        [_phoneRegister setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

    }
    return _phoneRegister;
}

- (FBShimmeringView *)phoneRegisterShimmeringView {
    if (!_phoneRegisterShimmeringView) {
        _phoneRegisterShimmeringView = [[FBShimmeringView alloc] init];

        _phoneRegisterShimmeringView.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.4 , LOGIN_BACK_HEIGHT * 0.1);
        _phoneRegisterShimmeringView.center = CGPointMake(FLOAT_MENU_WIDTH / 4 * 3, FLOAT_MENU_HEIGHT * 0.55);

        _phoneRegisterShimmeringView.contentView = self.phoneRegister;

        _phoneRegisterShimmeringView.shimmering = YES;
        _phoneRegisterShimmeringView.shimmeringOpacity = 0.5;
        _phoneRegisterShimmeringView.shimmeringBeginFadeDuration = 1.f;
        _phoneRegisterShimmeringView.shimmeringSpeed = 80;
        _phoneRegisterShimmeringView.shimmeringAnimationOpacity = 1.0;

        _phoneRegisterShimmeringView.shimmering = YES;
    }
    return _phoneRegisterShimmeringView;
}


@end












