//
//  RequestTool.h
//  BTWanSDK
//
//  Created by 石燚 on 2017/6/12.
//  Copyright © 2017年 TenoneTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestTool : NSObject

/** get方法 */
+ (void)getRequestWithURL:(NSString *)url
                   params:(NSDictionary *)dicP
               completion:(void(^)(NSDictionary *content,BOOL success))completion;


/** post方法 */
+ (void)postRequestWithURL:(NSString *)url
                    params:(NSDictionary *)dicP
                completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 保存 APPID 和 APPKey */
+ (BOOL)saveAppID:(NSString *)appID AndAppKey:(NSString *)appKey;
/** 删除 appid 和 appkey */
+ (BOOL)deleteAppIDAndAppKey;
/** 获取 appid */
+ (NSString *)getAppID;
/** 获取 APPKey */
+ (NSString *)getAppKey;

/** 保存用户名和密码 */
+ (BOOL)saveAccount:(NSString *)account Password:(NSString *)password PhoneNumber:(NSString *)phoneNumber;
/** 获取用户名和密码 */
+ (NSDictionary *)getAccountAndPassword;
/** 删除用户名和密码 */
+ (void)deleteAccountAndPassword;


+ (BOOL)saveUid:(NSString *)uid;
+ (NSString *)getUid;
+ (BOOL)deleteUid;

/** 签名 */
+ (NSString *)signWithParms:(NSDictionary *)params WithKeys:(NSArray *)keys;

/** channelID */
+ (NSString *)channelID;

/** 通用错误码 */
+ (NSString *)statuMessage:(NSString *)status;

/** 支付查询状态码 */
+ (NSString *)payQueryMessage:(NSString *)status;

/** 字符串转 MD5 */
+ (NSString *)md5:(NSString *)input;





@end












