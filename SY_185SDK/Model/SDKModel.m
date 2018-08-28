//
//  SDKModel.m
//  SY_185SDK
//
//  Created by 燚 on 2017/9/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SDKModel.h"
#import "MapModel.h"
#import "SYStatisticsModel.h"
#import "UserModel.h"
#import "RequestTool.h"


#define SDKINITURL  MAINURL_ADDLASTURL(@"index.php?g=api&m=user&a=do_init")

#define SystemVersion (([UIDevice currentDevice].systemVersion).doubleValue)

@interface SDKModel ()


@end

static SDKModel *model = nil;

@implementation SDKModel


+ (SDKModel *)sharedModel {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[SDKModel alloc] init];
        }
    });

    return model;
}

- (void)initWithApp:(NSString *)appID Appkey:(NSString *)appkey completion:(void (^)(NSDictionary *, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    NSArray *array = @[@"appid",@"channel",@"version",@"system",@"machine_code"];

    [dict setObject:appID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:[InfomationTool appVersion] forKey:@"version"];
    [dict setObject:SDK_GETDEVICEYYPE forKey:@"system"];
    [dict setObject:SDK_GETDEVICEID forKey:@"machine_code"];
    [dict setObject:SDK_GETSIGN(dict, array) forKey:@"sign"];

    syLog(@"init param == %@",dict);
//    WeakSelf;
    [RequestTool postRequestWithURL:[MapModel sharedModel].USER_INIT params:dict completion:^(NSDictionary *content, BOOL success) {

        if (success) {

            [RequestTool saveAppID:appID AndAppKey:appkey];

            REQUEST_STATUS;
            if (status.integerValue == 1) {
//                [SDKModel sharedModel].AppKey = appkey;
//                [SDKModel sharedModel].AppID = appID;

//                [weakSelf setAllPropertyWithDict:content[@"data"]];

                id dict = content[@"data"][@"notice_info"];
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    if (((NSDictionary *)dict) != nil && ((NSDictionary *)dict).count != 0) {
                        [SDKModel pushNotificationWith:dict];
                    }
                }

                if (completion) {
                    completion(content,true);
                }

            } else {
                if (completion) {
                    completion(content,false);
                }
            }
        } else {
            if (completion) {
                completion(@{@"status":@"404",@"msg":@"request time out"},false);
            }
        }
    }];
    
}

+ (void)pushNotificationWith:(NSDictionary *)dict {
    syLog(@"添加");
    syLog(@"dict === %@",dict);
    if (NSClassFromString(@"UIPopoverController")) {

    }

//    if (SystemVersion > 10.0) {
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//
//        center.delegate = [SDKModel sharedModel];
//
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            if (granted == YES) {
//
//                if (SystemVersion > 10.0) {
//
//                    UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:6 repeats:NO];
//
//                    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//                    content.title = [NSString stringWithFormat:@"%@",dict[@"title"]];
//                    content.body = [NSString stringWithFormat:@"%@",dict[@"content"]];
//                    content.badge = @666;
//                    content.sound = [UNNotificationSound defaultSound];
//                    content.userInfo = dict;
//
//                    NSString *requestIdentifier = [SDKModel notificationIdentifierWithUserInfo:dict];
//
//                    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:timeTrigger];
//                    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
//                    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
//                        if (!error) {
//                            syLog(@"notification === 添加成功");
//                        }
//                    }];
//                } else {
//
//                }
//            } else {
//
//            }
//        }];
//
//        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//
//        }];
//    } else {
//
//    }
}


//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
//
//    if (SystemVersion > 10.0) {
//        completionHandler(UNNotificationPresentationOptionAlert);
//    } else {
//
//    }
//}
//
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
//
//
//}
//
//+ (NSString *)notificationIdentifierWithUserInfo:(NSDictionary *)dict {
//    return [NSString stringWithFormat:@"%@-%@",dict[@"add_time"],dict[@"title"]];
//}
//
//+ (void)deletAllNotification {
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//
//    if (SystemVersion > 10.0) {
//        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[]];
//    } else {
//
//    }
//}

+ (NSInteger)year:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY";
    NSString *year = [formatter stringFromDate:date];
    return year.integerValue;
}

+ (NSInteger)month:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM";
    NSString *year = [formatter stringFromDate:date];
    return year.integerValue;
}

+ (NSInteger)day:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd";
    NSString *year = [formatter stringFromDate:date];
    return year.integerValue;
}

+ (NSInteger)hour:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH";
    NSString *year = [formatter stringFromDate:date];
    return year.integerValue;
}

+ (NSInteger)minute:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"mm";
    NSString *year = [formatter stringFromDate:date];
    return year.integerValue;
}

+ (NSInteger)second:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"ss";
    NSString *year = [formatter stringFromDate:date];
    return year.integerValue;
}


#pragma mark - setter
- (void)setAd_pic:(NSString *)ad_pic {
    _ad_pic = ad_pic;
    if (ad_pic.length == 0 || ad_pic == nil) {
        SDK_USERDEFAULTS_SAVE_OBJECT(@"", @"ad_pic");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ad_pic_imageData"];
        syLog(@"移除图片");
        return;
    }

    NSString *oldAd_pic = SDK_USERDEFAULTS_GET_OBJECT(@"ad_pic");
    NSData *imageData = SDK_USERDEFAULTS_GET_OBJECT(@"ad_pic_imageData");

    if ([ad_pic isEqualToString:oldAd_pic] && imageData != nil) {
        syLog(@"已经有相同的图片");
        return;
    }

    if (ad_pic.length > 0) {
        syLog(@"ad pic === %@",_ad_pic);
        dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
        dispatch_async(globalQueue, ^{
            syLog(@"开始下载图片:%@", [NSThread currentThread]);

            NSString *imageStr = [NSString stringWithFormat:@"%@%@",[MapModel sharedModel].ASSET_URL,_ad_pic];
            NSURL *imageURL = [NSURL URLWithString:imageStr];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];

            dispatch_async(dispatch_get_main_queue(), ^{
                syLog(@"图片下载完成");
                SDK_USERDEFAULTS_SAVE_OBJECT(ad_pic, @"ad_pic");
                SDK_USERDEFAULTS_SAVE_OBJECT(imageData, @"ad_pic_imageData");
            });

        });
    }
}

- (void)setStatic_type:(NSArray *)static_type {
    _static_type = static_type;
    [SYStatisticsModel sharedModel].static_type = static_type;
}


/** 上报数据 */
+ (void)reportDataWithType:(NSUInteger)type ServerID:(NSString *)serverID ServerName:(NSString *)serverName RoleID:(NSString *)roleID RoleName:(NSString *)roleName RoleLevel:(NSString *)roleLevel Money:(NSString *)money VipLevel:(NSString *)vipLevel {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    NSArray *array = @[@"type",@"channel",@"appid",@"deviceID",@"userID",
                       @"serverID",@"serverName",@"roleID",@"roleName",@"roleLevel"
                       ,@"money",@"vip"];

    if ([UserModel currentUser].uid == nil || SDK_GETUID.length < 1) {

        syLog(@"用户尚未登录");
        return;
    }

    [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)type] forKey:@"type"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:[SDKModel sharedModel].AppID forKey:@"appid"];
    [dict setObject:SDK_GETDEVICEID forKey:@"deviceID"];
    [dict setObject:SDK_GETUID forKey:@"userID"];


    [dict setObject:serverID ? serverID : @"" forKey:@"serverID"];
    [dict setObject:serverName ? serverName : @"" forKey:@"serverName"];
    [dict setObject:roleID ? roleID : @"" forKey:@"roleID"];
    [dict setObject:roleName ? roleName : @"" forKey:@"roleName"];
    [dict setObject:roleLevel ? roleLevel : @"" forKey:@"roleLevel"];
    [dict setObject:money ?: @"" forKey:@"money"];
    [dict setObject:vipLevel ?: @"" forKey:@"vip"];

    [dict setObject:SDK_GETSIGN(dict, array) forKey:@"sign"];

//    SDK_Log(([NSString stringWithFormat:@"准备上报数据%@",dict]));

    [RequestTool postRequestWithURL:[MapModel sharedModel].REPORT_DATA params:dict completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            SDK_Log(@"数据上报成功");
        } else {
            SDK_Log(@"数据上报失败");
        }
    }];
}


#pragma mark - setter
- (void)setBox_url:(NSString *)box_url {
    if (box_url) {
        syLog(@"\n----------------------\n设置 boxurl \n------------------\n");
        _box_url = [NSString stringWithFormat:@"%@",box_url];
    }
}


@end









