//
//  GM_ViewModel.m
//  SY_GMSDK
//
//  Created by 燚 on 2017/10/13.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "GM_ViewModel.h"
#import "GM_FloatViewController.h"
#import "GM_DetailView.h"


//视图的宽和高
#define VIEW_WIDTH view.bounds.size.width
#define VIEW_HEIGHT view.bounds.size.height
#define Vertical_Screen (kSCREEN_HEIGHT > kSCREEN_WIDTH ? YES : NO)
#define CONTROLLER_USERINTERFACE_NO  controller.view.userInteractionEnabled = NO
#define CONTROLLER_USERINTERFACE_YES controller.view.userInteractionEnabled = YES
#define ControllerView  controller.view
#define DetailView controller.detailView
#define FloatButton controller.floatButton
#define SDK_MODEL [GM_SDKModel sharedModel]

typedef enum : NSUInteger {
    floatUp = 0,
    floatDown,
    floatLeft,
    floatRigth
} FloatDirection;


@implementation GM_ViewModel

#pragma mark = root view controller
+ (UIViewController *)rootViewController {
    if ([GM_SDKModel sharedModel].useWindow) {
        return [GM_ViewModel rooViewControllerWithWindow:[GM_ViewModel windowWithWindowLevel:SDK_WINDOW_LEVEL]];
    } else {
        return [GM_ViewModel rooViewControllerWithWindow:[GM_ViewModel windowWithWindowLevel:GAME_WINDOW_LEVEL]];
    }
}

+ (UIViewController *)gameViewController {
    return [GM_ViewModel rooViewControllerWithWindow:[GM_ViewModel windowWithWindowLevel:GAME_WINDOW_LEVEL]];
}

+ (UIWindow *)windowWithWindowLevel:(UIWindowLevel)level {

    NSArray<UIWindow *> *windows = [[UIApplication sharedApplication] windows];

    if (windows == nil || windows.count == 0) {
        return nil;

    } else if (windows.count == 1) {

        return windows[0].windowLevel == level ? windows[0] : [[UIApplication sharedApplication] keyWindow];

    } else {

        UIWindow *window = [[UIApplication sharedApplication] keyWindow];

        if (window.windowLevel != level) {
            for (UIWindow * tmpWin in windows) {
                if (tmpWin.windowLevel == level) {
                    window = tmpWin;
                    break;
                }
            }
        }

        return window;
    }
}

+ (UIViewController *)rooViewControllerWithWindow:(UIWindow *)window {

    UIViewController *result = nil;

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

+ (UIView *)gameView {
    return [GM_ViewModel windowWithWindowLevel:GAME_WINDOW_LEVEL].rootViewController.view;
}

+ (void)showAlertMessage:(NSString *)message dismissTime:(float)second dismiss:(void (^)(void))dismiss  {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];

    [[GM_ViewModel rootViewController] presentViewController:alertController animated:YES completion:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:^{
            if (dismiss) {
                dismiss();
            }
        }];
    });
}

/** 获取 sdk bundle */
+ (NSBundle *)getBundle {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[GM_ViewModel class]] pathForResource:@"SY_GMSDK" ofType:@"framework"]];
    return  bundle;
}

/** 获取 bundle 下的文件 */
+ (NSString *)getBundlePath: (NSString *) bundleName {
    NSBundle *myBundle = [GM_ViewModel getBundle];

    if (myBundle && bundleName) {
        return [[myBundle resourcePath] stringByAppendingPathComponent: bundleName];
    }

    return nil;
}

#pragma mark  -  wait animation
/** 开始等待动画 */
+ (void)startAinmationWithView {
    UIViewController *vc = [GM_ViewModel rootViewController];
    if (!vc) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [GM_ViewModel startAinmationWithView];
        });
    } else {
        [GM_ViewModel animationBack].frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [GM_ViewModel animationView].center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
        [vc.view addSubview:[GM_ViewModel animationBack]];
        [[GM_ViewModel animationView] startAnimating];
    }
}

/** 开始等待动画 */
+ (void)startWaitAnimation {
    if ([GM_SDKModel sharedModel].isInit) {
        [GM_ViewModel startAinmationWithView];
    } else {
        [GM_ViewModel stopWaitAnimation];
    }
}

/** 结束等待动画 */
+ (void)stopWaitAnimation {
    [[GM_ViewModel animationBack] removeFromSuperview];
    [[GM_ViewModel animationView] stopAnimating];
}


//动画背景
static UIView *_animationBack = nil;
+ (UIView *)animationBack {
    if (!_animationBack) {
        _animationBack = [[UIView alloc] init];
        _animationBack.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        _animationBack.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.2];
        [_animationBack addSubview:[GM_ViewModel animationView]];
    }
    return _animationBack;
}

static UIImageView *_animationView = nil;
+ (UIImageView *)animationView {
    if (!_animationView) {
        _animationView = [[UIImageView alloc] init];
        _animationView.bounds = CGRectMake(0, 0, 44, 44);
        _animationView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);

        NSMutableArray<UIImage *> *imageArray = [NSMutableArray array];

        for (NSInteger i = 1; i <= 12; i++) {

            NSString *str = [NSString stringWithFormat:@"GM_Animation%ld",(long)i];

            UIImage *image = SDK_IMAGE(str);
            if (image) {

                [imageArray addObject:image];
            }
        }

        _animationView.animationImages = imageArray;
        _animationView.animationDuration = 0.8;
        _animationView.animationRepeatCount = 1111111;
    }
    return _animationView;
}


#pragma mark - set detail infomation
+ (void)setDetailInfomationWithDetailView:(GM_DetailView *)view {
    view.roleNameLabel.text = [NSString stringWithFormat:@"%@",SDK_MODEL.role_name];
    view.serveridTitle.text = [NSString stringWithFormat:@"区服: %@",SDK_MODEL.serverid];
    view.dataArray = SDK_MODEL.GM_Authority_List;
    view.prop_num = @"1";
}

#pragma mark - handel pan
+ (void)handelPan:(UIPanGestureRecognizer *)sender WithResultView:(UIView *)view {

    //返回在横坐标上、纵坐标上拖动了多少像素
    CGPoint point = [sender translationInView:[GM_ViewModel gameView]];

    CGFloat centerX = 0;
    CGFloat centerY = 0;

    centerX = view.center.x + point.x;
    centerY = view.center.y + point.y;

    CGFloat KWidth = kSCREEN_WIDTH;
    CGFloat KHeight = kSCREEN_HEIGHT;

    //确定特殊的centerY
    if (centerY - FLOATSIZE / 2 < 0 ) {
        centerY = FLOATSIZE / 2;
    }

    if (centerY + FLOATSIZE / 2 > KHeight ) {
        centerY = KHeight - FLOATSIZE / 2;
    }

    //确定特殊的centerX
    if (centerX - FLOATSIZE / 2 < 0) {
        centerX = FLOATSIZE / 2;
    }
    if (centerX + FLOATSIZE / 2 > KWidth) {
        centerX = KWidth - FLOATSIZE / 2;
    }

    //设置悬浮窗的边界

   view.center = CGPointMake(centerX, centerY);

    if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        //判断是是否在边缘(在边缘的话隐藏)
        [GM_ViewModel checkFloatBorderWithView:view];
    }

    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [sender setTranslation:CGPointMake(0, 0) inView:[GM_ViewModel gameView]];
}

/** 检查是否在边界范围 */
+ (void)checkFloatBorderWithView:(UIView *)view {
    if (view.center.x <= FLOATSIZE / 2 + 10) {
        [GM_ViewModel hideFloatBtn:floatLeft WithView:view];
    } else if (view.center.x >= kSCREEN_WIDTH - FLOATSIZE / 2 - 10) {
        [GM_ViewModel hideFloatBtn:floatRigth WithView:view];
    } else if (view.center.y <= FLOATSIZE / 2 + 10) {
//        [GM_ViewModel hideFloatBtn:floatUp WithView:view];
    } else if (view.center.y >= kSCREEN_HEIGHT - FLOATSIZE / 2 - 10) {
//        [GM_ViewModel hideFloatBtn:floatDown WithView:view];
    }
}

/** 判断悬浮窗是否在边界,如果在,隐藏半个悬浮窗 */
+ (void)hideFloatBtn:(FloatDirection)direction WithView:(UIView *)view {
    switch (direction) {
        case floatUp: {
            [UIView animateKeyframesWithDuration:0.5 delay:0.1 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                CGPoint center = view.center;
                center.y = 0;
                view.center = center;
            } completion:nil];
            break;
        }
        case floatDown: {
            [UIView animateKeyframesWithDuration:0.5 delay:0.1 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                CGPoint center = view.center;
                center.y = kSCREEN_HEIGHT;
                view.center = center;
            } completion:nil];
            break;
        }
        case floatLeft: {
            [UIView animateKeyframesWithDuration:0.5 delay:0.1 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                CGPoint center = view.center;
                center.x = 0;
                view.center = center;
            } completion:nil];
            break;
        }
        case floatRigth: {
            [UIView animateKeyframesWithDuration:0.5 delay:0.1 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                CGPoint center = view.center;
                center.x = kSCREEN_WIDTH;
                view.center = center;
            } completion:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 显示 GM 详细页面
+ (void)showGMDetailViewWithController:(GM_FloatViewController *)controller View:(UIView *)view {
    //清楚 detailview 中数据
    DetailView.prop_id = @"";
    DetailView.prop_name = @"请选择";
    
    controller.oriPoint = view.center;
    CONTROLLER_USERINTERFACE_NO;
    
    [FloatButton removeFromSuperview];
    [ControllerView addSubview:DetailView];
    CGRect frame = DetailView.frame;
    DetailView.frame = CGRectMake(0, 0, FLOATSIZE, FLOATSIZE);
    ControllerView.backgroundColor = RGBACOLOR(55, 55, 55, 55);
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        view.layer.cornerRadius = 0;
        ControllerView.layer.cornerRadius = 0;
        DetailView.frame = frame;
    } completion:^(BOOL finished) {
        CONTROLLER_USERINTERFACE_YES;
    }];
}

+ (void)hideGMDetailViewWithController:(GM_FloatViewController *)controller View:(UIView *)view {

    CONTROLLER_USERINTERFACE_NO;
    [DetailView removeFromSuperview];
    ControllerView.backgroundColor = RGBACOLOR(246, 206, 83, 111);
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = CGRectMake(0, 0, GM_FLOATSIZE, GM_FLOATSIZE_HEIGHT);
        DetailView.frame = CGRectMake(0, 0, GM_FLOATSIZE, GM_FLOATSIZE_HEIGHT);
//        view.layer.cornerRadius = GM_FLOATSIZE / 2;
//        ControllerView.layer.cornerRadius = GM_FLOATSIZE / 2;
        view.center = controller.oriPoint;
    } completion:^(BOOL finished) {
        [ControllerView addSubview:FloatButton];
        ControllerView.backgroundColor = [UIColor clearColor];
        CONTROLLER_USERINTERFACE_YES;
    }];
}


#pragma mark - layout subviews
+ (void)layoutBackViewRotation:(GM_DetailView *)view WithController:(GM_FloatViewController *)controller {

    if (Vertical_Screen) {

        [GM_ViewModel layoutVerticalScreenWithView:view];

    } else {

        [GM_ViewModel layoutHorizontalScreenWithView:view];
    }

    [GM_ViewModel layoutGeneralScreenWithView:view];

//    controller.floatButton.frame = CGRectMake(0, 0, FLOATSIZE, FLOATSIZE_HEIGHT);
//
//    [controller.view bringSubviewToFront:controller.floatButton];

}

/** 竖屏适配 */
+ (void)layoutVerticalScreenWithView:(GM_DetailView *)view {
    
    view.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.95, kSCREEN_HEIGHT * 0.9);

    view.tableView.frame = CGRectMake(0, k_HEIGHT / 10 + 10, VIEW_WIDTH, VIEW_HEIGHT / 2);

    //发送按钮
    CGFloat numberY = VIEW_HEIGHT / 10 * 6 + 10;
    view.sendButton.center = CGPointMake(VIEW_WIDTH / 2, numberY + (VIEW_HEIGHT - numberY) / 3 * 2);
    view.sendButton.bounds = CGRectMake(0, 0, VIEW_WIDTH / 2, k_WIDTH / 10);

    /** --------------------------------------- */
    view.selectPropsView.frame = CGRectMake(0, CGRectGetMaxY(view.tableView.frame) + 10, VIEW_WIDTH, k_WIDTH / 8);

    //选择视图
    view.selectPropsimageView.center = CGPointMake(k_WIDTH / 15, k_WIDTH / 16);
    view.selectPropsTitle.frame = CGRectMake(CGRectGetMaxX(view.selectPropsimageView.frame), 0, view.selectPropsNumView.frame.size.width / 3, k_WIDTH / 8);

    view.selectPropsFooter.center = CGPointMake(view.selectPropsView.frame.size.width - k_WIDTH / 15, k_WIDTH / 16);
    CGFloat width = view.selectPropsView.bounds.size.width;
    view.selectPropsName.frame = CGRectMake(width / 2, 0, width / 2 - k_WIDTH / 15 - k_WIDTH / 40, k_WIDTH / 8);


    //数量视图
    view.selectPropsNumTitle.center = CGPointMake(k_WIDTH / 8, k_WIDTH / 16);
    view.selectPropsNumLabel.center = CGPointMake(view.selectPropsNumView.bounds.size.width / 8 * 7, k_WIDTH / 16);

    //分割线
    view.separaLine.hidden = YES;
    /** --------------------------------------- */
    view.selectPropsNumView.frame = CGRectMake(0, CGRectGetMaxY(view.selectPropsView.frame) + 10, VIEW_WIDTH, k_WIDTH / 8);
}

/** 横屏适配 */
+ (void)layoutHorizontalScreenWithView:(GM_DetailView *)view {

    view.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.9, kSCREEN_HEIGHT * 0.95);

    view.tableView.frame = CGRectMake(0, k_HEIGHT / 10 + 8, VIEW_WIDTH, VIEW_HEIGHT / 10 * 5);

    /** --------------------------------------- */
    //发送按钮
    view.sendButton.bounds = CGRectMake(0, 0, VIEW_WIDTH / 2, k_WIDTH / 10);
    view.sendButton.center = CGPointMake(VIEW_WIDTH / 2, VIEW_HEIGHT - 30);

    /** --------------------------------------- */
    view.selectPropsView.frame = CGRectMake(0, CGRectGetMaxY(view.tableView.frame) + 5, VIEW_WIDTH / 2, k_WIDTH / 10);

    //选择视图
    view.selectPropsimageView.center = CGPointMake(k_WIDTH / 15, k_WIDTH / 20);
    view.selectPropsTitle.frame = CGRectMake(CGRectGetMaxX(view.selectPropsimageView.frame), 0, view.selectPropsNumView.frame.size.width / 3, k_WIDTH / 10);

    //数量视图
    view.selectPropsFooter.center = CGPointMake(view.selectPropsView.frame.size.width - k_WIDTH / 15, k_WIDTH / 20);
    CGFloat width = view.selectPropsView.bounds.size.width;
    view.selectPropsName.frame = CGRectMake(width / 2, 0, width / 2 - k_WIDTH / 15 - k_WIDTH / 40, k_WIDTH / 10);


    view.selectPropsNumTitle.center = CGPointMake(k_WIDTH / 8, k_WIDTH / 20);
    view.selectPropsNumLabel.center = CGPointMake(view.selectPropsNumView.bounds.size.width / 8 * 7, k_WIDTH / 20);

    //分割线
    view.separaLine.hidden = NO;
    view.separaLine.center = CGPointMake(view.selectPropsView.frame.size.width - 1, k_WIDTH / 20);

    /** --------------------------------------- */
    view.selectPropsNumView.frame = CGRectMake(VIEW_WIDTH / 2, CGRectGetMaxY(view.tableView.frame) + 5, VIEW_WIDTH / 2, k_WIDTH / 10);
}

+ (void)layoutGeneralScreenWithView:(GM_DetailView *)view {
    //tableview
    view.sectionLabel.frame = CGRectMake(0, 0, VIEW_WIDTH, k_WIDTH / 8);

    //关闭按钮
    view.titleView.frame = CGRectMake(0, 0, VIEW_WIDTH, k_HEIGHT / 10);
    view.titleImage.center = CGPointMake(k_WIDTH / 15 , k_HEIGHT / 20);

    view.roleNameTitle.frame = CGRectMake(CGRectGetMaxX(view.titleImage.frame), 0, view.roleNameTitle.bounds.size.width, k_HEIGHT / 10);
    view.roleNameLabel.frame = CGRectMake(CGRectGetMaxX(view.roleNameTitle.frame), 0, VIEW_WIDTH / 3 * 2 - CGRectGetMaxX(view.roleNameTitle.frame), k_HEIGHT / 10);
    
    view.serveridTitle.frame = CGRectMake(VIEW_WIDTH / 2 + k_WIDTH * 0.12, 0, VIEW_WIDTH / 4, k_HEIGHT / 10);

    view.closeButton.center =  CGPointMake(VIEW_WIDTH - k_HEIGHT * 0.05, k_HEIGHT * 0.05);
    
    view.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
}




@end




















