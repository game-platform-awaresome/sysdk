//
//  FAccountViewController.m
//  SDK185SY
//
//  Created by 石燚 on 2017/6/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FAccountViewController.h"
#import "UserModel.h"


@interface FAccountViewController ()

/** 头像 */
@property (nonatomic, strong) UIImageView *avatar;

/** ID */
@property (nonatomic, strong) UILabel *userID;

/** 平台币 */
@property (nonatomic, strong) UIButton *platformCoin;

/** 设置按钮 */
@property (nonatomic, strong) UIButton *settingButton;

/** 充值记录 */
@property (nonatomic, strong) UIButton *rechargeButton;
@property (nonatomic, strong) UILabel *rechargeLabel;

/** 问题反馈 */
@property (nonatomic, strong) UIButton *feedbackButton;
@property (nonatomic, strong) UILabel *feedbackLabel;

/** 公告 */
@property (nonatomic, strong) UIButton *announceButton;
@property (nonatomic, strong) UILabel *announceLabel;



@end

@implementation FAccountViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self settingViews];
}

- (void)settingViews {
    NSString *username = [UserModel currentUser].username;

    if (username) {
        self.userID.text = [NSString stringWithFormat:@"ID : %@",username];
    } else {
        self.userID.text = @"ID:********";
    }

    if ([UserModel currentUser].platform_money) {
        [self.platformCoin setTitle:[NSString stringWithFormat:@"  %@  ",[UserModel currentUser].platform_money] forState:(UIControlStateNormal)];
    } else {
        [self.platformCoin setTitle:@"  0  " forState:(UIControlStateNormal)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    
    self.view.frame = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT - (FLOAT_MENU_WIDTH / 4));
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.avatar];
    [self.view addSubview:self.userID];
    [self.view addSubview:self.settingButton];
    [self.view addSubview:self.rechargeButton];
    [self.view addSubview:self.rechargeLabel];
    [self.view addSubview:self.feedbackButton];
    [self.view addSubview:self.feedbackLabel];
    [self.view addSubview:self.announceButton];
    [self.view addSubview:self.announceLabel];
    [self.view addSubview:self.platformCoin];
}

#pragma mark - responds
/** 设置按钮 */
- (void)respondsToSettingButton {
    if ([self.delegate respondsToSelector:@selector(FAccountViewController:clickSettingButton:)]) {
        [self.delegate FAccountViewController:self clickSettingButton:self.settingButton];
    }
}

/** 充值记录 */
- (void)respondsToRechargeButton {
    if ([self.delegate respondsToSelector:@selector(FAccountViewController:clickRechargeButton:)]) {
        [self.delegate FAccountViewController:self clickRechargeButton:self.rechargeButton];
    }
}

/** 公告 */
- (void)respondsToAnnounceButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FAccountViewController:clickAnnouncementButton:)]) {
        [self.delegate FAccountViewController:self clickAnnouncementButton:self.announceButton];
    }
}

/** 问题反馈 */
- (void)respondsToFeedBackButton {
    if ([self.delegate respondsToSelector:@selector(FAccountViewController:clickFeedBackButton:)]) {
        [self.delegate FAccountViewController:self clickFeedBackButton:self.feedbackButton];
    }
}


#pragma mark - getter
/** 头像 */
- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.bounds = CGRectMake(0, 0, view_width / 4, view_width / 4);
        _avatar.center = CGPointMake(view_width / 2, view_height / 2.6);
        _avatar.layer.cornerRadius = view_width / 8;
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        _avatar.layer.borderWidth = 3.f;
        _avatar.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [_avatar setImage:SDK_IMAGE(@"SDK_Avator")];
    }
    return _avatar;
}

/** 用户 ID */
- (UILabel *)userID {
    if (!_userID) {
        _userID = [[UILabel alloc] init];
        _userID.bounds = CGRectMake(0, 0, view_width, 30);
        _userID.center = CGPointMake(view_width / 2, self.avatar.center.y + view_width / 8 + 20);
        _userID.textAlignment = NSTextAlignmentCenter;
        _userID.textColor = BUTTON_GREEN_COLOR;
        _userID.font = [UIFont systemFontOfSize:18];
        
    }
    return _userID;
}

/** 设置按钮 */
- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _settingButton.frame = CGRectMake(view_width * 0.85, view_width / 30, view_width / 8, view_width / 8);
        [_settingButton setImage:[UIImage imageNamed:IMAGE_GET_BUNDLE_PATH(@"SDK_Setting")] forState:(UIControlStateNormal)];
        [_settingButton addTarget:self action:@selector(respondsToSettingButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _settingButton;
}

/** 充值记录 */
- (UIButton *)rechargeButton {
    if (!_rechargeButton) {
        _rechargeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _rechargeButton.frame = CGRectMake(10, view_height * 0.7 - 10, view_width / 5, view_width / 5);
        [_rechargeButton setImage:[UIImage imageNamed:IMAGE_GET_BUNDLE_PATH(@"SDK_recharge_dark")] forState:(UIControlStateNormal)];
        [_rechargeButton addTarget:self action:@selector(respondsToRechargeButton) forControlEvents:(UIControlEventTouchUpInside)];
        _rechargeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rechargeButton setTitleColor:TEXTCOLOR forState:(UIControlStateNormal)];
        [_rechargeButton setTitleColor:BLUE_DARK forState:(UIControlStateSelected)];
    }
    return _rechargeButton;
}

- (UILabel *)rechargeLabel {
    if (!_rechargeLabel) {
        _rechargeLabel = [[UILabel alloc] init];
        _rechargeLabel.bounds = CGRectMake(0, 0, view_width / 5, 30);
        _rechargeLabel.center = CGPointMake(self.rechargeButton.center.x, self.rechargeButton.center.y + view_width / 12);
        _rechargeLabel.text = @"充值记录";
        _rechargeLabel.font = [UIFont systemFontOfSize:14];
        _rechargeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rechargeLabel;
}

/** 问题反馈按钮 */
- (UIButton *)feedbackButton {
    if (!_feedbackButton) {
        _feedbackButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _feedbackButton.frame = CGRectMake(view_width * 0.8 - 10, view_height * 0.7 - 10, view_width / 5, view_width / 5);
        [_feedbackButton setImage:[UIImage imageNamed:IMAGE_GET_BUNDLE_PATH(@"SDK_feedBack_dark")]
         forState:(UIControlStateNormal)];
        _feedbackButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_feedbackButton setTitleColor:TEXTCOLOR forState:(UIControlStateNormal)];
        [_feedbackButton setTitleColor:BLUE_DARK forState:(UIControlStateSelected)];
        [_feedbackButton addTarget:self action:@selector(respondsToFeedBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _feedbackButton;
}

- (UILabel *)feedbackLabel {
    if (!_feedbackLabel) {
        _feedbackLabel = [[UILabel alloc] init];
        _feedbackLabel.bounds = CGRectMake(0, 0, view_width / 5, 30);
        _feedbackLabel.center = CGPointMake(self.feedbackButton.center.x, self.feedbackButton.center.y + view_width / 12);
        _feedbackLabel.text = @"问题反馈";
        _feedbackLabel.font = [UIFont systemFontOfSize:14];
        _feedbackLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _feedbackLabel;
}

- (UIButton *)announceButton {
    if (!_announceButton) {
        _announceButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _announceButton.frame = CGRectMake(view_width * 0.8 - 10, view_height * 0.7 - 10, view_width / 5, view_width / 5);
        _announceButton.center = CGPointMake(view_width / 2, _announceButton.center.y);
        [_announceButton setImage:[UIImage imageNamed:IMAGE_GET_BUNDLE_PATH(@"SDK_announce_dark")]
                         forState:(UIControlStateNormal)];
        _announceButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_announceButton setTitleColor:TEXTCOLOR forState:(UIControlStateNormal)];
        [_announceButton setTitleColor:BLUE_DARK forState:(UIControlStateSelected)];
        [_announceButton addTarget:self action:@selector(respondsToAnnounceButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _announceButton;
}

- (UILabel *)announceLabel {
    if (!_announceLabel) {
        _announceLabel = [[UILabel alloc] init];
        _announceLabel.bounds = CGRectMake(0, 0, view_width / 5, 30);
        _announceLabel.center = CGPointMake(self.announceButton.center.x, self.announceButton.center.y + view_width / 12);
        _announceLabel.text = @"公告";
        _announceLabel.font = [UIFont systemFontOfSize:14];
        _announceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _announceLabel;
}

- (CGRect)settingButtonFrame {
    return self.settingButton.frame;
}

/** 平台币 */
- (UIButton *)platformCoin {
    if (!_platformCoin) {
        _platformCoin = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _platformCoin.frame = CGRectMake(view_width * 0.05, view_width / 30, view_width / 4, view_width / 12);
        _platformCoin.center = CGPointMake(_platformCoin.center.x, self.settingButton.center.y);
        [_platformCoin setTitle:@"%@" forState:(UIControlStateNormal)];
        [_platformCoin setBackgroundColor:RGBCOLOR(194, 202, 249)];
        [_platformCoin setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _platformCoin.layer.cornerRadius = 8;
        _platformCoin.layer.masksToBounds = YES;
        [_platformCoin setImage:SDK_IMAGE(@"SDK_PlatformCoin") forState:(UIControlStateNormal)];
    }
    return _platformCoin;
}




@end













