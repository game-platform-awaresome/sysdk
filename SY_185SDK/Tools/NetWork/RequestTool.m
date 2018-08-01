//
//  RequestTool.m
//  BTWanSDK
//
//  Created by 石燚 on 2017/6/12.
//  Copyright © 2017年 TenoneTechnology. All rights reserved.
//

#import "RequestTool.h"
#import <CommonCrypto/CommonDigest.h>
#import "InfomationTool.h"
#import "SYKeychain.h"
#import "SDKModel.h"

#define KEYCHAIN_SERVICE @"Singyi.com"
#define KEYCHAIN_APPID @"appID%forSDK"
#define KEYCHAIN_APPKEY @"appKey5forSDK"
#define KEYCHAIN_UID @"SDK_UID"
#define KEYCHAIN_ACCOUNT @"SDK_ACCOUNT"
#define KEYCHAIN_PASSWORD @"SDK_PASSWORD"
#define KEYCHAIN_PHONENUMBER @"SDK_PHONENUMBER"
#define SDK_REQUESTCODEURL MAINURL_ADDLASTURL(@"user/mobile/code")


@implementation RequestTool

+ (void)getRequestWithURL:(NSString *)url
                   params:(NSDictionary *)dicP
               completion:(void(^)(NSDictionary * content,BOOL success))completion
{
    NSMutableString * strUrl = [NSMutableString stringWithString:url];
    if (dicP && dicP.count) {
        NSArray * arrKey = [dicP allKeys];
        NSMutableArray * pValues = [NSMutableArray array];
        for (id key in arrKey) {
            [pValues addObject:[NSString stringWithFormat:@"%@=%@",key,dicP[key]]];
        }
        NSString * strP = [pValues componentsJoinedByString:@"&"];
        [strUrl appendFormat:@"?%@",strP];
    }
    NSURLSession * session  = [NSURLSession sharedSession];
    
    NSURLSessionTask * task = [session dataTaskWithURL:[NSURL URLWithString:strUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSError * fail = nil;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&fail];
            if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil,false);
                    }
                });
            } else {
                if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion((NSDictionary *)obj,true);
                        }
                    });
                    
                }
            }
        } else {
//            syLog(@"Request Failed...");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil,false);
                }
            });
        }
    }];
    [task resume];
}


+ (void)postRequestWithURL:(NSString *)url
                    params:(NSDictionary *)dicP
                completion:(void(^)(NSDictionary * content,BOOL success))completion
{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];


    if (dicP && dicP.count) {
        NSArray *arrKey = [dicP allKeys];
        NSMutableArray *pValues = [NSMutableArray array];
        for (id key in arrKey) {
            [pValues addObject:[NSString stringWithFormat:@"%@=%@",key,dicP[key]]];
        }
        NSString *strP = [pValues componentsJoinedByString:@"&"];
        [request setHTTPBody:[strP dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    request.timeoutInterval = 8.f;
    
    [request setHTTPMethod:@"POST"];

    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            
            NSError * fail = nil;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&fail];
            //            syLog(@"%@",obj);
            if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil,false);
                    }
                });
                //                syLog(@"NSJSONSerialization error");
                
            } else {
                if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion((NSDictionary *)obj,true);
                        }
                    });
                }
            }
        } else {
//                syLog(@"Request Failed...");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil,false);
                }
            });
        }
    }];
    [task resume];
}


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
    [signString appendString:[SDKModel sharedModel].AppKey];
    return [RequestTool md5:signString];
}

+ (NSString *)channelID {


    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"GameBoxConfig" ofType:@"plist"];
    NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (infoDic) {
        NSString *channel = infoDic[@"channelID"];
        if (channel && channel.length > 0) {
            SDK_Log(([NSString stringWithFormat:@"获取盒子渠道 -> %@",channel]));
            return  channel;
        }
    }

    NSString *path = [InfomationTool getBundlePath:@"SDKCHANNELID.txt"];

    NSString * channel = [NSString stringWithContentsOfFile:path encoding:0 error:nil];

    if (channel == nil) {
        path = [InfomationTool getBundlePath:@"SDKConfig.plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        channel = dict[@"channel"];
    }

    channel = [RequestTool cheachChannel:channel];
    channel = [NSString stringWithFormat:@"%ld",(long)channel.integerValue];

    syLog(@"sdk === channel === %@",channel);

    if (channel.integerValue > 0) {
        return channel;
    } else {
//        SDK_MESSAGE(@"渠道格式不正确!!");
        SDK_Log(@"渠道格式不正确");
        return @"185";
    }

}

+ (NSString *)cheachChannel:(NSString *)channel {
    NSMutableString *str = [channel mutableCopy];
    NSString * result;
    if (str && str.length > 0) {
        result = [str stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    }
    return result;
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

+ (NSString *)statuMessage:(NSString *)status {
    if (status && status.integerValue) {
        switch (status.integerValue) {
            case 0:
                return @"失败";
            case 1:
                return @"成功";
            case 2:
                return @"签名错误";
            case 3:
                return @"app 不存在";
            case 4:
                return @"渠道部不存在";
            case 5:
                return @"用户不存在";
            case 6:
                return @"token 错误";
            case 7:
                return @"验证码错误";
            case 8:
                return @"密码错误";
            case 9:
                return @"用户已存在";
            case 10:
                return @"手机已存在 或 绑定";
            case 11:
                return @"参数错误";
            case 12:
                return @"玩家封号中";
            case 13:
                return @"验证码短信发送失败";
            case 14:
                return @"短信发送太频繁(CD时间中)";
            case 15:
                return @"不是手机号";
            case 16:
                return @"不是身份证号";
            case 17:
                return @"token过期";
            case 18:
                return @"验证码过期";
            case 19:
                return @"手机号不匹配";
            case 20:
                return @"每页个数超限";
            case 21:
                return @"公告不存在";
            case 22:
                return @"订单不存在";
            case 23:
                return @"礼包不存在";
            case 24:
                return @"用户名不合法，注册用户名必须是字母或数字组成，长度6-16 不能以BT开头";
            case 25:
                return @"serverID为空";
            case 26:
                return @"订单已支付不可取消";
            case 27:
                return @"不是有效的支付类型";
            case 28:
                return @"充值卡支付时 充值卡号或密码为空";
            case 29:
                return @"充值卡面额小于订单金额";
            case 30:
                return @"充值面额小于1元";
            case 31:
                return @"已领取过礼包";
            case 32:
                return @"平台币不足";
            case 33:
                return @"同步用户失败";
            case 34:
                return @"礼包已过期或未生效";
            case 35:
                return @"礼包已经领空";
            case 36:
                return @"解绑手机不是该用户的手机号码";
            case 37:
                return @"不存在GM权限";
            case 38:
                return @"道具列表地址未对接";
            case 39:
                return @"发送道具地址未对接";

            default:
                return @"失败";
        }
    }
    return @"失败";
}

+ (NSString *)payQueryMessage:(NSString *)status {
    if (status && status.integerValue) {
        switch (status.integerValue) {
            case 0:
                return @"发货失败";
            case 1:
                return @"支付中";
            case 2:
                return @"发货中（已经支付）";
            case 3:
                return @"发货成功";
            default:
                return @"发货失败";
        }
    }
    return @"发货失败";
}

+ (BOOL)saveAccount:(NSString *)account Password:(NSString *)password PhoneNumber:(NSString *)phoneNumber {
    if (account && password) {
        BOOL flag = [SYKeychain setPassword:account forService:KEYCHAIN_SERVICE account:KEYCHAIN_ACCOUNT];
        BOOL flag1 =[SYKeychain setPassword:password forService:KEYCHAIN_SERVICE account:KEYCHAIN_PASSWORD];
        [SYKeychain deletePasswordForService:KEYCHAIN_SERVICE account:KEYCHAIN_PHONENUMBER];
        return flag && flag1;
    } else if (phoneNumber && password) {
        BOOL flag = [SYKeychain setPassword:phoneNumber forService:KEYCHAIN_SERVICE account:KEYCHAIN_PHONENUMBER];
        BOOL flag1 =[SYKeychain setPassword:password forService:KEYCHAIN_SERVICE account:KEYCHAIN_PASSWORD];
        [SYKeychain deletePasswordForService:KEYCHAIN_SERVICE account:KEYCHAIN_ACCOUNT];
        return flag && flag1;
    } else {
        return NO;
    }
}

+ (NSDictionary *)getAccountAndPassword {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString * account = [SYKeychain passwordForService:KEYCHAIN_SERVICE account:KEYCHAIN_ACCOUNT];
    NSString * password = [SYKeychain passwordForService:KEYCHAIN_SERVICE account:KEYCHAIN_PASSWORD];
    NSString * phoneNumber = [SYKeychain passwordForService:KEYCHAIN_SERVICE account:KEYCHAIN_PHONENUMBER];

    account ? [dict setObject:account forKey:@"account"] : 0;
    password ? [dict setObject:password forKey:@"password"] : 0;
    phoneNumber ? [dict setObject:phoneNumber forKey:@"phoneNumber"] : 0;

    return dict;
}

+ (void)deleteAccountAndPassword {
    [SYKeychain deletePasswordForService:KEYCHAIN_SERVICE account:KEYCHAIN_ACCOUNT];
    [SYKeychain deletePasswordForService:KEYCHAIN_SERVICE account:KEYCHAIN_PASSWORD];
    [SYKeychain deletePasswordForService:KEYCHAIN_SERVICE account:KEYCHAIN_PHONENUMBER];
}


+ (BOOL)saveUid:(NSString *)uid {
    return [SYKeychain setPassword:uid forService:KEYCHAIN_SERVICE account:KEYCHAIN_UID];
}

+ (NSString *)getUid {
    return [SYKeychain passwordForService:KEYCHAIN_SERVICE account:KEYCHAIN_UID];
}

+ (BOOL)deleteUid {
    return [SYKeychain deletePasswordForService:KEYCHAIN_SERVICE account:KEYCHAIN_UID];
}



/** 保存 appid 和 appkey */
+ (BOOL)saveAppID:(NSString *)appID AndAppKey:(NSString *)appKey {
    if ([SYKeychain setPassword:appID forService:KEYCHAIN_SERVICE account:KEYCHAIN_APPID] && [SYKeychain setPassword:appKey forService:KEYCHAIN_SERVICE account:KEYCHAIN_APPKEY]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)deleteAppIDAndAppKey {
    BOOL flag = NO;
    NSString *appkey = [SYKeychain passwordForService:KEYCHAIN_SERVICE account:KEYCHAIN_APPKEY];
    if (appkey) {
        flag = [SYKeychain deletePasswordForService:KEYCHAIN_SERVICE account:KEYCHAIN_APPKEY];
    } else {
        flag = YES;
    }

    if (flag == NO) {
        return NO;
    }

    NSString *appID = [SYKeychain passwordForService:KEYCHAIN_SERVICE account:KEYCHAIN_APPID];
    if (appID) {
        flag = [SYKeychain deletePasswordForService:KEYCHAIN_SERVICE account:KEYCHAIN_APPID];
    } else {
        flag = YES;
    }

    return flag;
}

/** 获取 appid */
+ (NSString *)getAppID {
    NSString *appID = [SYKeychain passwordForService:KEYCHAIN_SERVICE account:KEYCHAIN_APPID];
    if (appID && appID.length > 0) {
        return appID;
    } else {
        return nil;
    }
}

/** 获取 appkey */
+ (NSString *)getAppKey {
    NSString *key = [SYKeychain passwordForService:KEYCHAIN_SERVICE account:KEYCHAIN_APPKEY];
    if (key && key.length > 0) {
        return key;
    } else {
        return nil;
    }
}



@end

















