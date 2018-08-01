//
//  FSpeedViewController.m
//  BTWan
//
//  Created by 石燚 on 2017/9/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FSpeedViewController.h"

@interface FSpeedViewController ()

/** 减速按钮 */
@property (nonatomic, strong) UIButton *speedCut;

/** 加速按钮 */
@property (nonatomic, strong) UIButton *speedUp;

/** 显示条背景 */
@property (nonatomic, strong) UIView *speedBackgroudView;
/** 显示条 */
@property (nonatomic, strong) UIView *speedBackProgress;
/** 显示倍数 */
@property (nonatomic, strong) UILabel *speedLabel;

/** 游戏倍数 */
@property (nonatomic, assign) NSInteger speed;

/** 分割线 */
@property (nonatomic, strong) UIView *line;
/** 标题 */
@property (nonatomic, strong) UILabel *ViewTitle;
/** 提示标签 */
@property (nonatomic, strong) UILabel *remindLabel;


@end

@implementation FSpeedViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.speed = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}


- (void)initUserInterface {
    self.view.frame = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT - (FLOAT_MENU_WIDTH / 4));

    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.line];
    [self.view addSubview:self.ViewTitle];
    [self.view addSubview:self.speedBackgroudView];
    [self.view addSubview:self.speedBackProgress];
    [self.view addSubview:self.speedCut];
    [self.view addSubview:self.speedUp];
    [self.view addSubview:self.speedLabel];
    [self.view addSubview:self.remindLabel];
    [self setUpSpeedProgress];
}


#pragma mark - responds
- (void)respondsToSpeedUp {
    if (_speed == 10) {

    } else {
        self.speed++;
    }
}

- (void)respondsToSpeedCut {
    if (_speed == 0) {

    } else {
        self.speed--;
    }
}

- (void)setUpSpeedProgress {
    if (_speed == 0) {
        CGRect rect = self.speedBackProgress.frame;
        rect.size.width = 0;
        self.speedBackProgress.frame = rect;
    } else {
        CGRect rect = self.speedBackProgress.frame;
        rect.size.width = _speed * FLOAT_MENU_WIDTH * 0.6 / 10;
        self.speedBackProgress.frame = rect;
    }
}

- (void)setSpeed:(NSInteger)speed {
    _speed = speed;
    if (_speed == 0) {
        self.speedLabel.text = [NSString stringWithFormat:@"0.5 倍"];
    } else {
        self.speedLabel.text = [NSString stringWithFormat:@"%ld 倍", (long)_speed];
    }
    [self setUpSpeedProgress];
}

#pragma mark - getter
- (UIView *)speedBackgroudView {
    if (!_speedBackgroudView) {
        _speedBackgroudView = [[UIView alloc] init];
        _speedBackgroudView.center = self.view.center;
        _speedBackgroudView.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH * 0.6, 10);
        _speedBackgroudView.backgroundColor = [UIColor grayColor];
        _speedBackgroudView.layer.cornerRadius = 5;
        _speedBackgroudView.layer.masksToBounds = YES;
    }
    return _speedBackgroudView;
}

- (UIView *)speedBackProgress {
    if (!_speedBackProgress) {
        _speedBackProgress = [[UIView alloc] init];
        _speedBackProgress.frame = CGRectMake(self.speedBackgroudView.frame.origin.x, self.speedBackgroudView.frame.origin.y, 0, 10);
        _speedBackProgress.backgroundColor = BUTTON_GREEN_COLOR;
        _speedBackProgress.layer.cornerRadius = 5;
        _speedBackProgress.layer.masksToBounds = YES;
    }
    return _speedBackProgress;
}

- (UIButton *)speedUp {
    if (!_speedUp) {
        _speedUp = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _speedUp.center = CGPointMake(FLOAT_MENU_WIDTH * 0.9, self.view.center.y);
        _speedUp.bounds = CGRectMake(0, 0, 30, 30);
//        _speedUp.backgroundColor = BLUE_DARK;
        [_speedUp addTarget:self action:@selector(respondsToSpeedUp) forControlEvents:(UIControlEventTouchUpInside)];
        [_speedUp setImage:SDK_IMAGE(@"speedUp") forState:(UIControlStateNormal)];
    }
    return _speedUp;
}

- (UIButton *)speedCut {
    if (!_speedCut) {
        _speedCut = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _speedCut.center = CGPointMake(FLOAT_MENU_WIDTH * 0.1, self.view.center.y);
        _speedCut.bounds = CGRectMake(0, 0, 30, 30);
//        _speedCut.backgroundColor = BLUE_DARK;
        [_speedCut addTarget:self action:@selector(respondsToSpeedCut) forControlEvents:(UIControlEventTouchUpInside)];
        [_speedCut setImage:SDK_IMAGE(@"speedCut") forState:(UIControlStateNormal)];
    }
    return _speedCut;
}

- (UILabel *)speedLabel {
    if (!_speedLabel) {
        _speedLabel = [[UILabel alloc] init];
        _speedLabel.bounds = CGRectMake(0, 0, 50, 15);
        _speedLabel.center = CGPointMake(FLOAT_MENU_WIDTH / 2, self.speedBackProgress.center.y - 30);
        _speedLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _speedLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, FLOAT_MENU_HEIGHT * 0.17, FLOAT_MENU_WIDTH, 2)];
        _line.backgroundColor = [UIColor grayColor];
    }
    return _line;
}

- (UILabel *)ViewTitle {
    if (!_ViewTitle) {
        _ViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT * 0.17 - 2)];
        _ViewTitle.textAlignment = NSTextAlignmentCenter;
        _ViewTitle.text = @"游戏加速器";
        _ViewTitle.font = [UIFont systemFontOfSize:22];
        _ViewTitle.textColor = BUTTON_GREEN_COLOR;
    }
    return _ViewTitle;
}

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, FLOAT_MENU_HEIGHT - (FLOAT_MENU_WIDTH / 4) - FLOAT_MENU_HEIGHT * 0.2, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT * 0.2)];
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.text = @"  温馨提示 : 请选择合适的加速倍数, \n  由于游戏服务器限制, 部分游戏可能加速失败.  ";
        _remindLabel.font = [UIFont systemFontOfSize:12];
        _remindLabel.textColor = [UIColor redColor];
        _remindLabel.numberOfLines = 0;
    }
    return _remindLabel;
}


@end
