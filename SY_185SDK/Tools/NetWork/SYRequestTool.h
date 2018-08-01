//
//  SYRequestTool.h
//  SY_185SDK
//
//  Created by 燚 on 2018/8/1.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^SYRequestSuccessBlock)(id success, NSDictionary *content);
typedef void(^SYRequestFailureBlock)(id failure, NSDictionary *content);
typedef void(^SYRequestWarningBlock)(id warning, NSDictionary *content);


@interface SYRequestTool : NSObject

/** post 请求 */
+ (void)postRequestWithUrl:(id)url
                     Param:(id)param
              SuccessBlock:(SYRequestSuccessBlock)success
              FailureBlock:(SYRequestFailureBlock)failure
              WarningBlock:(SYRequestWarningBlock)warning;

/** 签名 */
+ (NSString *)signWithParms:(NSDictionary *)params WithKeys:(NSArray *)keys WithParamsKey:(NSString *)paramsKey;

/** 字符串转 MD5 */
+ (NSString *)md5:(NSString *)input;










@end



















