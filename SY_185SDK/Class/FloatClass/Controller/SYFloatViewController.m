//
//  SYFloatViewController.m
//  SY_185SDK
//
//  Created by 燚 on 2017/10/25.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SYFloatViewController.h"
#import "SYFloatViewModel.h"
#import "SDKModel.h"



#import "FSettingView.h"            //设置页面
#import "FRechargeRecordView.h"     //充值记录
#import "FAnnouncementView.h"       //公告页面
#import "FeedbackViewController.h"
#import "FeedbackNavigationController.h"

#import "BTWFloatModel.h"
#import "UserModel.h"

#import "SY185SDK.h"

#define ROOT_CONTROLLER [InfomationTool rootViewController]
#define SDK_MODEL [SDKModel sharedModel]
#define FLOAT_USEWINDOW ([SDKModel sharedModel].useWindow)
#define ViewModel SYFloatViewModel
#define FLOAT_CONTROLLER [SYFloatViewController sharedController]

#define FLOAT_RECT CGRectMake(0, 0, FLOATSIZE, FLOATSIZE)
#define FLOAT_ORI_CENTER CGPointMake(kSCREEN_WIDTH - FLOATSIZE, kSCREEN_HEIGHT - FLOATSIZE)
#define MENU_RECT CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT)

#ifdef DEBUG

#define BACKGROUNDCOLOR FLOAT_USEWINDOW ? RGBACOLOR(0, 0, 200, 150) : RGBACOLOR(200, 0, 0, 150)

#else

#define BACKGROUNDCOLOR RGBACOLOR(111, 111, 111, 111)

#endif



typedef enum : NSUInteger {
    floatUp = 0,
    floatDown,
    floatLeft,
    floatRigth
} FloatDirection;

typedef enum : NSUInteger {
    settingView = 0,
    rechagreRecordView = 1,
    feedbackView,
    announcementView
} AccounvPresentView;



static UIWindow *appKeyWindow;

@interface SYFloatViewController ()<SelectViewDelegate,FAccountVeiwDelegate>


@property (nonatomic, assign) BOOL useWindow;

//sub views

/** 是否显示菜单 */
@property (nonatomic, assign) BOOL isShowMenu;




/** 公告控制器 */
//@property (nonatomic, strong) FAnnounceViewController *announceViewController;


/** ------------ */
/** 关闭按钮位置 */
@property (nonatomic, assign) CGRect closeButtonFrame;
/** 弹出那个页面 */
@property (nonatomic, assign) AccounvPresentView accountPresentView;
/** 弹出的位置 */
@property (nonatomic, assign) CGRect originFrame;


/** 关闭页面按钮 */
@property (nonatomic, strong) UIButton *closeSettingButton;
/** 设置页面 */
@property (nonatomic, strong) FSettingView *settingView;
/** 充值记录页面 */
@property (nonatomic, strong) FRechargeRecordView *rechargeRecordView;
/** 公告页面 */
@property (nonatomic, strong) FAnnouncementView *announcementView;
/** 问题反馈页面 */
@property (nonatomic, strong) UIView *feedbackView;
/** 客服 QQ */
@property (nonatomic, strong) UILabel *feddbackQQLabel;
/** 是否有响应 */
@property (nonatomic, assign) BOOL isResponds;


@property (nonatomic, strong) FeedbackNavigationController *feedBackNavigationController;


@end


static SYFloatViewController *controller = nil;
@implementation SYFloatViewController

+ (SYFloatViewController *)sharedController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (controller == nil) {
            controller = [[SYFloatViewController alloc] init];
        }
    });
    return controller;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeUserInterface];
        [self initializeDataSource];
    }
    return self;
}

- (void)initializeUserInterface {

    self.view.frame = FLOAT_RECT;

#ifdef DEBUG
    self.view.backgroundColor = BACKGROUNDCOLOR;
#else
    self.view.backgroundColor = [UIColor clearColor];
#endif
//    [self.view addSubview:self.closeBtn];
    self.view.layer.masksToBounds = YES;

    [self.view addSubview:self.floatButton];

    if (!FLOAT_USEWINDOW) {
        self.view.layer.cornerRadius = FLOATSIZE / 2;
        self.view.layer.masksToBounds = YES;
    }
    //添加手势
//    [self.view addGestureRecognizer:[self tap]];

}


- (void)initializeDataSource {
    _useWindow = FLOAT_USEWINDOW;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (_isShowMenu) {
        self.view.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - method
/** show float view */
+ (void)showFloatView {
//    if (FLOAT_CONTROLLER.useWindow) {
//        FLOAT_CONTROLLER.window.rootViewController = controller;
//        syLog(@"befor key window  === %@", [UIApplication sharedApplication].keyWindow);
//        appKeyWindow = [UIApplication sharedApplication].keyWindow;
//        [FLOAT_CONTROLLER.window makeKeyAndVisible];
//        [FLOAT_CONTROLLER.window resignKeyWindow];
//        [appKeyWindow makeKeyAndVisible];
//        syLog(@"after key window  === %@", [UIApplication sharedApplication].keyWindow);
//
//    } else {
//        [ROOT_CONTROLLER addChildViewController:controller];

//        [ROOT_CONTROLLER.view addSubview:controller.view];

//        [FLOAT_CONTROLLER didMoveToParentViewController:ROOT_CONTROLLER];
//    }
    FLOAT_CONTROLLER.view.center = FLOAT_ORI_CENTER;
    [[UIApplication sharedApplication].keyWindow addSubview:controller.view];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:controller.view];
}

+ (void)hideFloatView {
//    if (FLOAT_CONTROLLER.useWindow) {
//        [FLOAT_CONTROLLER.window resignKeyWindow];
//        FLOAT_CONTROLLER.window = nil;
//    } else {
//        [FLOAT_CONTROLLER willMoveToParentViewController:nil];
//        [FLOAT_CONTROLLER removeFromParentViewController];
//    }
    [FLOAT_CONTROLLER.view removeFromSuperview];
}

- (void)signOut {
    //变回浮标
    SDK_USERDEFAULTS_SAVE_OBJECT(@"1", @"isUserLogOut");

    [UserModel logOut];

    [self hideMenuView];

    [SYFloatViewController hideFloatView];

    if (self.delegate && [self.delegate respondsToSelector:@selector(userSignOut)]) {
        [self.delegate userSignOut];
    }
}

- (void)resignOut {
    //变回浮标
    SDK_USERDEFAULTS_SAVE_OBJECT(@"1", @"isUserLogOut");

    [UserModel logOut];

    [self hideMenuView];

    [SYFloatViewController hideFloatView];
}

#pragma mark - responds to Gesture Recognizer
/** 拖动的响应事件 */
- (void)handlePan:(UIPanGestureRecognizer *)sender {
//    [ViewModel handelPan:sender WithResultView:(FLOAT_USEWINDOW ? self.window : self.view)];
    [ViewModel handelPan:sender WithResultView:(self.view)];
}

/** 显示菜单 */
- (void)handleTap:(UITapGestureRecognizer *)sender {
    [self.view addSubview:self.closeBtn];
//    [ViewModel showFloatDetailViewWithController:self View:(FLOAT_USEWINDOW ? self.window : self.view)];
    [ViewModel showFloatDetailViewWithController:self View:(self.view)];
    _isShowMenu = YES;
}

/** 关闭菜单 */
- (void)hideMenuView {
    _isShowMenu = NO;
    [self.closeBtn removeFromSuperview];
//    [ViewModel hideFloatDetailViewWithController:self View:(FLOAT_USEWINDOW ? self.window : self.view)];
    [ViewModel hideFloatDetailViewWithController:self View:(self.view)];
}

/** 关闭页面 */ 
- (void)respondsToViewTap {
    [self hideMenuView];
}

#pragma mark - 监听屏幕旋转
/** 添加屏幕旋转监听事件 */
- (void)addobserver {

    UIDevice *device = [UIDevice currentDevice];
    [device beginGeneratingDeviceOrientationNotifications];

    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];

    [notification addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];

}

/** 监听屏幕的旋转 */
- (void)orientationChanged:(NSNotification *)note  {
//    [ViewModel screenRotatesWithController:self View:(FLOAT_USEWINDOW ? self.window : self.view)];
    [ViewModel screenRotatesWithController:self View:(self.view)];
}

#pragma mark - select view delegate
/** 选中的下标,切换对应的视图 */
- (void)didSelectBtnAtIndexPath:(NSInteger)idx {
    [ViewModel Controller:self didSelectIndex:idx allowSpped:_allowSpeed];
}

#pragma mark - responds To close accountChildView
//关闭账号页面弹出的子页面
- (void)respondsToCloseSettingButton:(UIButton *)button {
    switch (_accountPresentView) {
        case settingView: {
            [self.settingView removeAllChildViews];
            [self returnAccountPresentView:self.settingView];
            break;
        }
        case rechagreRecordView: {
            [self returnAccountPresentView:self.rechargeRecordView];
            break;
        }

        case feedbackView: {
            [self returnAccountPresentView:self.feedbackView];
            break;
        }
        case announcementView: {
            [self returnAccountPresentView:self.announcementView];
            break;
        }
        default: {
            [self.closeSettingButton removeFromSuperview];
            [self.settingView removeFromSuperview];
            [self.rechargeRecordView removeFromSuperview];
            [self.feedbackView removeFromSuperview];
            break;
        }
    }
}
/** 移除父视图动画封装 */
- (void)returnAccountPresentView:(UIView *)view {
    self.view.userInteractionEnabled = NO;
    [self.closeSettingButton setImage:SDK_IMAGE(@"SDK_Setting") forState:(UIControlStateNormal)];

    [UIView animateWithDuration:0.3 animations:^{
        view.frame = self.originFrame;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        [self.closeSettingButton removeFromSuperview];
        self.view.userInteractionEnabled = YES;
    }];
}

#pragma mark - accountView delegate
/** 设置按钮 */
- (void)FAccountViewController:(FAccountViewController *)accountVeiwController clickSettingButton:(UIButton *)button {
    if (_isResponds) {
        return;
    }
    _accountPresentView = settingView;
    [self.settingView removeAllChildViews];
    [self accountViewPresentChildView:self.settingView WithButtonFrame:button.frame];
}

/** 充值记录 */
- (void)FAccountViewController:(FAccountViewController *)accountVeiwController clickRechargeButton:(UIButton *)button {
    if (_isResponds) {
        return;
    }
    _accountPresentView = rechagreRecordView;

    [self.rechargeRecordView reFresh];
    [self accountViewPresentChildView:self.rechargeRecordView WithButtonFrame:button.frame];
}

/** 问题反馈 */
- (void)FAccountViewController:(FAccountViewController *)accountVeiwController clickFeedBackButton:(UIButton *)button {
    if (_isResponds) {
        return;
    }

#warning fedbck

    [self presentViewController:self.feedBackNavigationController animated:YES completion:nil];

//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.feedBackNavigationController animated:YES completion:^{
//
//    }];

//    _accountPresentView = feedbackView;
//    NSString *serviceQQ = [SDKModel sharedModel].qq;
//
//    if (!serviceQQ || serviceQQ.length < 4) {
//        serviceQQ = @"客服失联了- -!!!";
//    }
//
//    self.feddbackQQLabel.text = [NSString stringWithFormat:@"客服QQ : %@",serviceQQ];
//
//    [self accountViewPresentChildView:self.feedbackView WithButtonFrame:button.frame];


}

/** 公告 */
- (void)FAccountViewController:(FAccountViewController *)accountVeiwController clickAnnouncementButton:(UIButton *)button {
    if (_isResponds) {
        return;
    }
    _accountPresentView = announcementView;

    [self accountViewPresentChildView:self.announcementView WithButtonFrame:button.frame];
}

/** 显示子视图动画 */
- (void)accountViewPresentChildView:(UIView *)view WithButtonFrame:(CGRect )frame {
    if (_isResponds) {
        return;
    }
    _isResponds = YES;
    self.view.userInteractionEnabled = NO;

    self.closeSettingButton.frame = self.closeButtonFrame;
    view.frame = frame;
    self.originFrame = view.frame;

    [self.menuView addSubview:view];
    [self.menuView addSubview:self.closeSettingButton];

    [self.closeSettingButton setImage:SDK_IMAGE(@"SDK_Setting") forState:(UIControlStateNormal)];

    [UIView animateWithDuration:0.3 animations:^{

        view.frame = self.menuView.bounds;

    } completion:^(BOOL finished) {

        [self.closeSettingButton setImage:SDK_IMAGE(@"SYSDK_closeButton") forState:(UIControlStateNormal)];

        self.view.userInteractionEnabled = YES;
        [self.menuView bringSubviewToFront:self.closeSettingButton];
        _isResponds = NO;

    }];

}

#pragma mark - getter
/** 是否加速 */
- (void)setAllowSpeed:(BOOL)allowSpeed {
    _allowSpeed = allowSpeed;
    if (_allowSpeed) {
        self.selectView.btnNameArray = @[@"账号",@"礼包",@"加速",@"注销"];
    } else {
        self.selectView.btnNameArray = @[@"账号",@"礼包",@"注销"];
    }
    //    self.window.hidden = YES;
    //    self.view.hidden = YES;
}


#pragma mark - getter
- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] init];

        _window.bounds = FLOAT_RECT;
        _window.center = FLOAT_ORI_CENTER;
        _window.backgroundColor = [UIColor clearColor];

        _window.layer.cornerRadius = FLOATSIZE / 2;
        _window.layer.masksToBounds = YES;

        _window.windowLevel = GM_WINDOW_LEVEL;

    }
    return _window;
}

/** 悬浮窗按钮 */
- (UIImageView *)floatButton {
    if (!_floatButton) {
        _floatButton = [[UIImageView alloc] init];
        _floatButton.frame = FLOAT_RECT;

        _floatButton.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_floatButton addGestureRecognizer:pan];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_floatButton addGestureRecognizer:tap];
        _floatButton.image = SDK_IMAGE(@"SDK_float");
    }
    return _floatButton;
}

- (UIView *)BackGroundView {
    if (!_BackGroundView) {
        _BackGroundView = [[UIView alloc] initWithFrame:MENU_RECT];
        _BackGroundView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
        _BackGroundView.backgroundColor = [UIColor whiteColor];
    }
    return _BackGroundView;
}

- (UITapGestureRecognizer *)tap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToViewTap)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    return tap;
}

/** 菜单视图 */
- (UIView *)menuView {
    if (!_menuView) {

        _menuView = [[UIView alloc] initWithFrame:MENU_RECT];
        _menuView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);


        _menuView.backgroundColor = [UIColor whiteColor];
        _menuView.layer.borderWidth = 1.f;
        _menuView.layer.borderColor = LINECOLOR.CGColor;
        _menuView.layer.cornerRadius = FLOATSIZE / 2;
        _menuView.layer.masksToBounds = YES;

        [self addChildViewController:self.accountViewController];
        self.currentController = self.accountViewController;

        [_menuView addSubview:self.accountViewController.view];
        [_menuView addSubview:self.selectView];
        
        
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"M185Config" ofType:@"plist"]];
        if (dict) {
            NSNumber *debug = (NSNumber *)dict[@"Debug"];
            if (debug.boolValue) {
                UIButton *switchButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
                switchButton.frame = CGRectMake(20, 20, 50, 30);
                [switchButton setTitle:@"切换账号" forState:(UIControlStateNormal)];
                switchButton.backgroundColor = [UIColor blackColor];
                [switchButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                [switchButton addTarget:self action:@selector(respondsToSwitchButton) forControlEvents:(UIControlEventTouchUpInside)];
                [switchButton sizeToFit];
                [_menuView addSubview:switchButton];
            }
        }
    }
    return _menuView;
}

- (void)respondsToSwitchButton {
    [SY185SDK signOut];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SY185SDK showLoginView];
    });
    
    [UserModel currentUser].switchAccount = YES;
}


/** 菜单视图的选择器 */
- (FloatSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[FloatSelectView alloc] initWithFrame:CGRectMake(0, FLOAT_MENU_HEIGHT - FLOAT_MENU_WIDTH / 4,FLOAT_MENU_WIDTH,FLOAT_MENU_WIDTH / 4) WithBtnArray:@[@"账号",@"礼包",@"注销"]];
        _selectView.delegate = self;
    }
    return _selectView;
}

/** 关闭按钮(遮盖在最底部,透明的) */
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _closeBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [_closeBtn addTarget:self action:@selector(hideMenuView) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}

/** 账号视图管理器 */
- (FAccountViewController *)accountViewController {
    if (!_accountViewController) {
        _accountViewController = [[FAccountViewController alloc] init];
        _accountViewController.delegate = self;
    }
    return _accountViewController;
}

/** 礼包视图管理器 */
- (FPacksViewController *)packsViewController {
    if (!_packsViewController) {
        _packsViewController = [[FPacksViewController alloc] init];
    }
    return _packsViewController;
}

/** 加速页面 */
- (FSpeedViewController *)speedViewController {
    if (!_speedViewController) {
        _speedViewController = [[FSpeedViewController alloc] init];
    }
    return _speedViewController;
}

#pragma mark - ================================================================
/** 关闭按钮的视图 */
- (CGRect)closeButtonFrame {
    return self.accountViewController.settingButtonFrame;
}

/** 设置页面 */
- (FSettingView *)settingView {
    if (!_settingView) {
        _settingView = [[FSettingView alloc] init];
    }
    return _settingView;
}


/** 充值记录页面 */
- (FRechargeRecordView *)rechargeRecordView {
    if (!_rechargeRecordView) {
        _rechargeRecordView = [[FRechargeRecordView alloc] init];
    }
    return _rechargeRecordView;
}

/** 问题反馈页面 */
- (UIView *)feedbackView {
    if (!_feedbackView) {
        _feedbackView = [self creatChildViewWithTitle:@"问题反馈"];

        [_feedbackView addSubview:self.feddbackQQLabel];

    }
    return _feedbackView;
}

/** 公告 */
- (FAnnouncementView *)announcementView {
    if (!_announcementView) {
        _announcementView = [[FAnnouncementView alloc] init];
    }
    return _announcementView;
}

/** 客服 QQ */
- (UILabel *)feddbackQQLabel {
    if (!_feddbackQQLabel) {
        _feddbackQQLabel = [[UILabel alloc] init];
        _feddbackQQLabel.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH, 44);
        _feddbackQQLabel.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT / 2);
        _feddbackQQLabel.text = @"客服QQ : 123456";
        _feddbackQQLabel.textAlignment = NSTextAlignmentCenter;
        _feddbackQQLabel.textColor = TEXTCOLOR;
        _feddbackQQLabel.font = [UIFont systemFontOfSize:22];
    }
    return _feddbackQQLabel;
}

- (UIView *)creatChildViewWithTitle:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1;
    view.layer.borderColor = LINECOLOR.CGColor;

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LINECOLOR;
    line.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH, 1);
    line.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_WIDTH / 15 + FLOAT_MENU_WIDTH / 8);

    [view addSubview:line];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(FLOAT_MENU_WIDTH / 4, FLOAT_MENU_WIDTH / 30, FLOAT_MENU_WIDTH / 2, FLOAT_MENU_WIDTH / 8);
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = BUTTON_GREEN_COLOR;
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.tag = 10086;

    [view addSubview:titleLabel];

    return view;
}

/** 关闭设置页面按钮 */
- (UIButton *)closeSettingButton {
    if (!_closeSettingButton) {
        _closeSettingButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_closeSettingButton addTarget:self action:@selector(respondsToCloseSettingButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeSettingButton;
}

- (FeedbackNavigationController *)feedBackNavigationController {
    if (!_feedBackNavigationController) {
        _feedBackNavigationController = [[FeedbackNavigationController alloc] initWithRootViewController:[FeedbackViewController new]];
    }
    return _feedBackNavigationController;
}


@end










