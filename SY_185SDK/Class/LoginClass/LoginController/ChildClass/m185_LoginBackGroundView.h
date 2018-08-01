//
//  m185_LoginBackGroundView.h
//  SY_185SDK
//
//  Created by 燚 on 2017/9/29.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SY_BindingPhoneView;
@class m185_LoginBackGroundView;
@class SY_BindingIDCardView;
@class SY_adPicImageView;
@class SY_AccountListView;

@protocol m185_LoginBackGroundViewDeleagte <NSObject>

/** 登录按钮的响应 */
- (void)m185_LoginBackGroundView:(m185_LoginBackGroundView *)viewController RespondsToLoginWituUserName:(NSString *)username PassWord:(NSString *)password;

/** 手机登录 */
- (void)m185_LoginBackGroundView:(m185_LoginBackGroundView *)viewController RespondsToLoginWitPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password;

/** 一键注册按钮的响应 */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToOneUpResgister:(NSString *)test;

/** 用户名注册 */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController
      respondsToRegisterUserName:(NSString *)username Password:(NSString *)password;

/** 手机号码注册 */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController
   respondsToRegisterPhoneNumber:(NSString *)phoneNumber Password:(NSString *)passowrd Code:(NSString *)code;

/** 自动登录 */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController
  respondsToAutoLoginWithAccount:(NSString *)account Password:(NSString *)password;

/** 手机绑定页面关闭 */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController
 respondsToCloseBindingPhoneView:(id)info;

/** 关闭广告页面 */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController
         respondsToCloseADPicView:(id)info;

/** 关闭账号列表 */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController closeAccountListView:(id)info;
/** 登录 子账号  */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToLoginSuccess:(NSDictionary *)content;



@end

@interface m185_LoginBackGroundView : UIView



@property (nonatomic, weak) id<m185_LoginBackGroundViewDeleagte> delegate;


/** 显示一键登录页面 */
- (void)showOneUpRegisterViewWithUserName:(NSString *)username Password:(NSString *)password;

/** 隐藏其他页面 */
- (void)hideOtherView;

/** 设置账号 */
- (void)setUsername:(NSString *)username;

/** 设置密码 */
- (void)setPassWord:(NSString *)passWord;

/** 设置手机登录 */
- (void)setPhoneNumber:(NSString *)phoneNumber;

/** 加载自动登录页面 */
- (void)addAutoLoginView;

/** 移除自动登录页面 */
- (void)removeAutoLoginView;

/** 释放第一响应 */
- (void)inputResignFirstResponds;

/** 登陆后的绑定手机页面 */
@property (nonatomic, strong) SY_BindingPhoneView *bingdingPhoneView;

/** 绑定身份证页面 */
@property (nonatomic, strong) SY_BindingIDCardView *bindingIDCardView;

/** 广告页 */
@property (nonatomic, strong) SY_adPicImageView *adPicImageView;

/** 账号列表页 */
@property (nonatomic, strong) SY_AccountListView *accountListView;
@property (nonatomic, strong) NSArray *showArray;
@property (nonatomic, strong) NSString *token;

/** 显示手机登录 */
- (void)showPhoneLogin:(BOOL)showPhone;



@end









