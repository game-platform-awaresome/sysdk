//
//  SYFloatViewModel.h
//  SY_185SDK
//
//  Created by 燚 on 2017/10/24.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SYFloatViewController;

@interface SYFloatViewModel : NSObject

/** 悬浮窗拖拽处理 */
+ (void)handelPan:(UIPanGestureRecognizer *)sender WithResultView:(UIView *)view;

/** 显示详细页面 */
+ (void)showFloatDetailViewWithController:(SYFloatViewController *)controller View:(UIView *)view;

/** 隐藏详细页面 */
+ (void)hideFloatDetailViewWithController:(SYFloatViewController *)controller View:(UIView *)view;


/** 屏幕旋转 */
+ (void)screenRotatesWithController:(SYFloatViewController *)controller View:(UIView *)view;

/** 切换选择器 */
+ (void)Controller:(SYFloatViewController *)controller didSelectIndex:(NSInteger)idx allowSpped:(BOOL)allowSpped;

+ (void)Controller:(SYFloatViewController *)controller replaceController:(UIViewController *)oldController newController:(UIViewController *)newController;



@end
