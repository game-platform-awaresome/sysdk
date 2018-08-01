//
//  GM_FloatViewController.m
//  SY_GMSDK
//
//  Created by 燚 on 2017/10/12.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "GM_FloatViewController.h"
#import "GM_DetailView.h"
#import "GM_PropsListView.h"
#import "GM_PropsNumView.h"
#import "InfomationTool.h"

#define MODEL [GM_SDKModel sharedModel]
#define FLOAT_CONTROLLER [GM_FloatViewController sharedController]
#define ROOT_CONTROLLER [ViewModel rootViewController]
#define SDK_USEWINDOW MODEL.useWindow
#define ViewModel GM_ViewModel

//悬浮窗视图的相关尺寸
#define FLOAT_MENU_WIDTH WIDTH * 0.95
#define FLOAT_MENU_HEIGHT FLOAT_MENU_WIDTH

@interface GM_FloatViewController ()<GM_DetailViewDelegate, GMPropsListViewDelegate ,GMPropsNumViewDelegate>

@property (nonatomic, strong) UIWindow *window;

@end

static GM_FloatViewController *controller = nil;

@implementation GM_FloatViewController

+ (GM_FloatViewController *)sharedController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (controller == nil) {
            controller = [[GM_FloatViewController alloc] init];
        }
    });
    return controller;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initFLoatView];
    }
    return self;
}

- (void)initFLoatView {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.frame = CGRectMake(0, 0, GM_FLOATSIZE, GM_FLOATSIZE_HEIGHT);
    [self.view addSubview:self.floatButton];

}

+ (void)logOut {
    [[GM_SDKModel sharedModel] setAllPropertyWithDict:nil];
    [ViewModel setDetailInfomationWithDetailView:[GM_FloatViewController sharedController].detailView];
    [GM_FloatViewController hideFloatView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [ViewModel setDetailInfomationWithDetailView:self.detailView];
    //    __LOGFUNC__;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - show float
+ (void)showFLoatView {
    if (SDK_USEWINDOW) {
        [FLOAT_CONTROLLER.window makeKeyAndVisible];
    } else {
        FLOAT_CONTROLLER.view.center = CGPointMake(GM_FLOATSIZE / 2, kSCREEN_HEIGHT - GM_FLOATSIZE);
        [[ViewModel gameViewController] addChildViewController:FLOAT_CONTROLLER];
        [[ViewModel gameViewController].view addSubview:FLOAT_CONTROLLER.view];
//        [ROOT_CONTROLLER addChildViewController:FLOAT_CONTROLLER];
//        [ROOT_CONTROLLER.view addSubview:FLOAT_CONTROLLER.view];
        [FLOAT_CONTROLLER didMoveToParentViewController:[ViewModel gameViewController]];
    }
}

#pragma mark - hide float
+ (void)hideFloatView {
    if (SDK_USEWINDOW) {
        [FLOAT_CONTROLLER.window resignKeyWindow];
        FLOAT_CONTROLLER.window = nil;
    } else {
        [FLOAT_CONTROLLER willMoveToParentViewController:nil];
        [FLOAT_CONTROLLER.view removeFromSuperview];
        [FLOAT_CONTROLLER removeFromParentViewController];
    }
}

#pragma mark - handle pan
/** 拖动的响应事件 */
- (void)handlePan:(UIPanGestureRecognizer *)sender {
//    __LOGFUNC__;
    [ViewModel handelPan:sender WithResultView:(SDK_USEWINDOW ? self.window : self.view)];
}

#pragma mark - handel tap -- show detail GM view
/** 点击悬浮窗 */
- (void)handleTap:(UITapGestureRecognizer *)sender {
//    __LOGFUNC__;
    [ViewModel showGMDetailViewWithController:self View:(SDK_USEWINDOW ? self.window : self.view)];
    [GM_FloatViewController reloadGmData];
}

- (void)respondstToTopButton {
    [self handleTap:nil];
}

#pragma mark - close detail GM view
/** 关闭悬浮窗 */
- (void)respondsToCloseButton {
//    __LOGFUNC__;
    [ViewModel hideGMDetailViewWithController:self View:(SDK_USEWINDOW ? self.window : self.view)];
}

#pragma mark - reload data
/** 刷新页面 */
+ (void)reloadGmData {
    [GM_SDKModel initGMSDKWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            [GM_SDKModel sharedModel].GM_Authority_List = content[@"data"];
            [ViewModel setDetailInfomationWithDetailView:[GM_FloatViewController sharedController].detailView];
        } 
    }];
}

#pragma mark - layout SubViews
/** 适配 */ 
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [ViewModel layoutBackViewRotation:self.detailView WithController:self];
}

#pragma mark - detail view delegate
/** 关闭 GM 详细页面 */ 
- (void)detailView:(GM_DetailView *)view closeView:(id)info {
//    __LOGFUNC__;
    [self respondsToCloseButton];
}

/** 请求道具列表 */
- (void)detailView:(GM_DetailView *)view didSelectProposViewWithGearID:(NSString *)gear_id {
    WeakSelf;
    SDK_START_ANIMATION;
    [GM_SDKModel getGMSDKPropsListWithGearID:gear_id Completion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;
        if (success) {
            weakSelf.propListView.propsList = content[@"data"];
            [weakSelf.view addSubview:weakSelf.propListView];
        } else {
            SDK_MESSAGE(content[@"msg"]);
        }
    }];
}

/** 选择道具数量 */
- (void)detailView:(GM_DetailView *)view didSelectPropsNumViewWithInfo:(id)info {
    if (self.detailView.prop_id == nil || [self.detailView.prop_id isEqualToString:@""]) {
        SDK_MESSAGE(@"请选择道具");
        return;
    }
    [self.view addSubview:self.propNumView];
}

/** 发送道具 */
- (void)detailView:(GM_DetailView *)view sendPropsWithProp_id:(NSString *)prop_id Prop_num:(NSString *)prop_num {

    SDK_START_ANIMATION;
    [GM_SDKModel sendGMSDKPropsWithProp_id:prop_id Prop_num:prop_num Completion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;
        if (success) {
            SDK_MESSAGE(@"发送成功");
            [GM_SDKModel sharedModel].prop_id = prop_id;
            [GM_SDKModel sharedModel].gear_id = prop_num;
            if (self.delegate && [self.delegate respondsToSelector:@selector(FloatController:sendProposSuccessWithInfo:)]) {
                [self.delegate FloatController:self sendProposSuccessWithInfo:nil];
            }
        } else {
            SDK_MESSAGE(@"发送失败,请稍后尝试.");
        }
    }];

}

/** 开通 GM 权限 */
- (void)detailView:(GM_DetailView *)view openGmPermissionsWithDict:(NSDictionary *)dict {
    if (dict) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(FloatController:openGmPermissionsWithDict:)]) {
            [self.delegate FloatController:self openGmPermissionsWithDict:dict];
        }
    }
}

#pragma mark - props list view delegate
/** 选择道具 */
- (void)GMPropsListView:(GM_PropsListView *)propsListView didSelectPropsWithDict:(NSDictionary *)dict {
    if (dict == nil) {
        SDK_MESSAGE(@"未选择物品");
    } else {
        self.detailView.prop_id = dict[@"id"];
        self.detailView.prop_name = dict[@"name"];
    }
}

#pragma mark = props number view delegate
- (void)GMPropsNumView:(GM_PropsNumView *)view completeInputWithString:(NSString *)num {
    if (num && num.integerValue) {
        self.detailView.prop_num = num;
    }
}

#pragma mark - getter
- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - GM_FLOATSIZE, GM_FLOATSIZE, GM_FLOATSIZE)];
        _window.backgroundColor = [UIColor clearColor];
        _window.rootViewController = self;
        _window.windowLevel = GM_WINDOW_LEVEL;
    }
    return _window;
}

/** 悬浮窗按钮 */
- (UIImageView *)floatButton {
    if (!_floatButton) {
        _floatButton = [[UIImageView alloc] init];
        _floatButton.frame = CGRectMake(0, 0, GM_FLOATSIZE, GM_FLOATSIZE_HEIGHT);

        _floatButton.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_floatButton addGestureRecognizer:pan];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_floatButton addGestureRecognizer:tap];
        [_floatButton addSubview:self.tapButton];
        _floatButton.image = SDK_IMAGE(@"GM_float");
    }
    return _floatButton;
}

- (UIButton *)tapButton {
    if (!_tapButton) {
        _tapButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _tapButton.bounds = CGRectMake(0, 0, GM_FLOATSIZE, GM_FLOATSIZE);
        _tapButton.center = CGPointMake(GM_FLOATSIZE / 2, GM_FLOATSIZE_HEIGHT / 2);
        [_tapButton addTarget:self action:@selector(respondstToTopButton) forControlEvents:(UIControlEventTouchUpInside)];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_tapButton addGestureRecognizer:pan];

//        _tapButton.backgroundColor = [UIColor blackColor];
    }
    return _tapButton;
}

- (GM_DetailView *)detailView {
    if (!_detailView) {
        _detailView = [[GM_DetailView alloc] init];
        _detailView.delegate = self;
    }
    return _detailView;
}

- (GM_PropsListView *)propListView {
    if (!_propListView) {
        _propListView = [[GM_PropsListView alloc] init];
        _propListView.delegate = self;
    }
    return _propListView;
}

- (GM_PropsNumView *)propNumView {
    if (!_propNumView) {
        _propNumView = [[GM_PropsNumView alloc] init];
        _propNumView.delegate = self;
    }
    return _propNumView;
}




@end







