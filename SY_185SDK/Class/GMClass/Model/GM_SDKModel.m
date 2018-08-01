//
//  GM_SDKModel.m
//  SY_GMSDK
//
//  Created by 燚 on 2017/10/12.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "GM_SDKModel.h"
#import "RequestTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

#define REQUEST_COMPLETION \
REQUEST_STATUS;\
if (success) {\
if (status.integerValue == 1) {\
completion(content,true);\
} else {\
completion(@{@"status":content[@"status"],@"msg":content[@"msg"]},false);\
}\
} else {\
completion(@{@"status":@"404",@"msg":@"请求超时"},false);\
}\


static GM_SDKModel *model = nil;

@implementation GM_SDKModel

+ (GM_SDKModel *)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[GM_SDKModel alloc] init];
            model.isInit = NO;
        }
    });
    return model;
}

/** 初始化 */
+ (void)initGMSDKWithCompletion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"appid",@"channel",@"serverid",@"username"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if (![GM_SDKModel sharedModel]) {
        return;
    }
    [dict setObject:model.appid forKey:@"appid"];
    [dict setObject:model.channel forKey:@"channel"];
    [dict setObject:model.serverid forKey:@"serverid"];
    [dict setObject:model.username forKey:@"username"];

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    if (model.get_prop_url == nil || [model.get_prop_url isEqualToString:@""]) {
        SDKLOG(@"GM function initialize error with url");
        return;
    }

    [RequestTool postRequestWithURL:model.do_init_url params:dict completion:^(NSDictionary *content, BOOL success) {

        REQUEST_COMPLETION;

    }];
}

/** 请求道具列表 */
+ (void)getGMSDKPropsListWithGearID:(NSString *)gear_id
                         Completion:(void(^)(NSDictionary *content, BOOL success))completion {
    NSArray *pamarasKey = @[@"appid",@"gear_id"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if (![GM_SDKModel sharedModel]) {
        return;
    }

    [dict setObject:model.appid forKey:@"appid"];
    if (gear_id == nil || [gear_id isEqualToString:@""]) {
        NSLog(@"gm_sdk ====== 权限 id 为空");
        return;
    }

    model.gear_id = gear_id;

    [dict setObject:gear_id forKey:@"gear_id"];

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    if (model.get_prop_url == nil || [model.get_prop_url isEqualToString:@""]) {
        syLog(@"GMSDK === 请求道具列表地址出错");
        SDKLOG(@"GM function initialize error with get_prop_url");
        return;
    }

    [RequestTool postRequestWithURL:model.get_prop_url params:dict completion:^(NSDictionary *content, BOOL success) {

        REQUEST_COMPLETION;

    }];
}

/** 发送道具 */
+ (void)sendGMSDKPropsWithProp_id:(NSString *)prop_id
                         Prop_num:(NSString *)prop_num
                       Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"appid",@"username",@"serverid",@"role_id",
                            @"role_name",@"gear_id",@"prop_id",@"prop_num"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if (![GM_SDKModel sharedModel]) {
        return;
    }

    [dict setObject:model.appid forKey:@"appid"];
    [dict setObject:model.username forKey:@"username"];
    [dict setObject:model.serverid forKey:@"serverid"];
    [dict setObject:model.role_id forKey:@"role_id"];

    [dict setObject:model.role_name forKey:@"role_name"];
    [dict setObject:model.gear_id forKey:@"gear_id"];
    [dict setObject:prop_id forKey:@"prop_id"];
    [dict setObject:prop_num forKey:@"prop_num"];

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    if (model.send_prop_url == nil || [model.send_prop_url isEqualToString:@""]) {
        SDKLOG(@"GM function initialize error with send_prop_url");
        return;
    }

    [RequestTool postRequestWithURL:model.send_prop_url params:dict completion:^(NSDictionary *content, BOOL success) {

        REQUEST_COMPLETION;

    }];
}


#pragma mark ============================================================
/** 签名 */
+ (NSString *)signWithParms:(NSDictionary *)params WithKeys:(NSArray *)keys {

    NSMutableString *signString = [NSMutableString string];

    [keys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {

        [signString appendString:obj];
        [signString appendString:@"="];
        if (params[obj] == nil) {
            NSLog(@"尚未登录");
            return ;
        }

        [signString appendString:params[obj]];

        if (idx < keys.count - 1) {
            [signString appendString:@"&"];
        }
    }];

    NSString *key = [GM_SDKModel sharedModel].appKey;

    [signString appendString:key];

    return [GM_SDKModel md5:signString];
}


+ (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        //注意：这边如果是x则输出32位小写加密字符串，如果是X则输出32位大写字符串
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

#pragma mark ===============================================
/** 获取类的所有属性 */
+ (NSArray *)getAllPropertyWithClass:(id)classType {
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([classType class], &count);

    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {

        objc_property_t property = properties[i];

        const char *cName = property_getName(property);

        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];

        [mArray addObject:name];
    }

    return [mArray copy];
}

/** 对类的属性赋值 */
- (void)setAllPropertyWithDict:(NSDictionary *)dict {
    WeakSelf;
    NSArray *names = [GM_SDKModel getAllPropertyWithClass:self];

    if (dict == nil) {

        for (NSString *name in names) {
            if ([name isEqualToString:@"useWindow"] || [name isEqualToString:@"isInit"]) {
                [weakSelf setValue:[NSNumber numberWithBool:NO] forKey:name];
            } else {
                [weakSelf setValue:nil forKey:name];
            }
        }

    } else {

        for (NSString *name in names) {
            //如果字典中的值为空，赋值可能会出问题
            if (!name) {
                continue;
            }
            if (dict[name]) {
                [weakSelf setValue:[NSString stringWithFormat:@"%@",dict[name]] forKey:name];
            }
        }

    }
}



@end
