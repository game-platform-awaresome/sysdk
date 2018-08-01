//
//  SYStatisticsModel.m
//  SY_185SDK
//
//  Created by 燚 on 2018/5/31.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "SYStatisticsModel.h"
#import "Tracking.h"
#import "SDKModel.h"
#import "DeviceModel.h"


#define TRACKING_APPKEY @"ffcaffb5979b3df9ff12751857fc88fa"

@interface SYStatisticsModel ()

@property (nonatomic, strong) NSArray *statisticsArray;

@end


static SYStatisticsModel *model = nil;
@implementation SYStatisticsModel
+ (SYStatisticsModel *)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[SYStatisticsModel alloc] init];
        }
    });
    return model;
}
#pragma mark - setter
- (void)setStatic_type:(NSArray *)static_type {
    _static_type = static_type;
    _statisticsArray = static_type;
    _static_type = [NSArray arrayWithArray:static_type];
    syLog(@"static model === %@",_static_type);
}
@end


/** 热云统计初始化 */
void trackingStatisticsInit(NSString *key);
/** 热云登录统计 */
void trackLoginStatistics(NSString *account);
/** 热云注册统计 */
void trackRegistStatistics(NSString *account);

/** 初始化统计 */
void initStatisticsModel() {
    syLog(@"初始化");
    if ([SYStatisticsModel sharedModel].static_type.count == 0 || [SYStatisticsModel sharedModel].static_type == nil) {
        return;
    } else {
        for (NSDictionary *dict in [SYStatisticsModel sharedModel].static_type) {
            NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
            NSString *key = [NSString stringWithFormat:@"%@",dict[@"key"]];
            if (type.integerValue == 1)  trackingStatisticsInit(key);
        }
    }
}
#pragma mark -------------------------------- login
/** 登录统计 */
void loginStatistics(NSString *account) {
    syLog(@"登录统计");
    if (account != nil) {
        for (NSDictionary *dict in [SYStatisticsModel sharedModel].static_type) {
            NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
            if (type.integerValue == 1)  trackLoginStatistics(account);
        }
    }
}
#pragma mark -------------------------------- regist
/** 注册统计 */
void registStatistics(NSString *account) {
    if (account != nil) {
        for (NSDictionary *dict in [SYStatisticsModel sharedModel].static_type) {
            NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
            if (type.integerValue == 1)  trackRegistStatistics(account);
        }
    }
}
#pragma mark - 热云统计
/** 热云初始化 */
void trackingStatisticsInit(NSString *key) {
    syLog(@"热云初始化统计");
    NSString *channelID = [NSString stringWithFormat:@"%@-%@",[SDKModel sharedModel].appid,[SDKModel sharedModel].channel];
    [Tracking initWithAppKey:key withChannelId:channelID];
}

/** 登录统计 */
void trackLoginStatistics(NSString *account) {
    syLog(@"热云登录统计");
    [Tracking setLoginWithAccountID:account];
}

/** 注册统计 */
void trackRegistStatistics(NSString *account) {
    syLog(@"热云注册统计");
    [Tracking setRegisterWithAccountID:account];
}






