//
//  SYRequestTool.m
//  SY_185SDK
//
//  Created by 燚 on 2018/8/1.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import "SYRequestTool.h"
#import <CommonCrypto/CommonDigest.h>


/** 检测 URL */
NSURL * xb79830(id url) {
    if (!url) return nil;

    NSURL *result;
    if ([url isKindOfClass:[NSString class]]) {
        result = [NSURL URLWithString:url];
    } else if ([url isKindOfClass:[NSURL class]]) {
        result = url;
    } else if ([url isKindOfClass:[NSDictionary class]]) {
        id urlString = [url objectForKey:@"url"];
        result = xb79830(urlString);
    }

    NSString *urlString = result.absoluteString;
    if ([urlString hasPrefix:@"http"]) {
        return result;
    } else {
        return nil;
    }
}

NSData * xb79831(id param , NSStringEncoding encoding) {
    if ([param isKindOfClass:[NSData class]]) {
        return param;
    }
    NSData *result;
    if ([param isKindOfClass:[NSString class]]) {

        result = [param dataUsingEncoding:encoding];

    } else if ([param isKindOfClass:[NSDictionary class]]) {

        NSDictionary *dict = (NSDictionary *)param;
        if (dict && dict.count) {
            NSArray *arrKey = [dict allKeys];
            NSMutableArray *pValues = [NSMutableArray array];

            for (id key in arrKey) {
                id obj = dict[key];

                if ([obj isKindOfClass:[NSString class]]) {

                } else if ([obj isKindOfClass:[NSDictionary class]] ||
                           [obj isKindOfClass:[NSArray class]] ||
                           [obj isKindOfClass:[NSData class]] ||
                           [obj isKindOfClass:[NSSet class]]) {
                    NSError* err = nil;
                    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:&err];
                    obj = err ? @"" : [[NSString alloc] initWithData:jsonData encoding:encoding];
                } else {
                    obj = [obj description];
                }
                [pValues addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
            }

            NSString *strP = [pValues componentsJoinedByString:@"&"];
            result = [strP dataUsingEncoding:encoding];
        } else {
            result = nil;
        }
    }
    return result;
}



@implementation SYRequestTool

+ (void)postRequestWithUrl:(id)url Param:(id)param SuccessBlock:(SYRequestSuccessBlock)success FailureBlock:(SYRequestFailureBlock)failure WarningBlock:(SYRequestWarningBlock)warning {

    NSURL *safeUrl = [self cheackURL:url];
    if (!safeUrl) {
        if (failure) {
            failure(nil,@{@"msg":@"error : url error"});
        }
        return;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:safeUrl];
    NSData *cheackParam = [self encodePara:param encodeing:NSUTF8StringEncoding];
    if (cheackParam) {
        [request setHTTPBody:cheackParam];
    } else {
        if (warning) {
            warning(nil,@{@"msg":@"warning : parameter is null or parameter type error"});
        }
    }

    request.timeoutInterval = 15.f;
    [request setHTTPMethod:@"POST"];

    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSError * fail = nil;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&fail];
            if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failure) {
                        failure(nil,@{@"msg":fail.localizedDescription});
                    }
                });
            } else {
                if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(nil,obj);
                        }
                    });
                } else if (obj) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(nil,@{@"data":obj});
                        }
                    });
                } else {
                    if (failure) {
                        failure(nil,@{@"msg":@"error : call back data not exist."});
                    }
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(nil,@{@"msg":error.localizedDescription});
                }
            });
        }
    }];
    [task resume];
}



/** 检查 url */
+ (NSURL *)cheackURL:(id)sender {
    return xb79830(sender);
}

/** 编码 */
+ (NSData *)encodePara:(id)param encodeing:(NSStringEncoding)encodeing {
    return xb79831(param, encodeing);
}


/** 签名 */
+ (NSString *)signWithParms:(NSDictionary *)params WithKeys:(NSArray *)keys WithParamsKey:(NSString *)paramsKey {
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

    if (paramsKey) {
        [signString appendString:paramsKey];
    }
    return [self md5:signString];
}

/** md5 string */
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











@end










