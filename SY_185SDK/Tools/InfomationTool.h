//
//  InfomationTool.h
//  SY_185SDK
//
//  Created by 燚 on 2017/9/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfomationTool : NSObject

/* 设备 ID */
+ (NSString *)deviceID;

/** 检查渠道号 */
+ (NSString *)cheackChannel;

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

/** 保存广告图片 */
+ (void)saveAdImageWithUrl:(NSString *)url;

/** 获取广告图片 */
+ (NSData *)getAdImage;

/** 获取 bundle 下的 resource */
+ (NSString *)getBundlePath: (NSString *)bundleName;
+ (NSBundle *)getBundle;

/** 根视图 */
+ (UIViewController *)rootViewController;
/** 游戏视图 */
+ (UIView *)gameView;


/** 开始等待动画 */
+ (void)startWaitAnimation;
/** 结束等待动画 */
+ (void)stopWaitAnimation;
+ (UIView *)animationBack;
+ (UIImageView *)animationView;


/** 显示提示框 */
+ (void)showAlertMessage:(NSString *)message dismissTime:(float)second dismiss:(void(^)(void))dismiss;




@end
