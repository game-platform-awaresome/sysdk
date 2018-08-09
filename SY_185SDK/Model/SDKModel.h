//
//  SDKModel.h
//  SY_185SDK
//
//  Created by 燚 on 2017/9/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "Model.h"

@interface SDKModel : Model


@property (nonatomic, assign) BOOL useWindow;

@property (nonatomic, strong) NSString *AppID;
@property (nonatomic, strong) NSString *AppKey;

/** 请求状态 */
@property (nonatomic, strong) NSString *state;


/** 广告图片 */
@property (nonatomic, strong) NSString *ad_pic;
/** 广告地址 */
@property (nonatomic, strong) NSString *ad_url;
/** appid */
@property (nonatomic, strong) NSString *appid;
/** channel  */
@property (nonatomic, strong) NSString *channel;
/** 是否加速 */
@property (nonatomic, strong) NSString *is_accelerate;
/** 是否显示广告 */
@property (nonatomic, strong) NSString *isdisplay_ad;
/** 是否显示悬浮窗 */
@property (nonatomic, strong) NSString *isdisplay_buoy;
/** 客服 QQ */
@property (nonatomic, strong) NSString *qq;
/** 更新地址 */
@property (nonatomic, strong) NSString *udpate_url;
/** 是否更新 */
@property (nonatomic, strong) NSString *update;
/** 自动注册用户名 */
@property (nonatomic, strong) NSString *username;

//new property
/** bind mobile */
@property (nonatomic, strong) NSString *bind_mobile_enabled;
/** name auth */
@property (nonatomic, strong) NSString *name_auth_enabled;
/** platform money enabled */
@property (nonatomic, strong) NSString *platform_money_enabled;


/** 一键注册的用户名 */
@property (nonatomic, strong) NSString *oneUpRegisterAccount;
/** 一键注册密码 */
@property (nonatomic, strong) NSString *oneUpregisterPassword;

/** 1.1.4 new property */
@property (nonatomic, strong) NSString *register_enabled;


/** 1.2.5 */
@property (nonatomic, strong) NSString *discount;


/** 1.16  new property
 * show message
 */
@property (nonatomic, assign) BOOL showMessage;

/** 1.3.1 new property
 * 统计
 */
@property (nonatomic, strong) NSArray *static_type;


/** 1.50
 * box_url
 * 盒子落地页
 */
@property (nonatomic, strong) NSString *box_url;
/**
 *  box_pic_url
 *  盒子落地页广告图
 */
@property (nonatomic, strong) NSString *box_pic_url;
/**
 *  box_icon
 *  盒子图标地址
 */
@property (nonatomic, strong) NSString *box_icon;



+ (SDKModel *)sharedModel;

- (void)initWithApp:(NSString *)appID
             Appkey:(NSString *)appkey
         completion:(void(^)(NSDictionary *content,BOOL success))completion;


+ (void)pushNotificationWith:(NSDictionary *)dict;

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
+ (void)reportDataWithType:(NSUInteger)type
                  ServerID:(NSString *_Nonnull)serverID
                ServerName:(NSString *_Nonnull)serverName
                    RoleID:(NSString *_Nonnull)roleID
                  RoleName:(NSString *_Nonnull)roleName
                 RoleLevel:(NSString *_Nonnull)roleLevel
                     Money:(NSString *_Nonnull)money
                  VipLevel:(NSString *_Nonnull)vipLevel;



@end
