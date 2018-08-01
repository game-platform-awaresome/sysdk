//
//  SYDeviceTools.h
//  SY_185SDK
//
//  Created by 燚 on 2018/8/1.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYDeviceTool : NSObject

/** 设备 ID */
+ (NSString *)deviceID;
/** 检查渠道号 */
+ (NSString *)cheackChannel;
/** 渠道号 */
+ (NSString *)channelID;
/* 设备型号 */
+ (NSString *)phoneType;
/* 设备系统版本 */
+ (NSString *)systemVersion;
/* 运营商 */
+ (NSString *)MobilePhoneOperators;
/** app 版本 */
+ (NSString *)appVersion;
/* 网络信号 */
+ (NSString *)netWrokStates;
/** 获取 sdk bundle */
+ (NSBundle *)getBundle;
/** 获取 bundle 下的文件 */
+ (NSString *)getBundlePath:(NSString *)bundleName;








@end
