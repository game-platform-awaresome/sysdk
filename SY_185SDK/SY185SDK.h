//
//  SY185SDK.h
//  SY_185SDK
//
//  Created by 燚 on 2017/9/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    SY185SDKReportTypeSelectServer = 1,
    SY185SDKReportTypeCreatingARole,
    SY185SDKReportTypeEnterTheGame,
    SY185SDKReportTypeUpgradeLevel,
    SY185SDKReportTypeExitGame
} SY185SDKReportType;


@protocol SY185SDKDelegate <NSObject>

/**
 *  SDK初始化回调:
 *  初始化成功后可以掉起登录页面,否则无法掉起登录页面;
 */
- (void)m185SDKInitCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *_Nonnull)dict;

/**
 *  登录的回调:
 *  成功: success 返回 true,dict 里返回 username 和 userToken
 *  失败: success 返回 false,dict 里返回 error message
 */
- (void)m185SDKLoginCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *_Nonnull)dict;

/** 切换账号回调 */
- (void)m185SDKSwitchAccountCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *_Nonnull)dict;

/**
 *  登出的回调:
 *  这个回调是从 SDK 登出的回调
 */
- (void)m185SDKLogOutCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *_Nullable)dict;

/**
 *  充值回调
 */
- (void)m185SDKRechargeCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *_Nonnull)dict;

/**
 *  GM 权限发送道具成功回调
 */
- (void)m185SDKGMFunctionSendPropsCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *_Nonnull)dict;

@end

@interface SY185SDK : NSObject

/** 注册为默认SDK */
+ (void)resignDefaultSDK;


/**
 *  SDK初始化:
 *  初始化设置接收回调的代理,不能为空,
 *  cocos2d 引擎游戏推荐不使用 window -> useWindow : NO;  u3d 引擎推荐使用 window : useWindow : YES
 *  具体显示情况,请根据开发中实际遇到的问题选择设置是否使用 window -> userWindow Yes or NO;
 */
+ (void)initWithAppID:(NSString * _Nonnull)appID
               Appkey:(NSString * _Nonnull)appkey
             Delegate:(id<SY185SDKDelegate> _Nonnull)delegate
            UseWindow:(BOOL)useWindow;


/** 加载登录页面: */
+ (BOOL)showLoginView;

/** 登出: */
+ (void)signOut;

/** 是否使用 window */
+ (void)SDKUseWindow:(BOOL)useWindow;

/** 控制台显示信息 */
+ (void)SDKShowMessage;


/**
 *  发起支付:
 *  serverID \ serverName     : 服务器 ID \ 服务器名称
 *  roleID \ roleName         : 角色 ID \ 角色名称
 *  productID \ productName   : 产品 ID \ 产品名称
 *  amount                    : 金额 - > 单位 RMB (元) 最小充值金额1元 -> amount = 1;
 *  extension                 : 拓展
 */
+ (void)payStartWithServerID:(NSString *_Nonnull)serverID
                  serverName:(NSString *_Nonnull)serverName
                      roleID:(NSString *_Nonnull)roleID
                    roleName:(NSString *_Nonnull)roleName
                   productID:(NSString *_Nonnull)productID
                 productName:(NSString *_Nonnull)productName
                      amount:(NSString *_Nonnull)amount
                   extension:(NSString *_Nullable)extension;


/**
 * GM 功能初始化
 * serverid : 服务器 ID ; serverName : 服务器名称
 * roleID : 角色 ID ; roleName : 角色名
 */
+ (void)initGMFunctionWithServerid:(NSString *_Nonnull)serverID
                        ServerName:(NSString *_Nonnull)serverName
                            RoleID:(NSString *_Nonnull)roleID
                          RoleName:(NSString *_Nonnull)roleName;


/**
 * 上报数据
 * @param type          上报数据的类型
 * @param serverID      服务器 ID
 * @param serverName    服务器名称
 * @param roleID        角色 ID
 * @param roleName      角色名称
 * @param roleLevel     角色等级
 * @param money         账号游戏币钻石等
 * @param vipLevel      VIP 等级,尽量填写数字字符,也可以接受字符串
 */
+ (void)submitExtraDataWithType:(SY185SDKReportType)type
                       ServerID:(NSString *_Nonnull)serverID
                     ServerName:(NSString *_Nonnull)serverName
                         RoleID:(NSString *_Nonnull)roleID
                       RoleName:(NSString *_Nonnull)roleName
                      RoleLevel:(NSString *_Nonnull)roleLevel
                          Money:(NSString *_Nonnull)money
                       VipLevel:(NSString *_Nonnull)vipLevel;





@end
