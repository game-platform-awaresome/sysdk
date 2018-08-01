//
//  SYFloatViewModel.m
//  SY_185SDK
//
//  Created by 燚 on 2017/10/24.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SYFloatViewModel.h"
#import "SYFloatViewController.h"


//视图的宽和高
#define VIEW_WIDTH view.bounds.size.width
#define VIEW_HEIGHT view.bounds.size.height
#define Vertical_Screen (kSCREEN_HEIGHT > kSCREEN_WIDTH ? YES : NO)
#define CONTROLLER_USERINTERFACE_NO  controller.view.userInteractionEnabled = NO
#define CONTROLLER_USERINTERFACE_YES controller.view.userInteractionEnabled = YES
#define ControllerView  controller.view
#define MenuView controller.menuView
#define FloatButton controller.floatButton
#define SDK_MODEL [SDKModel sharedModel]
#define FLOAT_RECT CGRectMake(0, 0, FLOATSIZE, FLOATSIZE)

typedef enum : NSUInteger {
    floatUp = 0,
    floatDown,
    floatLeft,
    floatRigth
} FloatDirection;

@implementation SYFloatViewModel


/** 拖拽响应 */
+ (void)handelPan:(UIPanGestureRecognizer *)sender WithResultView:(UIView *)view {
    //返回在横坐标上、纵坐标上拖动了多少像素
    CGPoint point = [sender translationInView:[InfomationTool gameView]];

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
        [SYFloatViewModel checkFloatBorderWithView:view];
    }

    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [sender setTranslation:CGPointMake(0, 0) inView:[InfomationTool gameView]];
}

/** 检查是否在边界范围 */
+ (void)checkFloatBorderWithView:(UIView *)view {
    if (view.center.x <= FLOATSIZE / 2 + 10) {
        [SYFloatViewModel hideFloatBtn:floatLeft WithView:view];
    } else if (view.center.x >= kSCREEN_WIDTH - FLOATSIZE / 2 - 10) {
        [SYFloatViewModel hideFloatBtn:floatRigth WithView:view];
    } else if (view.center.y <= FLOATSIZE / 2 + 10) {
        //        [SYFloatViewModel hideFloatBtn:floatUp WithView:view];
    } else if (view.center.y >= kSCREEN_HEIGHT - FLOATSIZE / 2 - 10) {
        //        [SYFloatViewModel hideFloatBtn:floatDown WithView:view];
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



+ (void)showFloatDetailViewWithController:(SYFloatViewController *)controller View:(UIView *)view {
    controller.lastPoint = view.center;

    CONTROLLER_USERINTERFACE_NO;
    [FloatButton removeFromSuperview];
    CGRect frame = MenuView.frame;
    MenuView.frame = FLOAT_RECT;
    [ControllerView addSubview:MenuView];
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        view.layer.cornerRadius = 0;
        if (ControllerView != view) {
            ControllerView.frame = view.frame;
        }

        MenuView.layer.cornerRadius = (kSCREEN_WIDTH > 600 ? 20 : 15);
        view.layer.cornerRadius = 0;
        view.layer.masksToBounds = NO;

        MenuView.frame = frame;
    } completion:^(BOOL finished) {
        CONTROLLER_USERINTERFACE_YES;
    }];
}

+ (void)hideFloatDetailViewWithController:(SYFloatViewController *)controller View:(UIView *)view {

    CONTROLLER_USERINTERFACE_NO;
//    [ControllerView removeFromSuperview];
    CGRect frame = MenuView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = FLOAT_RECT;
        view.center = controller.lastPoint;

        if (ControllerView != view) {
            ControllerView.frame = FLOAT_RECT;
        }
        MenuView.layer.cornerRadius = FLOATSIZE / 2;
        view.layer.cornerRadius = FLOATSIZE / 2;
        view.layer.masksToBounds = YES;

        MenuView.frame = FLOAT_RECT;

    } completion:^(BOOL finished) {
        [ControllerView addSubview:FloatButton];
        [MenuView removeFromSuperview];
        MenuView.frame = frame;
        CONTROLLER_USERINTERFACE_YES;
    }];
}

/** 旋转屏幕 */ 
+ (void)screenRotatesWithController:(SYFloatViewController *)controller View:(UIView *)view {
    view.center = [SYFloatViewModel checkingCenterWithView:view];
    MenuView.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT);
    MenuView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
    controller.closeBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
}

/** 检查中心是否在显示的屏幕上 */
+ (CGPoint)checkingCenterWithView:(UIView *)view {
    CGPoint lastPoint = view.center;
    if (lastPoint.x > kSCREEN_WIDTH - FLOATSIZE / 2 ) {
        lastPoint.x = kSCREEN_WIDTH - FLOATSIZE / 2;
    }

    if (lastPoint.x < FLOATSIZE / 2) {
        lastPoint.x = FLOATSIZE / 2;
    }

    if (lastPoint.y > kSCREEN_HEIGHT - FLOATSIZE / 2) {
        lastPoint.y = kSCREEN_HEIGHT - FLOATSIZE / 2;
    }

    if (lastPoint.y < FLOATSIZE / 2) {
        lastPoint.y = FLOATSIZE / 2;
    }
    return lastPoint;
}

+ (void)Controller:(SYFloatViewController *)controller didSelectIndex:(NSInteger)idx allowSpped:(BOOL)allowSpped {

    if (allowSpped) {
        switch (idx) {
            case 0:
            {
                if (controller.currentController != controller.accountViewController) {
                    [SYFloatViewModel Controller:(SYFloatViewController *)controller replaceController:controller.currentController newController:controller.accountViewController];
                }
            }
                break;
            case 1:
            {
                if (controller.currentController != controller.packsViewController) {
                    [SYFloatViewModel Controller:(SYFloatViewController *)controller replaceController:controller.currentController newController:controller.packsViewController];
                }
            }
                break;
            case 2:
            {
                if (controller.currentController != controller.speedViewController) {
                    [SYFloatViewModel Controller:(SYFloatViewController *)controller replaceController:controller.currentController newController:controller.speedViewController];
                }
            }
                break;
            case 3: {
                [controller signOut];

                break;
            }
            default:
                break;
        }
    } else {
        switch (idx) {
            case 0:
            {
                if (controller.currentController != controller.accountViewController) {
                    [SYFloatViewModel Controller:(SYFloatViewController *)controller replaceController:controller.currentController newController:controller.accountViewController];
                }
            }
                break;
            case 1:
            {
                if (controller.currentController != controller.packsViewController) {
                    [SYFloatViewModel Controller:(SYFloatViewController *)controller replaceController:controller.currentController newController:controller.packsViewController];
                }
            }
                break;
            case 2: {
                [controller signOut];

                break;
            }
            default:
                break;
        }
    }
}


#pragma mark - 转换自控制器
+ (void)Controller:(SYFloatViewController *)controller
 replaceController:(UIViewController *)oldController
     newController:(UIViewController *)newController; {

    [controller addChildViewController:newController];

    //重置页面尺寸
    newController.view.frame = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT - (FLOAT_MENU_WIDTH / 4));

    [controller transitionFromViewController:oldController toViewController:newController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {

            [newController didMoveToParentViewController:controller];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            controller.currentController = newController;

        } else {
            controller.currentController = oldController;

        }
        [controller.menuView bringSubviewToFront:controller.selectView];
    }];
}



@end






