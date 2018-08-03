//
//  LoginController.h
//  SY_185SDK
//
//  Created by 燚 on 2017/9/29.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYBasicViewController.h"

@class LoginController;

@protocol LoginControllerDeleagete <NSObject>

- (void)loginController:(LoginController *)loginController loginSuccess:(BOOL)success withStatus:(NSDictionary *)dict;

@end

@interface LoginController : SYBasicViewController

@property (nonatomic, weak)     id<LoginControllerDeleagete>    delegate;
@property (nonatomic, assign)   BOOL                            isShow;
@property (nonatomic, assign)   BOOL                            useWindow;



+ (LoginController *)sharedController;

+ (BOOL)isInit;

/** 显示登录页面 */
+ (void)showLoginViewUseTheWindow:(BOOL)useWindow WithDelegate:(id<LoginControllerDeleagete>)delegate;


+ (void)hideLoginView;


@end
