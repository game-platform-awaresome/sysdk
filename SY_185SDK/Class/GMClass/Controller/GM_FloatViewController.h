//
//  GM_FloatViewController.h
//  SY_GMSDK
//
//  Created by 燚 on 2017/10/12.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GM_ViewModel.h"
@class GM_DetailView;
@class GM_PropsListView;
@class GM_PropsNumView;
@class GM_FloatViewController;

@protocol FloatControllerDelegate <NSObject>

/** 开通 GM 权限 */
- (void)FloatController:(GM_FloatViewController *)controller openGmPermissionsWithDict:(NSDictionary *)dict;

- (void)FloatController:(GM_FloatViewController *)controller sendProposSuccessWithInfo:(NSDictionary *) dict;

@end

@interface GM_FloatViewController : UIViewController


@property (nonatomic, strong) UIImageView *floatButton;
@property (nonatomic, strong) UIButton *tapButton;

/** 详细页面显示前后的 center */
@property (nonatomic, assign) CGPoint oriPoint;

@property (nonatomic, weak) id<FloatControllerDelegate> delegate;

/** View */
@property (nonatomic, strong) GM_DetailView *detailView;
@property (nonatomic, strong) GM_PropsListView *propListView;
@property (nonatomic, strong) GM_PropsNumView *propNumView;

/** 单例控制器 */
+ (GM_FloatViewController *)sharedController;

/** 显示浮窗 */
+ (void)showFLoatView;

/** 刷新数据 */
+ (void)reloadGmData;

/** logOut */
+ (void)logOut;


@end



