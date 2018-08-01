//
//  FSettingView.m
//  SDK185SY
//
//  Created by 石燚 on 2017/7/5.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FSettingView.h"

#import "UserModel.h"


/** 点击了哪个选项 */
typedef enum : NSUInteger {
    NoneView = 0,
    BindView,
    PasswordView,
    NameView,
} ShowOptionView;


/** 绑定手机页面的的状态 */
typedef enum : NSUInteger {
    BPimportPhoneNumber,
    BPimportMessageCode,
    BPimportComplete,
    BPUnBindPhoneNumberImportMessage
} BPNextType;

@interface FSettingView ()<UITextFieldDelegate>

/** title */
@property (nonatomic, strong) UILabel *titleLabel;
/** 分割线 */
@property (nonatomic, strong) UIView *line;

/** 自动登录游戏 */
@property (nonatomic, strong) UIView *autoLogin;
@property (nonatomic, strong) UISwitch *autoSwitch;
/** 绑定手机号 */
@property (nonatomic, strong) UIView *bindPhoneNumber;
/** 修改密码 */
@property (nonatomic, strong) UIView *changePassword;
/** 实名认证 */
@property (nonatomic, strong) UIView *autonym;
/** 版本 */
@property (nonatomic, strong) UILabel *versionLabel;

/** 绑定手机详细页面 */
@property (nonatomic, strong) UIView *bindPhoneNumberView;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backButton;
/** 修改密码详细页面 */
@property (nonatomic, strong) UIView *changePasswordView;
/** 实名认证详细页面 */
@property (nonatomic, strong) UIView *autonymView;
/** 当前页面的枚举 */
@property (nonatomic, assign) ShowOptionView showOptionView;


//绑定手机详细子视图
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
@property (nonatomic, assign) BPNextType bpNextType;
/** 绑定手机提示 */
@property (nonatomic, strong) UILabel *BPCompleteLabel;
/** 定时器 */
@property (nonatomic, strong) NSTimer *BPtimer;
/** 冷却时间 */
@property (nonatomic, assign) NSInteger  BPTimerCD;
/** 当前手机号码 */
@property (nonatomic, strong) NSString *BPCurrentPhoneNumber;



//修改密码
/** 原始密码 */
@property (nonatomic, strong) UITextField *CPOldPassword;
/** 新密码 */
@property (nonatomic, strong) UITextField *CPNewPassword;
/** 确认密码 */
@property (nonatomic, strong) UITextField *CPAffirmPassword;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *CPSureButton;


//实名认证 -> 未认证
@property (nonatomic, assign) BOOL isAutonym;
/** 提示标签 */
@property (nonatomic, strong) UILabel *NARemindLabel;
/** 真实姓名 */
@property (nonatomic, strong) UITextField *NANameTextField;
/** 身份证号码 */
@property (nonatomic, strong) UITextField *NAIDCardNumberTextField;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *NASureButton;
//实名认证 -> 已认证
/** 提示标签 */
@property (nonatomic, strong) UILabel *NAAlreadyRemindLabel;
/** 背景视图 */
@property (nonatomic, strong) UIView *NAAlreadyBackView;
/** name */
@property (nonatomic, strong) UILabel *NAAlreadyNameLabel;
/** IDCard */
@property (nonatomic, strong) UILabel *NAAlreadyIDCardLabel;


@end

@implementation FSettingView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.BPImportTextField resignFirstResponder];
    [self.CPOldPassword resignFirstResponder];
    [self.CPNewPassword resignFirstResponder];
    [self.CPAffirmPassword resignFirstResponder];
    
    [self.NANameTextField resignFirstResponder];
    [self.NAIDCardNumberTextField resignFirstResponder];
}


/** 初始化方法 */
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

/** 初始化页面 */
- (void)initUserInterface {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.line];
    [self addSubview:self.autoLogin];
    [self addSubview:self.bindPhoneNumber];
    [self addSubview:self.changePassword];
    [self addSubview:self.autonym];
    [self addSubview:self.versionLabel];
    
    
    //是否开启自动登录
    [self isAutoLogin];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    return YES;
}

//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
        if (textField == self.CPOldPassword) {
            if (range.length == 1 && string.length == 0) {
                return YES;
            } else if (self.CPOldPassword.text.length >= 16) {
                self.CPOldPassword.text = [textField.text substringToIndex:16];
                return NO;
            }
        } else if (textField == self.CPNewPassword) {
            if (range.length == 1 && string.length == 0) {
                return YES;
            } else if (self.CPNewPassword.text.length >= 16) {
                self.CPNewPassword.text = [textField.text substringToIndex:16];
                return NO;
            }
        } else if (textField == self.CPAffirmPassword) {
            if (range.length == 1 && string.length == 0) {
                return YES;
            } else if (self.CPAffirmPassword.text.length >= 16) {
                self.CPAffirmPassword.text = [textField.text substringToIndex:16];
                return NO;
            }
        } else if (textField == self.BPImportTextField) {
            if (range.length == 1 && string.length == 0) {
                return YES;
            } else if (self.BPImportTextField.text.length >= 11) {
                self.BPImportTextField.text = [textField.text substringToIndex:11];
                return NO;
            }
        }
    
    return YES;
}

#pragma mark - switch responds
- (void)isAutoLogin {
    NSString *autoLogin = SDK_ISAUTOLOGIN;
    if (autoLogin && autoLogin.integerValue != 0) {
        self.autoSwitch.on = YES;
    } else {
        self.autoSwitch.on = NO;
    }
}

- (void)respondsToAutoSwitch:(UISwitch *)sender {
    if (sender.isOn) {
        sender.on = NO;
        SDK_SETAUTOLOGIN(@"0");
    } else {
        sender.on = YES;
        SDK_SETAUTOLOGIN(@"1");
    }
}

#pragma mark - detail view responds
- (void)respondsToBindPhoneNumberView {
    _showOptionView = BindView;

    NSString *phoneNumber = [UserModel currentUser].mobile;
    
    if (phoneNumber && phoneNumber.length == 11) {
        self.isBindPhoneNumber = YES;
        _bpNextType = BPimportComplete;
    } else {
        self.isBindPhoneNumber = NO;
    }
    
    //测试页面时选择加载
    if (self.isBindPhoneNumber) {
        [self bingPhoneViewAddChildViewWithBindPhone];
    } else {
        [self bindPhoneViewAddChildViewWithNoPhone];
    }
    
    [self showDetialView:self.bindPhoneNumberView WithOptionView:self.bindPhoneNumber];
}

/** 修改密码页面 */
- (void)respondsToChangePasswordView {
    _showOptionView = PasswordView;
    [self changePasswordViewAddSubView];
    [self showDetialView:self.changePasswordView WithOptionView:self.changePassword];
}

- (void)respondsToAutonymView {
    _showOptionView = NameView;
    _isAutonym = NO;

    NSString *idname = [UserModel currentUser].id_name;
    NSString *idnumber = [UserModel currentUser].id_card;
    if (idname && idnumber && idnumber.length >= 15) {
        _isAutonym = YES;
    } else {
        _isAutonym = NO;
    }
    
    if (_isAutonym) {
        [self autonymAddSubViews];
    } else {
        [self autonymAddSubviewsWithNOautonym];
    }
    [self showDetialView:self.autonymView WithOptionView:self.autonym];
}

- (void)showDetialView:(UIView *)detailView WithOptionView:(UIView *)optionView {
    
    self.userInteractionEnabled = NO;
    ((UIView *)self.nextResponder).userInteractionEnabled = NO;
    [self addSubview:detailView];
    
    detailView.frame = optionView.frame;
    [detailView addSubview:self.backButton];
    
    [UIView animateWithDuration:0.3 animations:^{
        UILabel *title = (UILabel *)[detailView viewWithTag:10086];
        
        title.textColor = self.titleLabel.textColor;
        title.frame = self.titleLabel.frame;
        title.textAlignment = self.titleLabel.textAlignment;
        title.font = self.titleLabel.font;
        
        detailView.frame = self.bounds;
        
        UIView *line = [detailView viewWithTag:10087];
        line.frame = self.line.frame;
        
    } completion:^(BOOL finished) {
        
//        [detailView addSubview:self.backButton];
        ((UIView *)self.nextResponder).userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        
    }];
}

- (void)removeAllChildViews {
    [self.bindPhoneNumberView removeFromSuperview];
    [self.changePasswordView removeFromSuperview];
    [self.autonymView removeFromSuperview];
//    [self.backButton removeFromSuperview];
}


#pragma mark - backbutton responds
- (void)respondsToBackButton:(UIButton *)button {
    
    switch (_showOptionView) {
        case NoneView: {
            
            break;
        }
        case BindView: {
            [self hideDetailView:self.bindPhoneNumberView WithOptionView:self.bindPhoneNumber];
            break;
        }
        case PasswordView: {
            
            [self hideDetailView:self.changePasswordView WithOptionView:self.changePassword];
            break;
        }
        case NameView: {
            [self hideDetailView:self.autonymView WithOptionView:self.autonym];
            break;
        }
            
        default: {
            
            break;
        }
    }
}

- (void)hideDetailView:(UIView *)detailView WithOptionView:(UIView *)optionView {
    
    self.userInteractionEnabled = NO;
    [self.backButton removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        UILabel *dTitle = (UILabel *)[detailView viewWithTag:10086];
        UILabel *title = (UILabel *)[optionView viewWithTag:10086];
        
        dTitle.frame = title.frame;
        dTitle.textColor = title.textColor;
        dTitle.textAlignment = title.textAlignment;
        dTitle.font = title.font;
        
        detailView.frame = optionView.frame;
        UIView *dLine = [detailView viewWithTag:10087];
        UIView *line = [optionView viewWithTag:10087];
        dLine.frame = line.frame;
        
    } completion:^(BOOL finished) {
        
        self.userInteractionEnabled = YES;
        [detailView removeFromSuperview];
        
    }];
    
}

#pragma mark = bindphonenubmer add child view
//绑定手机添加子视图
- (void)bindPhoneViewAddChildViewWithNoPhone {
    _bpNextType = -1;
    [self respondsToBPNextButton];
    
    [self.BPCompleteLabel removeFromSuperview];
    self.BPNextButton.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH - 30, 44);
    [self.BPNextButton setTitle:@"下一步" forState:(UIControlStateNormal)];
    
    [self.bindPhoneNumberView addSubview:self.BPRemindLabel];
    [self.bindPhoneNumberView addSubview:self.BPImportView];
    [self.bindPhoneNumberView addSubview:self.BPNextButton];
    
    
    _bpNextType = BPimportPhoneNumber;
}

//绑定手机号码填写验证码
- (void)bingPhoneViewAddChildViewWithBindPhone {
    NSString *phoneNUmber = [UserModel currentUser].mobile;
    self.BPCompleteLabel.text = [NSString stringWithFormat:@"您已绑定手机 : %@",phoneNUmber];
    [self.BPImportView removeFromSuperview];
    [self.BPRemindLabel removeFromSuperview];
    [self.bindPhoneNumberView addSubview:self.BPCompleteLabel];
    [self.bindPhoneNumberView addSubview:self.BPNextButton];
    [self.BPCompleteLabel sizeToFit];
    self.BPCompleteLabel.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT / 2);
    self.BPNextButton.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH * 0.7, 44);
    [self.BPNextButton setTitle:@"解除绑定" forState:(UIControlStateNormal)];
}


/** 绑定手机号码 */
- (void)respondsToBPNextButton {
    switch (_bpNextType) {
        case BPimportPhoneNumber: {
            
            //判断手机号码
            NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
            NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
            
            if (![regextestmobile evaluateWithObject:self.BPImportTextField.text]) {;
                [self showAlertInFloatViewWithMessage:@"输入的手机号有误" dismissTime:0.6 dismiss:nil];
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
                [self showAlertInFloatViewWithMessage:@"请输入6位数字验证码" dismissTime:0.6 dismiss:nil];
                
                break;
            }
            
            /** 验证绑定短息 - 绑定手机 */
            SDK_START_ANIMATION;
            [UserModel bindingAccountWithPhoneNumber:_BPCurrentPhoneNumber Code:self.BPImportTextField.text completion:^(NSDictionary *content, BOOL success) {
                SDK_STOP_ANIMATION;
                NSString *status = content[@"status"];
                if (success && status.integerValue == 1) {

                    [UserModel currentUser].mobile = [NSString stringWithFormat:@"%@",SDK_CONTENT_DATA[@"mobile"]];
                    [self.BPtimer invalidate];
                    self.BPtimer = nil;
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        [self bingPhoneViewAddChildViewWithBindPhone];
                        
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                    _bpNextType = BPimportComplete;
                } else {
                    if (content) {
                        [InfomationTool showAlertMessage:[RequestTool statuMessage:content[@"state"]] dismissTime:0.7 dismiss:nil];
                    } else {
                        SDK_MESSAGE(@"网络不不见了!");
                    }
                }

            }];
            
            
            break;
        }
        case BPimportComplete: {
            
            NSString *phoneNumber = [UserModel currentUser].mobile;
            if (phoneNumber.length == 11) {
                _BPCurrentPhoneNumber = phoneNumber;
                [self BPResendUnBindMessage];
                
            } else {
                SDK_MESSAGE(@"发生了不可以预知的错误\n请重新登录后再次尝试");
            }
            
            break;
        }
        case BPUnBindPhoneNumberImportMessage: {
            
            if (self.BPImportTextField.text.length != 6) {
                SDK_MESSAGE(@"验证码长度有误");
            } else {
                
                [UserModel unBindingAccountWithPhoneNumber:_BPCurrentPhoneNumber Code:self.BPImportTextField.text completion:^(NSDictionary *content, BOOL success) {
                    NSString *status = content[@"status"];
                    if (success && status.integerValue == 1) {
                        [self showAlertInFloatViewWithMessage:@"解绑成功" dismissTime:0.7 dismiss:nil];
                        [UserModel currentUser].mobile = @"";
                        [self.BPtimer invalidate];
                        self.BPtimer = nil;
                        [self respondsToBackButton:nil];
                    } else {
                        if (content) {
                            [InfomationTool showAlertMessage:[RequestTool statuMessage:content[@"state"]] dismissTime:0.7 dismiss:nil];
                        } else {
                            SDK_MESSAGE(@"解绑失败,请稍后重试");
                        }
                    }
                    
                }];
                
            }
            
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

- (void)BPResendMessage {

    SDK_START_ANIMATION;
    [UserModel phoneBindingCodeWithPhoneNumber:_BPCurrentPhoneNumber completion:^(NSDictionary *content, BOOL success) {

        SDK_STOP_ANIMATION;
        NSString *status = content[@"status"];
        if (success) {
            if (status.integerValue == 1) {
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
            [self showAlertInFloatViewWithMessage:@"网络不见了!" dismissTime:0.7 dismiss:nil];
        }
        
    }];
}


/* 解除绑定手机号码填写验证码 */
- (void)BPResendUnBindMessage {
    [UserModel phoneUnBindingCodeWithPhoneNumber:_BPCurrentPhoneNumber completion:^(NSDictionary *content, BOOL success) {
        
        NSString *status = content[@"status"];
        
        if (success ) {
            
            if (status.integerValue == 1) {
                self.BPtimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(BPsendMessageCodeCD) userInfo:nil repeats:YES];

                _BPTimerCD = 59;
                [self.BPImportButton setTitle:[NSString stringWithFormat:@"%lds",(long)_BPTimerCD] forState:(UIControlStateNormal)];
                self.BPImportButton.userInteractionEnabled = NO;

                [self.bindPhoneNumberView addSubview:self.BPRemindLabel];
                [self.bindPhoneNumberView addSubview:self.BPImportView];

                [self.BPCompleteLabel removeFromSuperview];

                [UIView animateWithDuration:0.3 animations:^{

                    self.BPRemindLabel.text = [NSString stringWithFormat:@"已经发送验证码到 : %@",_BPCurrentPhoneNumber];
                    self.BPImportTextField.text = @"";
                    self.BPImportButton.frame = CGRectMake(self.BPImportView.bounds.size.width - 100, 0, 100, 44);
                    self.BPLine.frame = CGRectMake(self.BPImportView.bounds.size.width - 100, 0, 1, 44);
                    self.BPImportTextField.frame = CGRectMake(5, 0, self.BPImportView.bounds.size.width - 105, 44);


                } completion:^(BOOL finished) {

                }];
                _bpNextType = BPUnBindPhoneNumberImportMessage;
            } else {
                SDK_MESSAGE(content[@"msg"]);
            }

        } else {
            [self showAlertInFloatViewWithMessage:@"网络不见了!" dismissTime:0.6 dismiss:nil];
        }
    }];
}

#pragma mark - chang password view
- (void)changePasswordViewAddSubView {
    self.CPOldPassword.text = @"";
    self.CPNewPassword.text = @"";
    self.CPAffirmPassword.text = @"";
    [self.changePasswordView addSubview:self.CPOldPassword];
    [self.changePasswordView addSubview:self.CPNewPassword];
    [self.changePasswordView addSubview:self.CPAffirmPassword];
    [self.changePasswordView addSubview:self.CPSureButton];
}

/** 确认按钮的响应 */
- (void)respondsToCPSureButton {
//    syLog(@"修改密码");
    
    //判断原密码长度
    if (self.CPOldPassword.text.length < 6) {
        [self showAlertInFloatViewWithMessage:@"旧密码长度不正确" dismissTime:0.6 dismiss:Nil];
        return;
    }
    
    //判断新密码
    if (self.CPNewPassword.text.length < 6) {
        [self showAlertInFloatViewWithMessage:@"新密码长度不正确" dismissTime:0.6 dismiss:nil];
        return;
    }
    
    //判断确认密码长度
    if (self.CPAffirmPassword.text.length < 6) {
        [self showAlertInFloatViewWithMessage:@"确认密码长度不正确" dismissTime:0.6 dismiss:nil];
    }
    
    //判断两次密码是否相等
    if (![self.CPNewPassword.text isEqualToString:self.CPAffirmPassword.text]) {
        [self showAlertInFloatViewWithMessage:@"两次输入的密码不相等" dismissTime:0.6 dismiss:nil];
    }
    
    
    [UserModel changePasswordWithOldPassWord:self.CPOldPassword.text NewPassword:self.CPNewPassword.text completion:^(NSDictionary *content, BOOL success) {
        
        if (success) {
            
            NSString *status = content[@"status"];
            
            if (status.integerValue == 1) {
                [self showAlertInFloatViewWithMessage:@"修改成功" dismissTime:0.7 dismiss:nil];
            } else if (status.integerValue == 8) {
                [self showAlertInFloatViewWithMessage:@"旧密码不正确" dismissTime:0.7 dismiss:nil];
            } else {
                [self showAlertInFloatViewWithMessage:@"修改失败" dismissTime:0.7 dismiss:nil];
            }
            
        } else {
            [self showAlertInFloatViewWithMessage:@"网络不知到飞哪里去了\n请稍后再试" dismissTime:0.7 dismiss:nil];
        }
        
    }];
}


#pragma makr - autonym view
/** 未实名认证页面 */
- (void)autonymAddSubviewsWithNOautonym {
    self.NANameTextField.text = @"";
    self.NAIDCardNumberTextField.text = @"";
    [self.autonymView addSubview:self.NARemindLabel];
    [self.autonymView addSubview:self.NANameTextField];
    [self.autonymView addSubview:self.NAIDCardNumberTextField];
    [self.autonymView addSubview:self.NASureButton];
}

/** 实名认证页面 */
- (void)autonymAddSubViews {
    NSString *name = [UserModel currentUser].id_name;
    NSString *idcard = [UserModel currentUser].id_card;

    NSMutableString *xingstr = [NSMutableString string];
    for (int i = 0; i < name.length - 1 ; i++) {
        [xingstr appendString:@"*"];
    }
    NSString *subName = [NSString stringWithFormat:@"%@%@",[name substringToIndex:1],xingstr];
    NSString *subIDCard = [NSString stringWithFormat:@"%@****%@",[idcard substringToIndex:4],[idcard substringFromIndex:idcard.length - 4]];
    
    self.NAAlreadyNameLabel.text = [NSString stringWithFormat:@"姓  名 : %@",subName];
    self.NAAlreadyIDCardLabel.text = [NSString stringWithFormat:@"证件号 : %@",subIDCard];
    
    [self.autonymView addSubview:self.NAAlreadyRemindLabel];
    [self.autonymView addSubview:self.NAAlreadyBackView];
}

/** 确认按钮响应 */
- (void)respondsToNASureButton {
    
//    syLog(@"实名认证");
    
    //验证姓名
    NSString *username = @"[\u4e00-\u9fa5]{2,10}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", username];
    if (![regextestmobile evaluateWithObject:self.NANameTextField.text]) {
        [self showAlertInFloatViewWithMessage:@"请输入2位以上的中文姓名" dismissTime:0.7 dismiss:nil];
        return;
    }
    
    //验证身份证号码
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    if (![pred evaluateWithObject:self.NAIDCardNumberTextField.text]) {
        [self showAlertInFloatViewWithMessage:@"请输入15位或18位证件号码" dismissTime:0.7 dismiss:nil];
        return;
    }
    
    [UserModel IDCardVerifiedWithIDNumber:self.NAIDCardNumberTextField.text IDName:self.NANameTextField.text completion:^(NSDictionary *content, BOOL success) {
        
        if (success) {
            NSString *status = content[@"status"];
            if (status.integerValue == 1) {
                
                [self showAlertInFloatViewWithMessage:@"实名认证成功" dismissTime:0.7 dismiss:nil];

                [self.NARemindLabel removeFromSuperview];
                [self.NANameTextField removeFromSuperview];
                [self.NAIDCardNumberTextField removeFromSuperview];
                [self.NASureButton removeFromSuperview];

                [UserModel currentUser].id_name = self.NANameTextField.text;
                [UserModel currentUser].id_card = self.NAIDCardNumberTextField.text;

                [self autonymAddSubViews];
                
            } else {
                [self showAlertInFloatViewWithMessage:@"网络故障\n请稍后再试" dismissTime:0.6 dismiss:nil];
            }
            
        } else {
            [self showAlertInFloatViewWithMessage:@"网络故障\n请稍后再试" dismissTime:0.6 dismiss:nil];
        }
//        syLog(@"%@",content);
        
    }];
}

#pragma mark - getter
/** title */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(FLOAT_MENU_WIDTH / 4, FLOAT_MENU_WIDTH / 30, FLOAT_MENU_WIDTH / 2, FLOAT_MENU_WIDTH / 8);
        _titleLabel.text = @"设置";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = BUTTON_GREEN_COLOR;
        _titleLabel.font = [UIFont systemFontOfSize:22];
    }
    return _titleLabel;
}

/** 分割线 */
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor lightGrayColor];
        _line.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH, 1);
        _line.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_WIDTH / 15 + FLOAT_MENU_WIDTH / 8);
    }
    return _line;
}

/** 自动登录游戏 */
- (UIView *)autoLogin {
    if (!_autoLogin) {
        _autoLogin = [[UIView alloc] init];
        _autoLogin.frame = CGRectMake(0, CGRectGetMaxY(self.line.frame), FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT / 5);
        _autoLogin.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *autoTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, FLOAT_MENU_WIDTH * 0.7, _autoLogin.bounds.size.height / 3 * 2 - 10)];
        autoTitle.text = @"自动登录游戏";
        autoTitle.textColor = TEXTCOLOR;
        autoTitle.textAlignment = NSTextAlignmentLeft;
        autoTitle.font = [UIFont systemFontOfSize:20];
        [autoTitle sizeToFit];
        autoTitle.center = CGPointMake(autoTitle.center.x, _autoLogin.bounds.size.height / 3);
        
        [_autoLogin addSubview:autoTitle];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(autoTitle.frame), CGRectGetMaxY(autoTitle.frame), autoTitle.frame.size.width, _autoLogin.bounds.size.height / 3)];
        
        detailLabel.text = @"开启后将自动登录最近使用的账号";
        detailLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.font = [UIFont systemFontOfSize:14];
        [detailLabel sizeToFit];
        
        [_autoLogin addSubview:detailLabel];
        
        if (autoTitle.bounds.size.height + detailLabel.bounds.size.height > _autoLogin.bounds.size.height) {
            _autoLogin.bounds = CGRectMake(0, 0, _autoLogin.bounds.size.width, (autoTitle.bounds.size.height + detailLabel.bounds.size.height));
        }
        
        self.autoSwitch = [[UISwitch alloc] init];
        self.autoSwitch.center = CGPointMake(FLOAT_MENU_WIDTH - self.autoSwitch.bounds.size.width / 2 - 15, _autoLogin.bounds.size.height / 2);
        self.autoSwitch.onTintColor = BUTTON_GREEN_COLOR;
        [self.autoSwitch addTarget:self action:@selector(respondsToAutoSwitch:) forControlEvents:(UIControlEventValueChanged)];
        
        [_autoLogin addSubview:self.autoSwitch];
        
        
        CALayer *lineLayer = [CALayer layer];
        lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
        lineLayer.frame = CGRectMake(0,_autoLogin.frame.size.height - 2, FLOAT_MENU_WIDTH, 1);
        
        [_autoLogin.layer addSublayer:lineLayer];
        
    }
    return _autoLogin;
}

/** 绑定手机号 */
- (UIView *)bindPhoneNumber {
    if (!_bindPhoneNumber) {
        _bindPhoneNumber = [self creatViewWithTitle:@"绑定手机"];
        _bindPhoneNumber.frame = CGRectMake(0, CGRectGetMaxY(self.autoLogin.frame), FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT / 7);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToBindPhoneNumberView)];
        
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        
        
        [_bindPhoneNumber addGestureRecognizer:tap];
    }
    return _bindPhoneNumber;
}

/** 修改密码 */
- (UIView *)changePassword {
    if (!_changePassword) {
        _changePassword = [self creatViewWithTitle:@"修改密码"];
        _changePassword.frame = CGRectMake(0, CGRectGetMaxY(self.bindPhoneNumber.frame), FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT / 7);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToChangePasswordView)];
        
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        
        [_changePassword addGestureRecognizer:tap];
    }
    return _changePassword;
}

/** 实名认证 */
- (UIView *)autonym {
    if (!_autonym) {
        _autonym = [self creatViewWithTitle:@"实名认证"];
        _autonym.frame = CGRectMake(0, CGRectGetMaxY(self.changePassword.frame), FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT / 7);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAutonymView)];
        
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        
        [_autonym addGestureRecognizer:tap];
    }
    return _autonym;
}

/** 版本标签 */
- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.frame = CGRectMake(0, CGRectGetMaxY(self.autonym.frame), FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT - CGRectGetMaxY(self.autonym.frame));
        _versionLabel.text = SDK_VERSION;
        _versionLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.font = [UIFont systemFontOfSize:22];
        
    }
    return _versionLabel;
}



- (UIView *)creatViewWithTitle:(NSString *)title {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT / 7)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *autoTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, FLOAT_MENU_WIDTH * 0.7, view.bounds.size.height / 3 * 2 - 15)];
    autoTitle.text = title;
    autoTitle.textColor = TEXTCOLOR;
    autoTitle.textAlignment = NSTextAlignmentLeft;
    autoTitle.font = [UIFont systemFontOfSize:20];
    [autoTitle sizeToFit];
    autoTitle.tag = 10086;
    autoTitle.center = CGPointMake(autoTitle.center.x, view.bounds.size.height / 2);
    [view addSubview:autoTitle];
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    lineLayer.frame = CGRectMake(0,view.frame.size.height - 2, FLOAT_MENU_WIDTH, 1);
    
    [view.layer addSublayer:lineLayer];
    
    return view;
}


#pragma mark ========================== 详细页面 ==============================================
/** 修改手机详细页面 */
- (UIView *)bindPhoneNumberView {
    if (!_bindPhoneNumberView) {
        _bindPhoneNumberView = [self creatDetailViewWithTitle:@"绑定手机"];
        _bindPhoneNumberView.frame = self.bindPhoneNumber.frame;
    }
    return _bindPhoneNumberView;
}

/** 返回按钮 */
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _backButton.frame = CGRectMake(FLOAT_MENU_WIDTH * 0.025, FLOAT_MENU_WIDTH/ 30, FLOAT_MENU_WIDTH / 8, FLOAT_MENU_WIDTH / 8);
//        [_backButton setTitle:@"fanhui" forState:(UIControlStateNormal)];
        [_backButton setImage:SDK_IMAGE(@"SDK_SettingChildBack") forState:(UIControlStateNormal)];
        [_backButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [_backButton addTarget:self action:@selector(respondsToBackButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backButton;
}

/** 修改密码页面 */
- (UIView *)changePasswordView {
    if (!_changePasswordView) {
        _changePasswordView = [self creatDetailViewWithTitle:@"修改密码"];
        _changePasswordView.frame = self.changePassword.frame;
    }
    return _changePasswordView;
}

/** 实名认证 */
- (UIView *)autonymView {
    if (!_autonymView) {
        _autonymView = [self creatDetailViewWithTitle:@"实名认证"];
        _autonymView.frame = self.autonym.frame;
    }
    return _autonymView;
}


/** 创建详细页面 */
- (UIView *)creatDetailViewWithTitle:(NSString *)title {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT / 7)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *autoTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, FLOAT_MENU_WIDTH * 0.7, view.bounds.size.height / 3 * 2 - 15)];
    autoTitle.text = title;
    autoTitle.textColor = TEXTCOLOR;
    autoTitle.textAlignment = NSTextAlignmentLeft;
    autoTitle.font = [UIFont systemFontOfSize:20];
    [autoTitle sizeToFit];
    autoTitle.tag = 10086;
    autoTitle.center = CGPointMake(autoTitle.center.x, view.bounds.size.height / 2);
    [view addSubview:autoTitle];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 1, FLOAT_MENU_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    line.tag = 10087;
    [view addSubview:line];
    
    
    view.layer.cornerRadius = 8;
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.borderWidth = 1.f;
    view.layer.masksToBounds = YES;
    
    
    return view;
}

#pragma mark - ============================ 详细视图 ==========================================
//绑定手机详细视图
/** 提示标签 */
- (UILabel *)BPRemindLabel {
    if (!_BPRemindLabel) {
        _BPRemindLabel = [[UILabel alloc] init];
        _BPRemindLabel.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH - 30, 44);
        _BPRemindLabel.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT / 3);
        _BPRemindLabel.text = @"目前仅支持中国大陆手机";
        _BPRemindLabel.font = [UIFont systemFontOfSize:21];
        _BPRemindLabel.textColor = TEXTCOLOR;
    }
    return _BPRemindLabel;
}

//输入背景
- (UIView *)BPImportView {
    if (!_BPImportView) {
        _BPImportView = [[UIView alloc] init];
        _BPImportView.frame = CGRectMake(CGRectGetMinX(self.BPRemindLabel.frame), CGRectGetMaxY(self.BPRemindLabel.frame) + 20, CGRectGetWidth(self.BPRemindLabel.frame), 44);
        
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
        _BPImportButton.frame = CGRectMake(0, 0, 44, 44);
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
        _BPImportTextField.frame = CGRectMake(50, 0, FLOAT_MENU_WIDTH - 100, 44);
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
        _BPNextButton.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH - 30, 44);
        _BPNextButton.center = CGPointMake(FLOAT_MENU_WIDTH / 2, CGRectGetMaxY(self.BPImportView.frame) + 60);
        _BPNextButton.backgroundColor = BUTTON_GREEN_COLOR;
        _BPNextButton.layer.cornerRadius = 22;
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

#pragma mark ============================= 修改密码页面 ====================================
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

- (UITextField *)CPOldPassword {
    if (!_CPOldPassword) {
        _CPOldPassword = [self changePasswordViewcreatTextfieldWithTitle:@"请输入旧密码"];
        _CPOldPassword.center = CGPointMake(FLOAT_MENU_WIDTH / 2 , FLOAT_MENU_HEIGHT / 10 * 3);
    }
    return _CPOldPassword;
}

- (UITextField *)CPNewPassword {
    if (!_CPNewPassword) {
        _CPNewPassword = [self changePasswordViewcreatTextfieldWithTitle:@"请输入新密码"];
        _CPNewPassword.center = CGPointMake(FLOAT_MENU_WIDTH / 2 , FLOAT_MENU_HEIGHT / 10 * 4.7);
    }
    return _CPNewPassword;
}

- (UITextField *)CPAffirmPassword {
    if (!_CPAffirmPassword) {
        _CPAffirmPassword = [self changePasswordViewcreatTextfieldWithTitle:@"请确认密码"];
        _CPAffirmPassword.center = CGPointMake(FLOAT_MENU_WIDTH / 2 , FLOAT_MENU_HEIGHT / 10 * 6.4);
    }
    return _CPAffirmPassword;
}

- (UIButton *)CPSureButton {
    if (!_CPSureButton) {
        _CPSureButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _CPSureButton.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH * 0.85, FLOAT_MENU_HEIGHT / 9);
        _CPSureButton.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT / 10 * 8);
        
        [_CPSureButton setTitle:@"确认修改" forState:(UIControlStateNormal)];
        _CPSureButton.backgroundColor = BUTTON_GREEN_COLOR;
        
        _CPSureButton.layer.cornerRadius = 8;
        _CPSureButton.layer.masksToBounds = YES;
        
        [_CPSureButton addTarget:self action:@selector(respondsToCPSureButton) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_CPSureButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_CPSureButton setTitleColor:[UIColor grayColor] forState:(UIControlStateHighlighted)];
    }
    return _CPSureButton;
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

//完成实名认证
- (UILabel *)NAAlreadyRemindLabel {
    if (!_NAAlreadyRemindLabel) {
        _NAAlreadyRemindLabel = [[UILabel alloc] init];
        _NAAlreadyRemindLabel.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH, 44);
        _NAAlreadyRemindLabel.text = @"您已经完成实名认证";
        _NAAlreadyRemindLabel.font = [UIFont systemFontOfSize:20];
        _NAAlreadyRemindLabel.textColor = [UIColor grayColor];
        [_NAAlreadyRemindLabel sizeToFit];
        _NAAlreadyRemindLabel.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT / 3);
        
    }
    return _NAAlreadyRemindLabel;
}

- (UIView *)NAAlreadyBackView {
    if (!_NAAlreadyBackView) {
        _NAAlreadyBackView = [[UIView alloc] init];
        _NAAlreadyBackView.backgroundColor = [UIColor whiteColor];
        
        _NAAlreadyBackView.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH * 0.8, 100);
        _NAAlreadyBackView.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT / 3 + 75);
        
        _NAAlreadyBackView.layer.cornerRadius = 8;
        _NAAlreadyBackView.layer.masksToBounds = YES;
        _NAAlreadyBackView.layer.borderColor = [UIColor grayColor].CGColor;
        _NAAlreadyBackView.layer.borderWidth = 1.f;
        
        [_NAAlreadyBackView addSubview:self.NAAlreadyNameLabel];
        [_NAAlreadyBackView addSubview:self.NAAlreadyIDCardLabel];
    }
    return _NAAlreadyBackView;
}

- (UILabel *)NAAlreadyNameLabel {
    if (!_NAAlreadyNameLabel) {
        _NAAlreadyNameLabel = [[UILabel alloc] init];
        _NAAlreadyNameLabel.frame = CGRectMake(FLOAT_MENU_WIDTH * 0.1, 6, FLOAT_MENU_WIDTH * 0.6, 44);
        _NAAlreadyNameLabel.textColor = TEXTCOLOR;
        _NAAlreadyNameLabel.text = @"姓   名 : 金*";
    }
    return _NAAlreadyNameLabel;
}

- (UILabel *)NAAlreadyIDCardLabel {
    if (!_NAAlreadyIDCardLabel) {
        _NAAlreadyIDCardLabel = [[UILabel alloc] init];
        _NAAlreadyIDCardLabel.frame = CGRectMake(FLOAT_MENU_WIDTH * 0.1, 50, FLOAT_MENU_WIDTH * 0.6, 44);
        _NAAlreadyIDCardLabel.textColor = TEXTCOLOR;
        _NAAlreadyIDCardLabel.text = @"证件号 : 1234****1234";
    }
    return _NAAlreadyIDCardLabel;
}





/** 悬浮窗上弹出提示框 */
- (void)showAlertInFloatViewWithMessage:(NSString *)message dismissTime:(float)second dismiss:(void(^)(void))dismiss {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [[self floatViewController] presentViewController:alertController animated:YES completion:nil];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:^{
            if (dismiss) {
                dismiss();
            }
        }];
    });
}

/** 获取悬浮窗视图控制器 */
- (UIViewController *)floatViewController {
    UIViewController *result = nil;
    
    NSArray *windows = [[UIApplication sharedApplication] windows];
    
    if (windows == nil || windows.count == 0) {
        return nil;
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != (UIWindowLevelAlert - 1)) {
        for (UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == (UIWindowLevelAlert - 1)) {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray<UIView *> *views = [window subviews];
    if (views == nil || views.count == 0) {
        return nil;
    }
    
    UIView *frontView = [views objectAtIndex:0];
    
    
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    
    return result;
}



@end


















