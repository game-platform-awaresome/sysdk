//
//  SY_LoginView.m
//  SDK185SY
//
//  Created by 石燚 on 2017/7/12.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SY_LoginView.h"
#import "FBShimmeringView.h"

#define LOGIN_BACK_WIDTH FLOAT_MENU_WIDTH
#define LOGIN_BACK_HEIGHT LOGIN_BACK_WIDTH * 0.8

@interface SY_LoginView ()<UITextFieldDelegate>

/** 是否是手机登录 */
@property (nonatomic, assign) BOOL isPhoneLogin;


/** 自动登录 */
@property (nonatomic, strong) UIButton *autoLogin;
/** 忘记密码 */
@property (nonatomic, strong) UIButton *forgetPassWordBtn;
/** 登录按钮 */
@property (nonatomic, strong) UIButton *loginButton;
/** 立即注册 */
@property (nonatomic, strong) UIButton *gotoRegisterBtn;
/** 手机账号登录 */
@property (nonatomic, strong) UIButton *phoneLogin;


/** 手机登录闪光 */
@property (nonatomic, strong) FBShimmeringView *phoneLoginshimmeringView;

@end

@implementation SY_LoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self inputResignFirstResponder];
}

- (void)inputResignFirstResponder {
    [self.account resignFirstResponder];
    [self.password resignFirstResponder];
}

- (void)initUserInterface {
    self.frame = CGRectMake(0, 0, LOGIN_BACK_WIDTH, LOGIN_BACK_HEIGHT);
    
    self.backgroundColor = LOGIN_BACKGROUNDCOLOR;
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.account];
    [self addSubview:self.password];
    [self addSubview:self.autoLogin];
    [self addSubview:self.forgetPassWordBtn];
    [self addSubview:self.loginButton];
    [self addSubview:self.phoneLoginshimmeringView];

    _isPhoneLogin = NO;
}

#pragma mark - responds
/** 登录按钮响应 */
- (void)respondsToLoginBtn {
    
    if (_isPhoneLogin) {
        
        if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(SYloginViewLoginWithPhoneNunber:Passsword:)]) {
            
            [self.loginDelegate SYloginViewLoginWithPhoneNunber:self.account.text Passsword:self.password.text];
            
        }
        
    } else {
        
        if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(SYloginViewLoginWithUsername:Password:)]) {
            
            [[self loginDelegate] SYloginViewLoginWithUsername:self.account.text Password:self.password.text];
            
        }
        
    }
    
}

/** 忘记密码响应 */
- (void)respondsToForgetPasswordBtn {
    
    if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(SYloginViewClickForgetPasswordButton)]) {
        
        [self.loginDelegate SYloginViewClickForgetPasswordButton];
        
    }
    
}

/** 自动登录 */
- (void)respondsToAutoLogin:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
        SDK_SETAUTOLOGIN(@"0");
    } else {
        sender.selected = YES;
        SDK_SETAUTOLOGIN(@"1");
    }
}


#pragma mark - view method
/** 切换手机登录和账号登录 */
- (void)clickPhoneLogin:(UIButton *)sender {
    self.userInteractionEnabled = NO;
    _isPhoneLogin = !_isPhoneLogin;

    [self.account resignFirstResponder];
    [self.password resignFirstResponder];

    if (_isPhoneLogin) {
        [sender setTitle:@">>用户账号登录" forState:(UIControlStateNormal)];
        self.account.placeholder = @"请输入手机号";
        self.account.keyboardType = UIKeyboardTypePhonePad;
    } else {
        [sender setTitle:@">>手机账号登录" forState:(UIControlStateNormal)];
        self.account.placeholder = @"请输入账号";
        self.account.keyboardType = UIKeyboardTypeDefault;
    }

    self.userInteractionEnabled = YES;
    self.account.text = @"";
    self.password.text = @"";
}

- (void)showPhoneLogin:(BOOL)show {

    self.userInteractionEnabled = NO;
    [self.account resignFirstResponder];
    [self.password resignFirstResponder];
    if (show) {
        _isPhoneLogin = YES;
        [self.phoneLogin setTitle:@">>用户账号登录" forState:(UIControlStateNormal)];
        self.account.placeholder = @"请输入手机号";
        self.account.keyboardType = UIKeyboardTypePhonePad;
    } else {
        _isPhoneLogin = NO;
        [self.phoneLogin setTitle:@">>手机账号登录" forState:(UIControlStateNormal)];
        self.account.placeholder = @"请输入账号";
        self.account.keyboardType = UIKeyboardTypeDefault;
    }

    self.userInteractionEnabled = YES;
    self.account.text = @"";
    self.password.text = @"";
}


#pragma mark - text filed delegate
//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (_isPhoneLogin) {
        if (textField == self.account) {
            if (range.length == 1 && string.length == 0) {
                return YES;
            } else if (self.account.text.length >= 11) {
                self.account.text = [textField.text substringToIndex:11];
                return NO;
            }
        } else if (textField == self.password) {
            if (range.length == 1 && string.length == 0) {
                return YES;
            } else if (self.password.text.length >= 16) {
                self.password.text = [textField.text substringToIndex:16];
                return NO;
            }
        }
    } else {
        if (textField == self.account) {
            if (range.length == 1 && string.length == 0) {
                return YES;
            } else if (self.account.text.length >= 16) {
                self.account.text = [textField.text substringToIndex:16];
                return NO;
            }
        } else if (textField == self.password) {
            if (range.length == 1 && string.length == 0) {
                return YES;
            } else if (self.password.text.length >= 16) {
                self.password.text = [textField.text substringToIndex:16];
                return NO;
            }
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.account) {
        [self.account canResignFirstResponder];
        [self.password becomeFirstResponder];
    } else if (textField == self.password) {
        [self.password resignFirstResponder];
        [self respondsToLoginBtn];
    }
    return YES;
}

#pragma mark - getter
/** 账号 */
- (UITextField *)account {
    if (!_account) {
        _account = [[UITextField alloc] init];
//        _account.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.85, LOGIN_BACK_HEIGHT * 0.15);
//        _account.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.15);

        _account.frame = CGRectMake(LOGIN_BACK_WIDTH * 0.05, LOGIN_BACK_HEIGHT * 0.1, LOGIN_BACK_WIDTH * 0.9, LOGIN_BACK_HEIGHT * 0.175);
        _account.placeholder = @":请输入账号";
        _account.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _account.returnKeyType = UIReturnKeyNext;
        _account.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        _account.borderStyle = UITextBorderStyleNone;
        _account.layer.borderWidth = 1;
        _account.layer.borderColor = RGBCOLOR(223, 202, 211).CGColor;
        _account.layer.cornerRadius = 5;
        _account.layer.masksToBounds = YES;

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LOGIN_BACK_HEIGHT * 0.12, LOGIN_BACK_HEIGHT * 0.12)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:SDK_IMAGE(@"SDK_login_Account")];
        imageView.center = CGPointMake(LOGIN_BACK_HEIGHT * 0.06, LOGIN_BACK_HEIGHT * 0.06);
        [view addSubview:imageView];
        _account.leftView = view;
        _account.leftViewMode = UITextFieldViewModeAlways;
        
        _account.delegate = self;
        
        [_account setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
        
    }
    return _account;
}

/** 密码 */
- (UITextField *)password {
    if (!_password) {
        _password = [[UITextField alloc] init];
//        _password.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.85, LOGIN_BACK_HEIGHT * 0.15);
//        _password.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.35);

        _password.frame = CGRectMake(CGRectGetMinX(self.account.frame), CGRectGetMaxY(self.account.frame) + 3, self.account.frame.size.width, self.account.frame.size.height);
        _password.placeholder = @":请输入密码";
        _password.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _password.secureTextEntry = YES;

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LOGIN_BACK_HEIGHT * 0.12, LOGIN_BACK_HEIGHT * 0.12)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:SDK_IMAGE(@"SDK_login_Password")];
        imageView.center = CGPointMake(LOGIN_BACK_HEIGHT * 0.06, LOGIN_BACK_HEIGHT * 0.06);
        [view addSubview:imageView];
        _password.leftView = view;
        _password.leftViewMode = UITextFieldViewModeAlways;
        
        _password.borderStyle = UITextBorderStyleNone;
        _password.layer.borderWidth = 1;
        _password.layer.borderColor = RGBCOLOR(223, 202, 211).CGColor;
        _password.layer.cornerRadius = 5;
        _password.layer.masksToBounds = YES;
        _password.delegate = self;
        _password.returnKeyType = UIReturnKeyJoin;
        [_password setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
        
    }
    return _password;
}

/** 自动登录 */
- (UIButton *)autoLogin {
    if (!_autoLogin) {
        _autoLogin = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _autoLogin.frame = CGRectMake(CGRectGetMinX(self.password.frame), CGRectGetMaxY(self.password.frame) + 15, FLOAT_MENU_WIDTH * 0.4, 20);

        [_autoLogin setImage:SDK_IMAGE(@"SDK_AutoLogin_YES") forState:(UIControlStateSelected)];
        [_autoLogin setImage:SDK_IMAGE(@"SDK_AutoLogin_NO") forState:(UIControlStateNormal)];

        [_autoLogin setTitle:@"自动登录" forState:(UIControlStateNormal)];

        [_autoLogin setTitleColor:TEXTCOLOR forState:(UIControlStateNormal)];
        _autoLogin.titleLabel.font = [UIFont systemFontOfSize:14];

        [_autoLogin addTarget:self action:@selector(respondsToAutoLogin:) forControlEvents:(UIControlEventTouchUpInside)];
        [_autoLogin sizeToFit];

        NSString *autoLogin = SDK_ISAUTOLOGIN;
        if (autoLogin && autoLogin.integerValue != 0) {
            _autoLogin.selected = YES;
        } else {
            _autoLogin.selected = NO;
        }
    }
    return _autoLogin;
}

/** 忘记密码 */
- (UIButton *)forgetPassWordBtn {
    if (!_forgetPassWordBtn) {
        _forgetPassWordBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _forgetPassWordBtn.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH * 0.255, 20);
        [_forgetPassWordBtn setTitle:@"忘记密码" forState:(UIControlStateNormal)];
        [_forgetPassWordBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        _forgetPassWordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _forgetPassWordBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_forgetPassWordBtn sizeToFit];

        [_forgetPassWordBtn addTarget:self action:@selector(respondsToForgetPasswordBtn) forControlEvents:(UIControlEventTouchUpInside)];
        _forgetPassWordBtn.frame = CGRectMake(CGRectGetMaxX(self.password.frame) - _forgetPassWordBtn.bounds.size.width, CGRectGetMaxY(self.password.frame) + 15, _forgetPassWordBtn.bounds.size.width, _forgetPassWordBtn.bounds.size.height);
        _forgetPassWordBtn.center = CGPointMake(_forgetPassWordBtn.center.x, self.autoLogin.center.y);

    }
    return _forgetPassWordBtn;
}

/** 登录按钮 */
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        _loginButton.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH * 0.35 , LOGIN_BACK_HEIGHT * 0.12);
//        _loginButton.center = CGPointMake(FLOAT_MENU_WIDTH / 4, FLOAT_MENU_HEIGHT * 0.55);

        if (kSCREEN_WIDTH == 568) {
            _loginButton.frame = CGRectMake(CGRectGetMinX(self.account.frame), CGRectGetMaxY(self.autoLogin.frame) + 15, LOGIN_BACK_WIDTH * 0.45  - 13, FLOAT_MENU_HEIGHT * 0.10);
        } else {
            _loginButton.frame = CGRectMake(CGRectGetMinX(self.account.frame), CGRectGetMaxY(self.autoLogin.frame) + 15, LOGIN_BACK_WIDTH * 0.45  - 13, FLOAT_MENU_HEIGHT * 0.12);
        }

        [_loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
        
        _loginButton.layer.cornerRadius = LOGIN_BACK_WIDTH / 50;
        _loginButton.layer.masksToBounds = YES;
        
        [_loginButton setBackgroundColor:BUTTON_GREEN_COLOR];
        [_loginButton setTitleColor:[UIColor blackColor] forState:(UIControlStateHighlighted)];
        
        [_loginButton addTarget:self action:@selector(respondsToLoginBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _loginButton;
}


/** 手机账号登录 */
- (UIButton *)phoneLogin {
    if (!_phoneLogin) {
        _phoneLogin = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        _phoneLogin.frame = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.4, FLOAT_MENU_WIDTH * 0.1);
        [_phoneLogin setTitle:@">>手机账号登录" forState:(UIControlStateNormal)];
        [_phoneLogin addTarget:self action:@selector(clickPhoneLogin:) forControlEvents:(UIControlEventTouchUpInside)];
        _phoneLogin.titleLabel.font = [UIFont systemFontOfSize:15];
        [_phoneLogin setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
    }
    return _phoneLogin;
}


- (FBShimmeringView *)phoneLoginshimmeringView {
    if (!_phoneLoginshimmeringView) {
        _phoneLoginshimmeringView = [[FBShimmeringView alloc] init];
        _phoneLoginshimmeringView.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.45 - 13, LOGIN_BACK_HEIGHT * 0.1);
//        _phoneLoginshimmeringView.center = CGPointMake(FLOAT_MENU_WIDTH / 4 * 3, FLOAT_MENU_HEIGHT * 0.55);
//
//        _phoneLoginshimmeringView.center = CGPointMake(_phoneLoginshimmeringView.center.x, self.loginButton.center.y);


        _phoneLoginshimmeringView.center = CGPointMake(LOGIN_BACK_WIDTH * 0.95 - _phoneLoginshimmeringView.bounds.size.width / 2, self.loginButton.center.y);
        
        _phoneLoginshimmeringView.contentView = self.phoneLogin;
        
        _phoneLoginshimmeringView.shimmering = YES;
        _phoneLoginshimmeringView.shimmeringOpacity = 0.5;
        _phoneLoginshimmeringView.shimmeringBeginFadeDuration = 1.f;
        _phoneLoginshimmeringView.shimmeringSpeed = 80;
        _phoneLoginshimmeringView.shimmeringAnimationOpacity = 1.0;
        
        _phoneLoginshimmeringView.shimmering = YES;
    }
    return _phoneLoginshimmeringView;
}



@end
