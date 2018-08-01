//
//  SYDeviceTools.m
//  SY_185SDK
//
//  Created by 燚 on 2018/8/1.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import "SYDeviceTool.h"
#import "SYKeychain.h"
#import "RequestTool.h"

#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


#define KEYCHAINSERVICE @"tenoneTec.com"
#define DEVICEID @"deviceID%forBTWanSDK"
#define DEVICE_CHANNEL @"device(_Channel"
#define DEVICE_CHANNEL_STRING @"device(_Channel_string"


@implementation SYDeviceTool


/** 设备 id */
+ (NSString *)deviceID {
    NSString *deviceID = [SYKeychain passwordForService:KEYCHAINSERVICE account:DEVICEID];
    if (deviceID == nil) {
        deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SYKeychain setPassword:deviceID forService:KEYCHAINSERVICE account:DEVICEID];
    }
    return deviceID;
}

/** 检查渠道号 */
+ (NSString *)cheackChannel {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time= [date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    NSString *SaveChannelString = [SYKeychain passwordForService:KEYCHAINSERVICE account:DEVICE_CHANNEL_STRING];
    if (SaveChannelString == nil) {
        SaveChannelString = [NSString stringWithFormat:@"%@-%@",[RequestTool channelID],timeString];
        [SYKeychain setPassword:SaveChannelString forService:KEYCHAINSERVICE account:DEVICE_CHANNEL_STRING];
        [SYKeychain setPassword:[RequestTool channelID] forService:KEYCHAINSERVICE account:DEVICE_CHANNEL];
        return SaveChannelString;
    } else {
        NSString *saveChannel = [SYKeychain passwordForService:KEYCHAINSERVICE account:DEVICE_CHANNEL];
        if ([saveChannel isEqualToString:[RequestTool channelID]]) {
            return SaveChannelString;
        } else {
            SaveChannelString = [NSString stringWithFormat:@"%@-%@",[RequestTool channelID],timeString];
            [SYKeychain setPassword:SaveChannelString forService:KEYCHAINSERVICE account:DEVICE_CHANNEL_STRING];
            [SYKeychain setPassword:[RequestTool channelID] forService:KEYCHAINSERVICE account:DEVICE_CHANNEL];
            return SaveChannelString;
        }
    }
}

/** 渠道号 */
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


    NSString *path = [self getBundlePath:@"SDKCHANNELID.txt"];
    NSString * channel = [NSString stringWithContentsOfFile:path encoding:0 error:nil];
    if (channel == nil) {
        path = [self getBundlePath:@"SDKConfig.plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        channel = dict[@"channel"];
    }

    channel = [self cheachChannel:channel];
    channel = [NSString stringWithFormat:@"%ld",(long)channel.integerValue];

    syLog(@"sdk === channel === %@",channel);

    if (channel.integerValue > 0) {
        return channel;
    } else {
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

/** 设备型号 */
+ (NSString *)phoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    return platform;
}

/** 系统版本 */
+ (NSString *)systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

/** 运营商 */
+ (NSString *)MobilePhoneOperators {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    return carrier.carrierName ?: @"Simulator";
}

/** 游戏的版本 */
+ (NSString *)appVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [infoDic objectForKey:@"CFBundleShortVersionString"];
}

/* 网络信号 */
+ (NSString *)netWrokStates {
    return nil;
}

/** 获取 sdk bundle */
+ (NSBundle *)getBundle {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"SY_185SDK" ofType:@"framework"]];
    if (bundle == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SY_185SDK_RES" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    } else {
        NSString *path = [bundle pathForResource:@"SY_185SDK_RES" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    }
    return  bundle;
}

/** 获取 bundle 下的文件 */
+ (NSString *)getBundlePath: (NSString *) bundleName {
    NSBundle *myBundle = [self getBundle];
    if (myBundle && bundleName) {
        return [[myBundle resourcePath] stringByAppendingPathComponent: bundleName];
    } else {
        NSLog(@"resource path error.");
    }
    return nil;
}






@end




