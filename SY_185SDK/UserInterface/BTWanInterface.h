//
//  BTWanInterface.h
//  BTWanSDK
//
//  Created by 燚 on 2018/8/27.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BTWanCallBackDelegate.h"

@interface BTWanSDK : NSObject

/** 控制台显示信息 */
+ (void)SDKShowMessage;

/** 注册为默认SDK(此方法为接入融合SDK使用) */
+ (void)resignDefaultSDK;

/**
 * 初始化 SDK 方法(此方法为接入 GM功能 SDK 使用)
 * @param appID 初始化SDK使用的AppID
 * @param appkey    初始化SDK使用的AppKey
 * @param delegate  用于接收初始化,登录,支付等回调的实例
 * @warning 所有参数不能为空.
 */
+ (void)initWithAppID:(NSString * _Nonnull)appID
               Appkey:(NSString * _Nonnull)appkey
     CallBackDelegate:(id<BTWanCallBackDelegate> _Nonnull)delegate;

/** 登录 */
+ (void)login;

/** 登出 */
+ (void)logOut;

/** 发起支付 : data 传 BTWanPayData 类型 */
+ (void)pay:(id)data;

/** 上报数据 : data 传 BTWanExtraData 类型 */
+ (void)submitExtraData:(id)data;

/**
 * GM 功能初始化
 * @param serverID      服务器 ID
 * @param serverName    服务器名称
 * @param roleID        角色 ID
 * @param roleName      角色名称
 */
+ (void)initGMFunctionWithServerid:(NSString *_Nonnull)serverID
                        ServerName:(NSString *_Nonnull)serverName
                            RoleID:(NSString *_Nonnull)roleID
                          RoleName:(NSString *_Nonnull)roleName;




@end
