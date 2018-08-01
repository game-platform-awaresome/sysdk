//
//  GM_ViewModel.h
//  SY_GMSDK
//
//  Created by 燚 on 2017/10/13.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GM_SDKModel.h"

@class GM_FloatViewController;

@interface GM_ViewModel : NSObject

/** 根视图 */
+ (UIViewController *)rootViewController;

+ (UIViewController *)gameViewController;
/** 游戏页面 */
+ (UIView *)gameView;

/** 获取路径下的文件 */
+ (NSString *)getBundlePath:(NSString *)bundleName;

/** 设置相关数据 */
+ (void)setDetailInfomationWithDetailView:(UIView *)view;

/** 显示提示框 */
+ (void)showAlertMessage:(NSString *)message dismissTime:(float)second dismiss:(void(^)(void))dismiss;

/** 悬浮窗拖拽处理 */
+ (void)handelPan:(UIPanGestureRecognizer *)sender WithResultView:(UIView *)view;

/** 显示 GM 详细页面 */
+ (void)showGMDetailViewWithController:(GM_FloatViewController *)controller View:(UIView *)view;

/** 隐藏 GM 详细页面 */
+ (void)hideGMDetailViewWithController:(GM_FloatViewController *)controller View:(UIView *)view;

//适配背景视图的旋转
+ (void)layoutBackViewRotation:(UIView *)view WithController:(UIViewController *)controller;

/** 开始等待动画 */
+ (void)startWaitAnimation;
/** 结束等待动画 */
+ (void)stopWaitAnimation;



@end











