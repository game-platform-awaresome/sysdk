//
//  SYFloatViewController.h
//  SY_185SDK
//
//  Created by 燚 on 2017/10/25.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAccountViewController.h"
#import "FPacksViewController.h"
#import "FAnnounceViewController.h"
#import "FSpeedViewController.h"
#import "FloatSelectView.h"
#import "FeedbackNavigationController.h"

@protocol SYfloatViewDelegate <NSObject>

- (void)userSignOut;

@end

@interface SYFloatViewController : UIViewController

@property (nonatomic, weak) id <SYfloatViewDelegate> delegate;

/** last center */ 
@property (nonatomic, assign) CGPoint lastPoint;

/** window */
@property (nonatomic, strong) UIWindow *window;
/** flaotButton */
@property (nonatomic, strong) UIImageView *floatButton;

//废弃
@property (nonatomic, strong) UIView *BackGroundView;

/** 关闭按钮 */
@property (nonatomic, strong) UIButton *closeBtn;
/** 菜单视图 */
@property (nonatomic, strong) UIView *menuView;
/** 菜单选项 */
@property (nonatomic, strong) FloatSelectView *selectView;

/** 是否显示加速页面 */
@property (nonatomic, assign) BOOL allowSpeed;

/** 当前子控制器 */
@property (nonatomic, strong) UIViewController *currentController;
/** 账号控制器 */
@property (nonatomic, strong) FAccountViewController *accountViewController;
/** 礼包控制器 */
@property (nonatomic, strong) FPacksViewController *packsViewController;
/** 加速控制器 */
@property (nonatomic, strong) FSpeedViewController *speedViewController;

@property (nonatomic, strong) FeedbackNavigationController *feedBackNavigationController;

/** 控制器 */ 
+ (SYFloatViewController *)sharedController;


+ (void)showFloatView;

+ (void)hideFloatView;

- (void)signOut;

- (void)resignOut;

@end
