//
//  GM_SDKModel.h
//  SY_GMSDK
//
//  Created by 燚 on 2017/10/12.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GM_SDKModel : NSObject

@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *appKey;
//渠道 id
@property (nonatomic, strong) NSString *channel;
//服务器 id
@property (nonatomic, strong) NSString *serverid;
@property (nonatomic, strong) NSString *serverName;
//用户名
@property (nonatomic, strong) NSString *username;
//用户 id
@property (nonatomic, strong) NSString *uid;
//角色 id
@property (nonatomic, strong) NSString *role_id;
//角色名
@property (nonatomic, strong) NSString *role_name;

//档位
@property (nonatomic, strong) NSString *gear_id;
//道具
@property (nonatomic, strong) NSString *prop_id;
//道具数量
@property (nonatomic, strong) NSString *prop_num;

//初始化接口
@property (nonatomic, strong) NSString *do_init_url;
//获取道具列表接口
@property (nonatomic, strong) NSString *get_prop_url;
//发送道具接口
@property (nonatomic, strong) NSString *send_prop_url;

//当前账户的所有档位列表
@property (nonatomic, strong) NSArray *GM_Authority_List;


//使用窗口
@property (nonatomic, assign) BOOL useWindow;

//是否初始化
@property (nonatomic, assign)  BOOL isInit;


#pragma mark - method
+ (GM_SDKModel *)sharedModel;

/** 初始化 */
+ (void)initGMSDKWithCompletion:(void(^)(NSDictionary *content, BOOL success))completion;
/** 获取道具列表 */
+ (void)getGMSDKPropsListWithGearID:(NSString *)gear_id
                         Completion:(void(^)(NSDictionary *content, BOOL success))completion;
/** 发送道具 */
+ (void)sendGMSDKPropsWithProp_id:(NSString *)prop_id
                         Prop_num:(NSString *)prop_num
                       Completion:(void(^)(NSDictionary *content, BOOL success))completion;

/** 获取所有类的属性 */
+ (NSArray *)getAllPropertyWithClass:(id)classType;

/** 对类的所有属性赋值 */
- (void)setAllPropertyWithDict:(NSDictionary *)dict;




@end

















