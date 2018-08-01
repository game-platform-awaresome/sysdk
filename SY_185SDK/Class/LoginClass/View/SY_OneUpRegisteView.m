//
//  SY_OneUpRegisteView.m
//  SDK185SY
//
//  Created by 石燚 on 2017/7/13.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SY_OneUpRegisteView.h"

#import "UserModel.h"

#define LOGIN_BACK_WIDTH FLOAT_MENU_WIDTH
#define LOGIN_BACK_HEIGHT LOGIN_BACK_WIDTH * 0.8

@interface SY_OneUpRegisteView ()

/** 关闭一键注册 */
@property (nonatomic, strong) UIButton *closeOURBackgroundView;
/** 显示账号 */
@property (nonatomic, strong) UILabel *OURaccountLabel;
/** 显示密码 */
@property (nonatomic, strong) UILabel *OURPasswordLabel;
/** 提示信息 */
@property (nonatomic, strong) UILabel *OURRemindLabel;
/** 截屏保存 */
@property (nonatomic, strong) UIButton *OURScreenshotsBtn;
/** 进入游戏 */
@property (nonatomic, strong) UIButton *OURLoginBtn;
/** 自己注册账号 */
@property (nonatomic, strong) UIButton *OUROwnerRegister;


@end

@implementation SY_OneUpRegisteView

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

    [self addSubview:self.closeOURBackgroundView];
    [self addSubview:self.OUROwnerRegister];
    [self addSubview:self.OURaccountLabel];
    [self addSubview:self.OURPasswordLabel];
    [self addSubview:self.OURRemindLabel];
    [self addSubview:self.OURScreenshotsBtn];
    [self addSubview:self.OURLoginBtn];
}

#pragma mark - responds
/** 关闭一键注册页面 */
- (void)clickCloseOURBackgroundBtn {
    [self removeFromSuperview];
}

/** 前往注册 */
- (void)clickOUROwnerRegisterBtn {
    if (self.oneUpDelegate && [self.oneUpDelegate respondsToSelector:@selector(SYOneUPRegistViewShowRegistView)]) {
        [self removeFromSuperview];
        [self.oneUpDelegate SYOneUPRegistViewShowRegistView];
    }
}

- (void)respondsToOURLoginBtn {
    if (self.oneUpDelegate && [self.oneUpDelegate respondsToSelector:@selector(SYOneUpRegistViewLoginWithAccount:Password:)]) {
        [self.oneUpDelegate SYOneUpRegistViewLoginWithAccount:self.OURCurrentAccount Password:self.OURCurrentPassword];
    }

}

- (void)respondsToOURScreenshotsBtn {
    if (self.oneUpDelegate && [self.oneUpDelegate respondsToSelector:@selector(SYOneUpRegistViewScreenShots)]) {
        [self.oneUpDelegate SYOneUpRegistViewScreenShots];
    }
}

#pragma mark - setter
- (void)setOURCurrentAccount:(NSString *)OURCurrentAccount {
    _OURCurrentAccount = OURCurrentAccount;
    self.OURaccountLabel.text = [NSString stringWithFormat:@"   账号 : %@",OURCurrentAccount];
}

- (void)setOURCurrentPassword:(NSString *)OURCurrentPassword {
    _OURCurrentPassword = OURCurrentPassword;
    self.OURPasswordLabel.text = [NSString stringWithFormat:@"   密码 : %@",OURCurrentPassword];
}


#pragma mark - getter
- (UIButton *)closeOURBackgroundView {
    if (!_closeOURBackgroundView) {
        _closeOURBackgroundView = [UIButton buttonWithType:(UIButtonTypeCustom)];

        _closeOURBackgroundView.frame = CGRectMake(LOGIN_BACK_WIDTH * 0.05, CGRectGetMaxY(self.OURScreenshotsBtn.frame) + 10, LOGIN_BACK_WIDTH * 0.15, LOGIN_BACK_WIDTH * 0.15);

        [_closeOURBackgroundView setTitle:@"<<<我有账号" forState:(UIControlStateNormal)];
        [_closeOURBackgroundView sizeToFit];
        [_closeOURBackgroundView setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

        [_closeOURBackgroundView addTarget:self action:@selector(clickCloseOURBackgroundBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeOURBackgroundView;
}

- (UIButton *)OUROwnerRegister {
    if (!_OUROwnerRegister) {
        _OUROwnerRegister = [UIButton buttonWithType:(UIButtonTypeCustom)];

        [_OUROwnerRegister setTitle:@"我要注册>>>" forState:(UIControlStateNormal)];
        [_OUROwnerRegister sizeToFit];

        _OUROwnerRegister.frame = CGRectMake(CGRectGetMaxX(self.OURLoginBtn.frame) - _OUROwnerRegister.frame.size.width, CGRectGetMaxY(self.OURScreenshotsBtn.frame) + 10, _OUROwnerRegister.frame.size.width, _OUROwnerRegister.frame.size.height);


        [_OUROwnerRegister setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

        [_OUROwnerRegister addTarget:self action:@selector(clickOUROwnerRegisterBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _OUROwnerRegister;
}

- (UILabel *)OURaccountLabel {
    if (!_OURaccountLabel) {
        _OURaccountLabel = [[UILabel alloc] init];
        _OURaccountLabel.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.9, LOGIN_BACK_HEIGHT * 0.175);
        _OURaccountLabel.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.2);
        _OURaccountLabel.layer.cornerRadius = 5;
        _OURaccountLabel.layer.masksToBounds = YES;
        _OURaccountLabel.layer.borderWidth = 1;
        _OURaccountLabel.layer.borderColor = RGBCOLOR(223, 202, 211).CGColor;
        _OURaccountLabel.text = @"  账号:sy1234567890123";
        _OURaccountLabel.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        _OURaccountLabel.textColor = TEXTCOLOR;

    }
    return _OURaccountLabel;
}

- (UILabel *)OURPasswordLabel {
    if (!_OURPasswordLabel) {
        _OURPasswordLabel = [[UILabel alloc] init];
        _OURPasswordLabel.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.9, LOGIN_BACK_HEIGHT * 0.175);
        _OURPasswordLabel.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.4);
        _OURPasswordLabel.layer.cornerRadius = 5;
        _OURPasswordLabel.layer.masksToBounds = YES;
        _OURPasswordLabel.layer.borderWidth = 1;
        _OURPasswordLabel.layer.borderColor = RGBCOLOR(223, 202, 211).CGColor;
        _OURPasswordLabel.text = @"  密码:sy1234567890123";
        _OURPasswordLabel.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        _OURPasswordLabel.textColor = TEXTCOLOR;
    }
    return _OURPasswordLabel;
}

- (UILabel *)OURRemindLabel {
    if (!_OURRemindLabel) {
        _OURRemindLabel = [[UILabel alloc] init];
        _OURRemindLabel.frame = CGRectMake(CGRectGetMinX(self.OURPasswordLabel.frame), CGRectGetMaxY(self.OURPasswordLabel.frame) + 8, LOGIN_BACK_WIDTH * 0.85, FLOAT_MENU_WIDTH * 0.05);
        _OURRemindLabel.text = @"*防止遗失>>建议截屏保存到手机";
        _OURRemindLabel.textColor = [UIColor redColor];
        _OURRemindLabel.font = [UIFont systemFontOfSize:12];

    }
    return _OURRemindLabel;
}

- (UIButton *)OURScreenshotsBtn {
    if (!_OURScreenshotsBtn) {
        _OURScreenshotsBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _OURScreenshotsBtn.frame = CGRectMake(CGRectGetMinX(self.OURRemindLabel.frame), CGRectGetMaxY(self.OURRemindLabel.frame) + FLOAT_MENU_WIDTH * 0.05, FLOAT_MENU_WIDTH * 0.4, FLOAT_MENU_WIDTH * 0.12);
        [_OURScreenshotsBtn setTitle:@"截屏保存" forState:(UIControlStateNormal)];

        _OURScreenshotsBtn.layer.cornerRadius = 8;
        _OURScreenshotsBtn.layer.masksToBounds = YES;

        [_OURScreenshotsBtn setBackgroundColor:BUTTON_GREEN_COLOR];

        [_OURScreenshotsBtn addTarget:self action:@selector(respondsToOURScreenshotsBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _OURScreenshotsBtn;
}

- (UIButton *)OURLoginBtn {
    if (!_OURLoginBtn) {
        _OURLoginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _OURLoginBtn.frame = CGRectMake(FLOAT_MENU_WIDTH * 0.55, CGRectGetMinY(self.OURScreenshotsBtn.frame), FLOAT_MENU_WIDTH * 0.4, FLOAT_MENU_WIDTH * 0.12);
        [_OURLoginBtn setTitle:@"进入游戏" forState:(UIControlStateNormal)];

        _OURLoginBtn.layer.cornerRadius = 8;
        _OURLoginBtn.layer.masksToBounds = YES;

        [_OURLoginBtn setBackgroundColor:BUTTON_YELLOW_COLOR];

        [_OURLoginBtn addTarget:self action:@selector(respondsToOURLoginBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _OURLoginBtn;
}


@end








