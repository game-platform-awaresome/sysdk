//
//  SY_GMSDK.h
//  SY_185SDK
//
//  Created by 燚 on 2017/10/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SY_GMSDK;

@protocol GMFunctionDelegate <NSObject>

/** 初始化成功回调 */
- (void)GMSDK:(SY_GMSDK *)sdk initSuccess:(BOOL)success;

/** 发起支付回调 */
- (void)GMSDKPayStartServerID:(NSString *)serverID
                   serverName:(NSString *)serverName
                       roleID:(NSString *)roleID
                     roleName:(NSString *)roleName
                    productID:(NSString *)productID
                  productName:(NSString *)productName
                       amount:(NSString *)amount
                    extension:(NSString *)extension;

/** 发送道具成功回调 */
- (void)GMSDK:(SY_GMSDK *)sdk SendPropsSuccess:(BOOL)success WithInfo:(NSDictionary *)dict;


@end

@interface SY_GMSDK : NSObject


@property (nonatomic, weak) id<GMFunctionDelegate> delegate;

/** 初始化 GM 权限 SDK
 *  appid : app ID ; appkey : appkey; channel : 渠道号;
 *  serverid : 服务器号;
 *  role_id : 角色 id ; role_name : 角色名称
 */
+ (void)initGM_SDKWithAppid:(NSString *)appid
                     AppKey:(NSString *)appKey
                    Channel:(NSString *)channel
                   Serverid:(NSString *)serverid
                 ServerName:(NSString *)serverName
                   UserName:(NSString *)username
                        Uid:(NSString *)uid
                    Role_di:(NSString *)role_id
                  Role_name:(NSString *)role_name
                    InitUrl:(NSString *)do_init_url
                PropListUrl:(NSString *)get_prop_url
                SendPropUrl:(NSString *)send_prop_url
                  UseWindow:(BOOL)useWindow
                   Delegate:(id<GMFunctionDelegate>)delegate;

/** 刷新界面 */
+ (void)refreshDetailPage;

/** 登出 */
+ (void)logOut;




@end
