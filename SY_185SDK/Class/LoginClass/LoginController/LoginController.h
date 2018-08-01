//
//  LoginController.h
//  SY_185SDK
//
//  Created by 燚 on 2017/9/29.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginController;

@protocol LoginControllerDeleagete <NSObject>

- (void)loginController:(LoginController *)loginController loginSuccess:(BOOL)success withStatus:(NSDictionary *)dict;

@end

@interface LoginController : NSObject

@property (nonatomic, weak) id<LoginControllerDeleagete> delegate;

/** 是否使用窗口 */
@property (nonatomic, assign) BOOL useWindow;

+ (LoginController *)sharedController;

+ (BOOL)isInit;

/** 显示登录页面 */
+ (void)showLoginViewUseTheWindow:(BOOL)useWindow WithDelegate:(id<LoginControllerDeleagete>)delegate;

+ (void)hideLoginView;


@end
