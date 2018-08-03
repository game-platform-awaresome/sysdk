//
//  InfomationTool.m
//  SY_185SDK
//
//  Created by 燚 on 2017/9/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "InfomationTool.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "SYKeychain.h"
#import "LoginController.h"
#import "SDKModel.h"

#define KEYCHAINSERVICE @"tenoneTec.com"
#define DEVICEID @"deviceID%forBTWanSDK"
#define DEVICE_CHANNEL @"device(_Channel"
#define DEVICE_CHANNEL_STRING @"device(_Channel_string"

#import "LoginController.h"
#import "SYFloatViewController.h"


@implementation InfomationTool

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

/** 设备型号 */
+ (NSString *)phoneType {

    struct utsname systemInfo;

    uname(&systemInfo);

    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];


    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";

    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";

    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";

    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";

    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";

    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";

    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";

    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";

    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";

    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";

    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";

    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";

    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";

    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";

    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";

    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";

    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";

    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";

    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";

    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";

    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";

    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";

    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";

    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";

    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";

    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";

    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";

    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";

    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";

    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";

    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";

    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";

    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";

    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";

    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";

    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";

    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";

    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";

    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";

    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";

    return platform;

}

/** 系统版本 */
+ (NSString *)systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

/** 运营商 */
+ (NSString *)MobilePhoneOperators {
    NSString *ret = nil;

    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];

    CTCarrier *carrier = [info subscriberCellularProvider];

    if (carrier == nil) {
        return @"Simulator";
    }

    NSString *code = [carrier mobileNetworkCode];

    if ([code isEqual: @""]) {
        return @"1";
    }

    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
        ret = @"BTWanSDK_中国移动";
    }

    if ([code isEqualToString:@"01"]|| [code isEqualToString:@"06"] ) {
        ret = @"BTWanSDK_中国联通";
    }

    if ([code isEqualToString:@"03"]|| [code isEqualToString:@"05"] ) {
        ret = @"BTWanSDK_中国电信";;
    }
    return ret;
}

/** 网络信号 */
+ (NSString *)netWrokStates {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = nil;
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];

            switch (netType) {
                case 0:
                    state = @"0";   //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                    state = @"wifi";
                    break;
                default:
                    state = @"0";
                    break;
            }
        }
        //根据状态选择
    }
    return state;
}

/** 游戏的版本 */
+ (NSString *)appVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [infoDic objectForKey:@"CFBundleShortVersionString"];
}

/** 获取 sdk bundle */
+ (NSBundle *)getBundle {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[InfomationTool class]] pathForResource:@"SY_185SDK" ofType:@"framework"]];

    if (bundle == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SY_185SDK_RES" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    } else {
        NSString *path = [bundle pathForResource:@"SY_185SDK_RES" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    }

//    syLog(@"bundle === %@",bundle);

    return  bundle;
}

/** 获取 bundle 下的文件 */
+ (NSString *)getBundlePath: (NSString *) bundleName {
    NSBundle *myBundle = [InfomationTool getBundle];

    if (myBundle && bundleName) {
        return [[myBundle resourcePath] stringByAppendingPathComponent: bundleName];
    }
    return nil;
}

/** 根据 url 保存图片 */
+ (void)saveAdImageWithUrl:(NSString *)url {
    if (url && url.length > 1) {

        NSString * strUrl = [NSString stringWithFormat:@"%@",url];

        NSURLSession * session  = [NSURLSession sharedSession];

        NSURLSessionTask * task = [session dataTaskWithURL:[NSURL URLWithString:strUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            if (error == nil && data) {

                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

                NSString *imageFilePath = [path stringByAppendingPathComponent:@"SDK_AD_IMAGE"];

                [data writeToFile:imageFilePath atomically:YES];

            }

        }];
        [task resume];
    }
}

/** 获取保存的图片 */
+ (NSData *)getAdImage {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:@"SDK_AD_IMAGE"];
    NSData *data = [NSData dataWithContentsOfFile:imageFilePath];
    return data;
}


/** 开始等待动画 */
+ (void)startAinmationWithView {
    UIViewController *vc = [InfomationTool rootViewController];
    if (!vc) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [InfomationTool startAinmationWithView];
        });
    } else {
        [InfomationTool animationBack].frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [InfomationTool animationView].center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
        [vc.view addSubview:[InfomationTool animationBack]];
        [[InfomationTool animationView] startAnimating];
    }
}

/** 开始等待动画 */
+ (void)startWaitAnimation {
    if ([LoginController isInit]) {
        [InfomationTool startAinmationWithView];
    } else {
        [InfomationTool stopWaitAnimation];
    }
}

/** 结束等待动画 */ 
+ (void)stopWaitAnimation {
    [[InfomationTool animationBack] removeFromSuperview];
    [[InfomationTool animationView] stopAnimating];
}


//动画背景
static UIView *_animationBack = nil;
+ (UIView *)animationBack {
    if (!_animationBack) {
        _animationBack = [[UIView alloc] init];
        _animationBack.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        _animationBack.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.2];
        [_animationBack addSubview:[InfomationTool animationView]];
    }
    return _animationBack;
}

static UIImageView *_animationView = nil;
+ (UIImageView *)animationView {
    if (!_animationView) {
        _animationView = [[UIImageView alloc] init];
        _animationView.bounds = CGRectMake(0, 0, 44, 44);
        _animationView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);

        NSMutableArray<UIImage *> *imageArray = [NSMutableArray array];

        for (NSInteger i = 1; i <= 12; i++) {

            NSString *str = [NSString stringWithFormat:@"SDK_Animation%ld",(long)i];

            UIImage *image = SDK_IMAGE(str);
            if (image) {

                [imageArray addObject:image];
            }
        }

        _animationView.animationImages = imageArray;
        _animationView.animationDuration = 0.8;
        _animationView.animationRepeatCount = 1111111;
    }
    return _animationView;
}

/** 根视图 */
+ (UIViewController *)rootViewController {
    if ([SDKModel sharedModel].useWindow) {
        UIViewController *controller = [InfomationTool rooViewControllerWithWindow:[InfomationTool windowWithWindowLevel:SDK_WINDOW_LEVEL]];
        return controller;
    } else {
        UIViewController *controller = [InfomationTool rooViewControllerWithWindow:[InfomationTool windowWithWindowLevel:GAME_WINDOW_LEVEL]];
        return controller;
    }
}

+ (UIView *)gameView {
    return [InfomationTool windowWithWindowLevel:GAME_WINDOW_LEVEL].rootViewController.view;
}

+ (UIWindow *)windowWithWindowLevel:(UIWindowLevel)level {

    NSArray<UIWindow *> *windows = [[UIApplication sharedApplication] windows];

    if (windows == nil || windows.count == 0) {
//        __LOGFUNC__;
        NSLog(@"error !!!!!! window is not load!!!!!!");
        return nil;

    } else if (windows.count == 1) {

        return windows[0].windowLevel == level ? windows[0] : [[UIApplication sharedApplication] keyWindow];

    } else {

        UIWindow *window = [[UIApplication sharedApplication] keyWindow];

        if (window.windowLevel != level) {
            for (UIWindow * tmpWin in windows) {
                if (tmpWin.windowLevel == level) {
                    window = tmpWin;
                    break;
                }
            }
        }

        return window;
    }
}

+ (UIViewController *)rooViewControllerWithWindow:(UIWindow *)window {

//    syLog(@"sdk_window_level = %f",window.windowLevel);

    UIViewController *result = nil;

    NSArray<UIView *> *views = [window subviews];

    if (views == nil || views.count == 0) {
//        __LOGFUNC__;
        NSLog(@"error !!!!!! don't have any views!!!!!!");
        return nil;
    }

    UIView *frontView = [views objectAtIndex:0];

    id nextResponder = [frontView nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }

    return result;
}

+ (void)showAlertMessage:(NSString *)message dismissTime:(float)second dismiss:(void (^)(void))dismiss  {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];

//    [[InfomationTool rootViewController] presentViewController:alertController animated:YES completion:nil];

    if ([LoginController sharedController].isShow) {
        [[LoginController sharedController] presentViewController:alertController animated:YES completion:nil];
    } else if ([SYFloatViewController sharedController].currentController) {
        [[SYFloatViewController sharedController].currentController presentViewController:alertController animated:YES completion:nil];
    } else {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }

//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:^{
            if (dismiss) {
                dismiss();
            }
        }];
    });

//    addtwonumber(5, 4);
}

bool addtwonumber(int a , int b) {

//    NSNumber *number = [NSNumber numberWithBool:YES];
    return a + b;
}


@end










