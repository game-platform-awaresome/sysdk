//
//  SY_BindingPhoneView.m
//  BTWan
//
//  Created by 石燚 on 2017/7/24.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SY_BindingPhoneView.h"
#import "UserModel.h"
#import "LoginController.h"

#define InformationTool InfomationTool

/** 绑定手机页面的的状态 */
typedef enum : NSUInteger {
    BPimportPhoneNumber,
    BPimportMessageCode,
    BPimportComplete,
    BPUnBindPhoneNumberImportMessage
} SYBPNextType;

@interface SY_BindingPhoneView ()<UITextFieldDelegate>

/** 绑定手机背景视图 */
@property (nonatomic, strong) UIView *bindPhoneBackView;

//绑定手机详细子视图
@property (nonatomic, strong) UIView *bindPhoneNumberView;
/** 是否绑定手机 */
@property (nonatomic, assign) BOOL isBindPhoneNumber;
/** 提示标签 */
@property (nonatomic, strong) UILabel *BPRemindLabel;
/** 输入视图 */
@property (nonatomic, strong) UIView *BPImportView;
/** line */
@property (nonatomic, strong) CALayer *BPLine;
/** 输入提示(发送短信) */
@property (nonatomic, strong) UIButton *BPImportButton;
/** 输入框 */
@property (nonatomic, strong) UITextField *BPImportTextField;
/** 下一步按钮 */
@property (nonatomic, strong) UIButton *BPNextButton;
/** 下一步按钮状态 */
@property (nonatomic, assign) SYBPNextType bpNextType;
/** 绑定手机提示 */
@property (nonatomic, strong) UILabel *BPCompleteLabel;
/** 定时器 */
@property (nonatomic, strong) NSTimer *BPtimer;
/** 冷却时间 */
@property (nonatomic, assign) NSInteger  BPTimerCD;
/** 当前手机号码 */
@property (nonatomic, strong) NSString *BPCurrentPhoneNumber;

/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancleButton;
/** 关闭按钮 */
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation SY_BindingPhoneView

- (instancetype)init
{
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


//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.BPImportTextField) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.BPImportTextField.text.length >= 11) {
            self.BPImportTextField.text = [textField.text substringToIndex:11];
            return NO;
        }
    }

    return YES;
}

#pragma mark - responds
- (void)respondsToCancleButton {
    [self removeFromSuperview];
    self.bpNextType = BPimportPhoneNumber;
    if (self.delegate && [self.delegate respondsToSelector:@selector(bindingPhoneViewClosed)]) {
        [self.delegate bindingPhoneViewClosed];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
}


/** 绑定手机号码 */
- (void)respondsToBPNextButton {
    switch (_bpNextType) {
        case BPimportPhoneNumber: {

            //判断手机号码
            NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
            NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];

            if (![regextestmobile evaluateWithObject:self.BPImportTextField.text]) {;
                [InfomationTool showAlertMessage:@"输入的手机号有误" dismissTime:0.7 dismiss:nil];
                break;
            }

            _BPCurrentPhoneNumber = self.BPImportTextField.text;

            //发送验证码
            [self BPResendMessage];

            break;
        }
        case BPimportMessageCode: {
            //验证验证码输入
            NSString *MOBILE = @"^[0-9]{6}$";
            NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];

            if (![regextestmobile evaluateWithObject:self.BPImportTextField.text]) {;
                [InfomationTool showAlertMessage:@"请输入6位数字验证码" dismissTime:0.7 dismiss:nil];
                break;
            }

            /** 验证绑定短息 - 绑定手机 */
            SDK_START_ANIMATION;
            [UserModel bindingAccountWithPhoneNumber:_BPCurrentPhoneNumber Code:self.BPImportTextField.text completion:^(NSDictionary *content, BOOL success) {
                SDK_STOP_ANIMATION;

                NSString *state = content[@"status"];
                if (success && state.integerValue == 1) {
                    [UserModel currentUser].mobile = _BPCurrentPhoneNumber;
                    [self.BPtimer invalidate];
                    self.BPtimer = nil;
                    [InfomationTool showAlertMessage:@"绑定成功" dismissTime:0.7 dismiss:nil];
                    [self respondsToCancleButton];
                    _bpNextType = -1;
                } else {
                    if (content) {
                        [InfomationTool showAlertMessage:content[@"msg"] dismissTime:0.7 dismiss:nil];
                    } else {
                        [InfomationTool showAlertMessage:@"网络不不见了!" dismissTime:0.7 dismiss:nil];
                    }
                }

            }];


            break;
        }
        case BPimportComplete: {


            break;
        }
        case BPUnBindPhoneNumberImportMessage: {


            break;
        }

        default: {

            self.BPRemindLabel.text = @"目前仅支持中国大陆手机";
            self.BPImportTextField.text = @"";
            self.BPLine.frame = CGRectMake(44, 0, 1, 44);
            self.BPImportButton.frame = CGRectMake(0, 0, 44, 44);
            [self.BPImportButton setTitle:@"+86" forState:(UIControlStateNormal)];
            self.BPImportTextField.frame = CGRectMake(50, 0, FLOAT_MENU_WIDTH - 100, 44);

            break;
        }
    }
}

- (void)BPResendMessage {
    SDK_START_ANIMATION;
    [UserModel phoneBindingCodeWithPhoneNumber:_BPCurrentPhoneNumber completion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;
        NSString *state = content[@"status"];
        if (success) {
            if (state.integerValue == 1) {
                self.BPtimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(BPsendMessageCodeCD) userInfo:nil repeats:YES];

                _BPTimerCD = 59;
                [self.BPImportButton setTitle:[NSString stringWithFormat:@"%lds",(long)_BPTimerCD] forState:(UIControlStateNormal)];
                self.BPImportButton.userInteractionEnabled = NO;

                [UIView animateWithDuration:0.3 animations:^{

                    self.BPRemindLabel.text = [NSString stringWithFormat:@"已经发送验证码到 : %@",_BPCurrentPhoneNumber];
                    self.BPImportTextField.text = @"";
                    self.BPImportButton.frame = CGRectMake(self.BPImportView.bounds.size.width - 100, 0, 100, 44);
                    self.BPLine.frame = CGRectMake(self.BPImportView.bounds.size.width - 100, 0, 1, 44);
                    self.BPImportTextField.frame = CGRectMake(5, 0, self.BPImportView.bounds.size.width - 105, 44);


                } completion:^(BOOL finished) {
                    _bpNextType = BPimportMessageCode;
                }];
            } else {
                SDK_MESSAGE(content[@"msg"]);
            }

        } else {
            [InfomationTool showAlertMessage:@"网络不见了!" dismissTime:0.7 dismiss:nil];
        }
    }];
}

- (void)BPsendMessageCodeCD {
    if (_BPTimerCD > 0) {
        [self.BPImportButton setTitle:[NSString stringWithFormat:@"%lds",(long)_BPTimerCD] forState:(UIControlStateNormal)];
    } else {
        [self.BPImportButton setTitle:@"重新发送" forState:(UIControlStateNormal)];
        [self.BPtimer invalidate];
        self.BPtimer = nil;
        self.BPImportButton.userInteractionEnabled = YES;
    }
    _BPTimerCD--;
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
        titleLabel.text = @"绑定手机";
        titleLabel.textColor = BUTTON_GREEN_COLOR;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:22];
        [_bindPhoneBackView addSubview:titleLabel];


        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, FLOAT_MENU_HEIGHT / 7 + 1, FLOAT_MENU_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
        [_bindPhoneBackView addSubview:line];

        [_bindPhoneBackView addSubview:self.BPRemindLabel];
        [_bindPhoneBackView addSubview:self.BPImportView];
        [_bindPhoneBackView addSubview:self.BPNextButton];
        [_bindPhoneBackView addSubview:self.cancleButton];
        [_bindPhoneBackView addSubview:self.closeButton];
    }
    return _bindPhoneBackView;
}

/** 提示标签 */
- (UILabel *)BPRemindLabel {
    if (!_BPRemindLabel) {
        _BPRemindLabel = [[UILabel alloc] init];
        _BPRemindLabel.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH - 30, FLOAT_MENU_HEIGHT / 8);
        _BPRemindLabel.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT / 4);
        _BPRemindLabel.text = @"目前仅支持中国大陆手机";
        _BPRemindLabel.font = [UIFont systemFontOfSize:21];

        syLog(@" ======= %lf",(FLOAT_MENU_HEIGHT / 8));
        syLog(@"screen ---- width %lf",kSCREEN_WIDTH);

        _BPRemindLabel.textColor = TEXTCOLOR;
    }
    return _BPRemindLabel;
}

//输入背景
- (UIView *)BPImportView {
    if (!_BPImportView) {
        _BPImportView = [[UIView alloc] init];
        _BPImportView.frame = CGRectMake(CGRectGetMinX(self.BPRemindLabel.frame), CGRectGetMaxY(self.BPRemindLabel.frame) + FLOAT_MENU_HEIGHT / 16, CGRectGetWidth(self.BPRemindLabel.frame), FLOAT_MENU_HEIGHT / 8);

        _BPImportView.layer.borderColor = [UIColor grayColor].CGColor;
        _BPImportView.layer.borderWidth = 1.f;
        _BPImportView.layer.cornerRadius = 8;
        _BPImportView.layer.masksToBounds = YES;

        [_BPImportView addSubview:self.BPImportButton];
        [_BPImportView addSubview:self.BPImportTextField];
        [_BPImportView.layer addSublayer:self.BPLine];

    }
    return _BPImportView;
}

- (CALayer *)BPLine {
    if (!_BPLine) {
        _BPLine = [CALayer layer];
        _BPLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        _BPLine.frame = CGRectMake(44,0, 1, 44);
    }
    return _BPLine;
}

- (UIView *)BPImportButton {
    if (!_BPImportButton) {
        _BPImportButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _BPImportButton.frame = CGRectMake(0, 0, 44, FLOAT_MENU_HEIGHT / 8);
        [_BPImportButton setTitle:@"+86" forState:(UIControlStateNormal)];

        [_BPImportButton setTitleColor:TEXTCOLOR forState:(UIControlStateNormal)];
        _BPImportButton.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];

        [_BPImportButton addTarget:self action:@selector(BPResendMessage) forControlEvents:(UIControlEventTouchUpInside)];
        _BPImportButton.userInteractionEnabled = NO;
    }
    return _BPImportButton;
}

/** 输入框 */
- (UITextField *)BPImportTextField {
    if (!_BPImportTextField) {
        _BPImportTextField = [[UITextField alloc] init];
        _BPImportTextField.frame = CGRectMake(50, 0, FLOAT_MENU_WIDTH - 100, FLOAT_MENU_HEIGHT / 8);
        _BPImportTextField.returnKeyType = UIReturnKeyNext;
        _BPImportTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _BPImportTextField.delegate = self;
    }
    return _BPImportTextField;
}

/** 下一步按钮 */
- (UIButton *)BPNextButton {
    if (!_BPNextButton) {
        _BPNextButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _BPNextButton.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH - 30, FLOAT_MENU_HEIGHT / 8);
        _BPNextButton.center = CGPointMake(FLOAT_MENU_WIDTH / 2, CGRectGetMaxY(self.BPImportView.frame) + FLOAT_MENU_HEIGHT / 7);
        _BPNextButton.backgroundColor = BUTTON_GREEN_COLOR;
        _BPNextButton.layer.cornerRadius = 8;
        _BPNextButton.layer.masksToBounds = YES;
        [_BPNextButton setTitle:@"下一步" forState:(UIControlStateNormal)];
        [_BPNextButton addTarget:self action:@selector(respondsToBPNextButton) forControlEvents:(UIControlEventTouchUpInside)];

        [_BPNextButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_BPNextButton setTitleColor:[UIColor grayColor] forState:(UIControlStateHighlighted)];
    }
    return _BPNextButton;
}

- (UILabel *)BPCompleteLabel {
    if (!_BPCompleteLabel) {
        _BPCompleteLabel = [[UILabel alloc] init];
        _BPCompleteLabel.frame = self.BPRemindLabel.frame;
        _BPCompleteLabel.text = @"您已绑定手机 : 124***1232";
        _BPCompleteLabel.font = [UIFont systemFontOfSize:20];
        _BPCompleteLabel.textAlignment = NSTextAlignmentCenter;
        _BPCompleteLabel.textColor = [UIColor lightGrayColor];
    }
    return _BPCompleteLabel;
}

- (UIButton *)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _cancleButton.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT / 8);
        _cancleButton.center = CGPointMake(FLOAT_MENU_WIDTH / 4, CGRectGetMaxY(self.BPNextButton.frame) + FLOAT_MENU_HEIGHT / 8);
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




@end
