//
//  SYLoginViewController.h
//  SY_185SDK
//
//  Created by 燚 on 2018/8/2.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import "SYBasicViewController.h"


#define LoginViewController [SYLoginViewController sharedInstance]

@interface SYLoginViewController : SYBasicViewController

/** 登录页面是否显示 */
@property (nonatomic, assign)   BOOL    isShow;
/** 登录的回调 */
@property (nonatomic, strong)   void    (^loginResult)(BOOL success, NSDictionary *content);
/** 登出的回调 */
@property (nonatomic, strong)   void    (^logoutResult)(BOOL success, NSDictionary *content);


#pragma mark - method
/** 单利 */
+ (SYLoginViewController *)sharedInstance;

/** 显示登录页面 */
+ (void)showLoginView;
/** 隐藏登录页面 */
+ (void)hideLoginView;






@end

















