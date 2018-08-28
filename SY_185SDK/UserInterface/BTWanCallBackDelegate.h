//
//  BTWanCallBackDelegate.h
//  BTWanSDK
//
//  Created by 燚 on 2018/8/27.
//  Copyright © 2018年 Sans. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol BTWanCallBackDelegate <NSObject>

/**
 *  SDK初始化回调:
 *  初始化成功后可以唤起登录页面,否则无法唤起登录页面;
 */
- (void)BTWanSDKInitCallBackWithSuccess:(BOOL)success
                            Information:(NSDictionary *_Nonnull)dict;

/**
 *  登录的回调:
 *  成功: success 返回 true,dict 里返回 username 和 userToken
 *  失败: success 返回 false,dict 里返回 error message
 */
- (void)BTWanSDKLoginCallBackWithSuccess:(BOOL)success
                             Information:(NSDictionary *_Nonnull)dict;

/**
 *  切换账号回调
 */
- (void)BTWanSDKSwitchAccountCallBackWithSuccess:(BOOL)success
                                     Information:(NSDictionary *_Nonnull)dict;

/**
 *  登出的回调:
 *  当用户在 SDK 内部调用<退出登录>操作时会响应此方法
 */
- (void)BTWanSDKLogOutCallBackWithSuccess:(BOOL)success
                              Information:(NSDictionary *_Nullable)dict;

/**
 *  充值回调
 */
- (void)BTWanSDKRechargeCallBackWithSuccess:(BOOL)success
                                Information:(NSDictionary *_Nonnull)dict;

/**
 *  GM 权限发送道具成功回调
 */
- (void)BTWanSDKGMFunctionSendPropsCallBackWithSuccess:(BOOL)success
                                           Information:(NSDictionary *_Nonnull)dict;






@end





