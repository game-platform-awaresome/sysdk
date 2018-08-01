//
//  SY_BindingIDCardView.m
//  SY_185SDK
//
//  Created by 燚 on 2017/11/29.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SY_BindingIDCardView.h"
#import "LoginController.h"
#import "UserModel.h"

@interface SY_BindingIDCardView ()<UITextFieldDelegate>

/** 绑定手机背景视图 */
@property (nonatomic, strong) UIView *bindPhoneBackView;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancleButton;
/** 关闭按钮 */
@property (nonatomic, strong) UIButton *closeButton;

/** 提示标签 */
@property (nonatomic, strong) UILabel *NARemindLabel;
/** 真实姓名 */
@property (nonatomic, strong) UITextField *NANameTextField;
/** 身份证号码 */
@property (nonatomic, strong) UITextField *NAIDCardNumberTextField;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *NASureButton;


@end

@implementation SY_BindingIDCardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self.backgroundColor = [UIColor clearColor];

    [self addSubview:self.bindPhoneBackView];
}

#pragma mark - responds
- (void)respondsToCancleButton {
    [self removeFromSuperview];
    [LoginController hideLoginView];
}

/** 确认按钮响应 */
- (void)respondsToNASureButton {

    //验证姓名
    NSString *username = @"[\u4e00-\u9fa5]{2,10}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", username];
    if (![regextestmobile evaluateWithObject:self.NANameTextField.text]) {
        SDK_MESSAGE(@"请输入2位以上的中文姓名");
        return;
    }

    //验证身份证号码
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    if (![pred evaluateWithObject:self.NAIDCardNumberTextField.text]) {
        SDK_MESSAGE(@"请输入15位或18位证件号码");
        return;
    }

    [UserModel IDCardVerifiedWithIDNumber:self.NAIDCardNumberTextField.text IDName:self.NANameTextField.text completion:^(NSDictionary *content, BOOL success) {
        syLog(@"实名认证");
        if (success) {
            NSString *status = content[@"status"];
            if (status.integerValue == 1) {
                SDK_MESSAGE(@"实名认证成功");
                [self.NARemindLabel removeFromSuperview];
                [self.NANameTextField removeFromSuperview];
                [self.NAIDCardNumberTextField removeFromSuperview];
                [self.NASureButton removeFromSuperview];
                [UserModel currentUser].id_name = self.NANameTextField.text;
                [UserModel currentUser].id_card = self.NAIDCardNumberTextField.text;

                [self respondsToCancleButton];
            } else {
                SDK_MESSAGE(content[@"msg"]);
            }
        } else {
            SDK_MESSAGE(@"网络故障\n请稍后再试");
        }

    }];
}

#pragma mark - getter
/** 背景视图 */
- (UIView *)bindPhoneBackView {
    if (!_bindPhoneBackView) {
        _bindPhoneBackView = [[UIView alloc] init];
        _bindPhoneBackView.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT);
        _bindPhoneBackView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
        _bindPhoneBackView.backgroundColor = LOGIN_BACKGROUNDCOLOR;

        _bindPhoneBackView.layer.cornerRadius = 8;
        _bindPhoneBackView.layer.borderColor = [UIColor grayColor].CGColor;
        _bindPhoneBackView.layer.borderWidth = 1.f;
        _bindPhoneBackView.layer.masksToBounds = YES;

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT / 7);
        titleLabel.text = @"绑定身份证";
        titleLabel.textColor = BUTTON_GREEN_COLOR;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:22];
        [_bindPhoneBackView addSubview:titleLabel];


        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, FLOAT_MENU_HEIGHT / 7 + 1, FLOAT_MENU_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
        [_bindPhoneBackView addSubview:line];

        [_bindPhoneBackView addSubview:self.NARemindLabel];
        [_bindPhoneBackView addSubview:self.NANameTextField];
        [_bindPhoneBackView addSubview:self.NAIDCardNumberTextField];
        [_bindPhoneBackView addSubview:self.NASureButton];
//        [_bindPhoneBackView addSubview:self.cancleButton];
        [_bindPhoneBackView addSubview:self.closeButton];
    }
    return _bindPhoneBackView;
}

- (UIButton *)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _cancleButton.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT / 8);
        _cancleButton.center = CGPointMake(FLOAT_MENU_WIDTH / 4,  FLOAT_MENU_HEIGHT / 8 * 7);
        [_cancleButton setTitle:@"<<<<下次再说" forState:(UIControlStateNormal)];
        [_cancleButton addTarget:self action:@selector(respondsToCancleButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_cancleButton setTitleColor:TEXTCOLOR forState:(UIControlStateNormal)];
    }
    return _cancleButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _closeButton.frame = CGRectMake(FLOAT_MENU_WIDTH - 40, 10, 30, 30);
        [_closeButton setImage:SDK_IMAGE(@"SYSDK_closeButton") forState:(UIControlStateNormal)];
        [_closeButton addTarget:self action:@selector(respondsToCancleButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}


#pragma mark ========================= 实名认证 ==========================================
- (UILabel *)NARemindLabel {
    if (!_NARemindLabel) {
        _NARemindLabel = [[UILabel alloc] init];
        _NARemindLabel.frame = CGRectMake(15, FLOAT_MENU_HEIGHT / 10 * 2.5, FLOAT_MENU_WIDTH - 30, 44);
        _NARemindLabel.text = @"实名认证资料是您的重要资料,可确保您的账号安全性,我们会对您的信息做加密处理,认证后,不可更改";
        _NARemindLabel.numberOfLines = 0;
        _NARemindLabel.font = [UIFont systemFontOfSize:14];
        _NARemindLabel.textColor = TEXTCOLOR;
        [_NARemindLabel sizeToFit];
    }
    return _NARemindLabel;
}

- (UITextField *)NANameTextField {
    if (!_NANameTextField) {
        _NANameTextField = [self changePasswordViewcreatTextfieldWithTitle:@"请输入姓名"];
        _NANameTextField.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT / 10 * 4.7);
        _NANameTextField.secureTextEntry = NO;
        _NANameTextField.returnKeyType = UIReturnKeyNext;
    }
    return _NANameTextField;
}

- (UITextField *)NAIDCardNumberTextField {
    if (!_NAIDCardNumberTextField) {
        _NAIDCardNumberTextField = [self changePasswordViewcreatTextfieldWithTitle:@"请输入证件号码"];
        _NAIDCardNumberTextField.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT / 10 * 6.4);
        _NAIDCardNumberTextField.secureTextEntry = NO;
        _NAIDCardNumberTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _NAIDCardNumberTextField.returnKeyType = UIReturnKeyDone;
    }
    return _NAIDCardNumberTextField;
}

- (UIButton *)NASureButton {
    if (!_NASureButton) {
        _NASureButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _NASureButton.bounds = CGRectMake(0, 0,  FLOAT_MENU_WIDTH * 0.85, FLOAT_MENU_HEIGHT / 9);
        _NASureButton.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT / 10 * 8);

        _NASureButton.backgroundColor = BUTTON_GREEN_COLOR;
        [_NASureButton setTitle:@"确定" forState:(UIControlStateNormal)];
        [_NASureButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_NASureButton setTitleColor:[UIColor grayColor] forState:(UIControlStateHighlighted)];

        [_NASureButton addTarget:self action:@selector(respondsToNASureButton) forControlEvents:(UIControlEventTouchUpInside)];

        _NASureButton.layer.cornerRadius = 8;
        _NASureButton.layer.masksToBounds = YES;
    }
    return _NASureButton;
}

- (UITextField *)changePasswordViewcreatTextfieldWithTitle:(NSString *)title {
    UITextField *textfield = [[UITextField alloc] init];
    textfield.bounds = CGRectMake(0, 0,  FLOAT_MENU_WIDTH * 0.85, FLOAT_MENU_HEIGHT / 9);
    textfield.center = CGPointMake(FLOAT_MENU_WIDTH / 2 , FLOAT_MENU_HEIGHT / 10 * 3);

    textfield.placeholder = title;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;

    textfield.returnKeyType = UIReturnKeyNext;
    textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textfield.secureTextEntry = YES;

    textfield.borderStyle = UITextBorderStyleNone;
    textfield.layer.borderWidth = 1;
    textfield.layer.borderColor = RGBCOLOR(223, 202, 211).CGColor;
    textfield.layer.cornerRadius = 5;
    textfield.layer.masksToBounds = YES;
    textfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.delegate = self;

    [textfield setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];

    return textfield;
}


@end

