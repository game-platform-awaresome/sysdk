//
//  SY_AutoLoginView.m
//  SDK185SY
//
//  Created by 石燚 on 2017/7/14.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SY_AutoLoginView.h"
#import "UserModel.h"

#define LOGIN_BACK_WIDTH FLOAT_MENU_WIDTH
#define LOGIN_BACK_HEIGHT LOGIN_BACK_WIDTH * 0.8

@interface SY_AutoLoginView ()

/** title */
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;

/** 定时器 */
@property (nonatomic, strong) dispatch_source_t timer;

/** 切换账号 */
@property (nonatomic, strong) UIButton *changeAccountButton;



@end

@implementation SY_AutoLoginView

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
    self.backgroundColor = [UIColor whiteColor];

    NSDictionary *dict = [UserModel getAccountAndPassword];
    NSString *account = dict[@"account"];
    NSString *phoneNumber = dict[@"phoneNumber"];
    if (account) {
        self.titleLabel.text = [NSString stringWithFormat:@"正在为您登录 : %@",account];
    } else if (phoneNumber) {
        self.titleLabel.text = [NSString stringWithFormat:@"正在为您登录 : %@",phoneNumber];
    } else {
        self.titleLabel.text = @"正在为您登录";
    }

    __block int count = 2;

    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();

    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);

    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{

        [self.changeAccountButton setTitle:[NSString stringWithFormat:@"    更换账号  %ds",count] forState:(UIControlStateNormal)];

        NSString *userLogout = SDK_GET_USER_LOGOUT;

        if (count == 0) {
            // 取消定时器
            if (userLogout.integerValue == 0) {
                if (self.autoLoginDelegate && [self.autoLoginDelegate respondsToSelector:@selector(SYAutoLoginViewAutoLogin)]) {
                    [self.autoLoginDelegate SYAutoLoginViewAutoLogin];
                     [self removeFromSuperview];
                }
            }
            dispatch_cancel(self.timer);
            self.timer = nil;
        }

        count--;
    });

    // 启动定时器
    dispatch_resume(self.timer);

    [self addSubview:self.titleLabel];
    [self addSubview:self.changeAccountButton];
}

#pragma mark - responds
- (void)respondsToChangeAccountButton {
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
    [self removeFromSuperview];
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.bounds = CGRectMake(0, 0,  LOGIN_BACK_WIDTH * 0.9 , LOGIN_BACK_HEIGHT * 0.15);
        _titleLabel.center = CGPointMake(LOGIN_BACK_WIDTH / 2 , LOGIN_BACK_HEIGHT / 3);

        _titleLabel.layer.borderWidth = 1;
        _titleLabel.layer.borderColor = RGBCOLOR(223, 202, 211).CGColor;
        _titleLabel.layer.cornerRadius = 5;
        _titleLabel.layer.masksToBounds = YES;

        _titleLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        _titleLabel.textColor = TEXTCOLOR;

        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH * 0.8, LOGIN_BACK_HEIGHT * 0.15);

        _accountLabel.backgroundColor = [UIColor blackColor];
        
    }
    return _accountLabel;
}

- (UIButton *)changeAccountButton {
    if (!_changeAccountButton) {
        _changeAccountButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _changeAccountButton.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH / 3 * 2, LOGIN_BACK_HEIGHT * 0.15);
        _changeAccountButton.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.66);
        [_changeAccountButton setTitle:@"   更换账号" forState:(UIControlStateNormal)];
        [_changeAccountButton addTarget:self action:@selector(respondsToChangeAccountButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_changeAccountButton setTitleColor:TEXTCOLOR forState:(UIControlStateNormal)];

        [_changeAccountButton setBackgroundColor:BUTTON_GREEN_COLOR];
        [_changeAccountButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

        _changeAccountButton.layer.cornerRadius = LOGIN_BACK_HEIGHT * 0.075;
        _changeAccountButton.layer.masksToBounds = YES;

        [_changeAccountButton setImage:SDK_IMAGE(@"SDK_Change_account") forState:(UIControlStateNormal)];

    }
    return _changeAccountButton;
}


@end










