//
//  BTWanInterface.m
//  BTWanSDK
//
//  Created by 燚 on 2018/8/27.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "BTWanInterface.h"
#import "SYPayController.h"
#import "LoginController.h"
#import "SY_GMSDK.h"
#import "SYFloatViewController.h"
#import "SDK_ADImage.h"
#import "SYStatisticsModel.h"

//new
#import "SYLoginViewController.h"


@interface BTWanSDK ()
<LoginControllerDeleagete,
SYfloatViewDelegate,
SYPayControllerDeleagete,
GMFunctionDelegate,
ADImageDelegate>

@property (nonatomic, weak) id<BTWanCallBackDelegate> delegate;


@end


static BTWanSDK *_btWanSDK = nil;
@implementation BTWanSDK

#pragma mark - init method
+ (BTWanSDK *)sharedSDK {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_btWanSDK == nil) {
            _btWanSDK = [[BTWanSDK alloc] init];
        }
    });
    return _btWanSDK;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setCallBackBlock];
    }
    return self;
}

#pragma mark - call back block
- (void)setCallBackBlock {
    //登录回调
//    [LoginViewController setLoginResult:^(BOOL success, NSDictionary *content) {
//
//    }];

    //登出回调
//    [LoginViewController setLogoutResult:^(BOOL success, NSDictionary *content) {
//
//    }];
}



#pragma mark - interface method
/** 控制台显示信息 */
+ (void)SDKShowMessage {
    [[self sharedSDK] SDKShowMessage];
}

/** 注册为默认SDK(此方法为接入融合SDK使用) */
+ (void)resignDefaultSDK {
    [self sharedSDK];
}

/**
 * 初始化 SDK 方法(此方法为接入 GM功能 SDK 使用)
 * @param appID 初始化SDK使用的AppID
 * @param appkey    初始化SDK使用的AppKey
 * @param delegate  用于接收初始化,登录,支付等回调的实例
 * @warning 所有参数不能为空.
 */
+ (void)initWithAppID:(NSString * _Nonnull)appID
               Appkey:(NSString * _Nonnull)appkey
     CallBackDelegate:(id<BTWanCallBackDelegate> _Nonnull)delegate {
    [[self sharedSDK] initWithAppID:appID Appkey:appkey CallBackDelegate:delegate];
}

/** 登录 */
+ (void)login {
    [[self sharedSDK] login];
}

/** 登出 */
+ (void)logOut {
    [[self sharedSDK] logOut];
}

/** 发起支付 : data 传 BTWanPayData 类型 */
+ (void)pay:(id)data {
    [[self sharedSDK] pay:data];
}

/** 上报数据 : data 传 BTWanExtraData 类型 */
+ (void)submitExtraData:(id)data {
    [[self sharedSDK] submitExtraData:data];
}

/**
 * GM 功能初始化
 * @param serverID      服务器 ID
 * @param serverName    服务器名称
 * @param roleID        角色 ID
 * @param roleName      角色名称
 */
+ (void)initGMFunctionWithServerid:(NSString *_Nonnull)serverID
                        ServerName:(NSString *_Nonnull)serverName
                            RoleID:(NSString *_Nonnull)roleID
                          RoleName:(NSString *_Nonnull)roleName {

    [[self sharedSDK]initGMFunctionWithServerid:serverID
                                     ServerName:serverName
                                         RoleID:roleID
                                       RoleName:roleName];

}


#pragma mark - provite method
/** 控制台显示信息 */
- (void)SDKShowMessage {
//    [SDKModel sharedModel].showMessage = YES;
}

- (void)initWithAppID:(NSString * _Nonnull)appID
               Appkey:(NSString * _Nonnull)appkey
     CallBackDelegate:(id<BTWanCallBackDelegate> _Nonnull)delegate {
    SDKLOG(@"init start");

    SDK_Log(@"开始设置初始化信息");
    //设置代理
    self.delegate = delegate;

    //请求映射 url
    [[MapModel sharedModel] getMapUrl:nil];

    //设置 appkey
    [SDKModel sharedModel].AppKey = appkey;

    SDK_Log(@"结束设置初始化信息");
    SDK_Log(@"开始请求 SDK 初始化");
    //初始化 app
    SDK_START_ANIMATION;
    [[SDKModel sharedModel] initWithApp:appID Appkey:appkey completion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;
        //返回初始化结果
        SDK_Log(@"结束请求 SDK 初始化");
        if (success) {
            SDKLOG(@"init success");
            syLog(@"init content === %@",content);

            SDK_Log(@"初始化请求成功");
            SDK_Log(@"开始设置初始化信息");
            //保存数据
            [[SDKModel sharedModel] setAllPropertyWithDict:SDK_CONTENT_DATA];
            [SDKModel sharedModel].AppID = appID;
            [SDKModel sharedModel].AppKey = appkey;
            //设置是否加速
            [SYFloatViewController sharedController].allowSpeed = [SDKModel sharedModel].is_accelerate.boolValue;
            [SYFloatViewController sharedController].delegate = self;
            /** 用户登出 */
            SDK_USER_SELF_LOGOUT(@"0");
            SDK_Log(@"结束设置初始化信息");
            /** 显示广告图片 */
            BOOL showAdImage = [SDK_ADImage showADImageWithDelegate:self andStatus:content[@"status"]];
            if (showAdImage == NO) {
                /** 发送回调 */
                [self returnM185SDkInitResuldWithSucces:success andStatus:content[@"status"]];
            }
            /** 初始化统计 */
            initStatisticsModel();
        } else {
            NSString *status = content[@"status"];
            SDK_Log(@"初始化 SDK 失败");
            if (status.integerValue == 404) {
                SDK_Log(@"初始化 SDK 失败 : 没有网络");
                SDK_Log(@"等待重新请求初始化");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    SDKLOG(@"time out reinit");
                    SDK_Log(@"重新请求初始化");
                    [self initWithAppID:appID Appkey:appkey CallBackDelegate:delegate];
                });
            } else {
                SDKLOG(@"init failure");
                [self returnM185SDkInitResuldWithSucces:success andStatus:content[@"status"]];
            }
        }
        SDKLOG(@"init end");
    }];
}

/** 登录 */
- (void)login {
    SDKLOG(@"show float view");
    SDK_Log(@"显示登录页面");
    if ([SDKModel sharedModel].AppID) {
        [LoginController showLoginViewUseTheWindow:[SDKModel sharedModel].useWindow WithDelegate:self];
    } else {
        SDK_MESSAGE(@"正在初始化或未接入网络,请稍后尝试");
    }
}

/** 登出 */
- (void)logOut {
    SDKLOG(@"external sign out");
    SDK_Log(@"SDK 登出");
    [[SYFloatViewController sharedController] resignOut];
    [SY_GMSDK logOut];
}

/** 发起支付 : data 传 BTWanPayData 类型 */
- (void)pay:(id)data {
//     [SYPayController payStartWithServerID:serverID serverName:serverName roleID:roleID roleName:roleName productID:productID productName:productName amount:amount originalPrice:nil extension:extension Delegate:[SY185SDK sharedSDK]];
}

/** 上报数据 : data 传 BTWanExtraData 类型 */
- (void)submitExtraData:(id)data {

}


- (void)initGMFunctionWithServerid:(NSString *_Nonnull)serverID
                        ServerName:(NSString *_Nonnull)serverName
                            RoleID:(NSString *_Nonnull)roleID
                          RoleName:(NSString *_Nonnull)roleName {
    if ([SDKModel sharedModel].AppID == nil || [[SDKModel sharedModel].AppID isEqualToString:@""]) {
        SDK_MESSAGE(@"GM 权限初始化失败\nSDK 尚未初始化");
        return;
    }

    if ([SDKModel sharedModel].AppKey == nil || [[SDKModel sharedModel].AppKey isEqualToString:@""]) {
        SDK_MESSAGE(@"GM 权限初始化失败\nSDK 尚未初始化");
        return;
    }

    if ([UserModel currentUser].username == nil || [[UserModel currentUser].username isEqualToString:@""]) {
        SDK_MESSAGE(@"用户尚未登录");
        return;
    }

    if ([UserModel currentUser].uid == nil || [[UserModel currentUser].uid isEqualToString:@""]) {
        SDK_MESSAGE(@"用户尚未登录");
        return;
    }

    [SY_GMSDK initGM_SDKWithAppid:[SDKModel sharedModel].AppID AppKey:[SDKModel sharedModel].AppKey Channel:SDK_GETCHANNELID Serverid:serverID ServerName:serverName UserName:[UserModel currentUser].username Uid:SDK_GETUID Role_di:roleID Role_name:roleName InitUrl:[MapModel sharedModel].GM_INIT PropListUrl:[MapModel sharedModel].GM_GET_PROP SendPropUrl:[MapModel sharedModel].GM_SEND_PROP UseWindow:[SDKModel sharedModel].useWindow Delegate:self];
}


#pragma mark - custome method
/** 隐藏广告业 */
- (void)m185ADImage:(SDK_ADImage *)ADImage respondsToCloseButton:(id)info {
    /** 发送回调 */
    [self returnM185SDkInitResuldWithSucces:YES andStatus:info];
}


/** 返回初始化结果代理 */
- (void)returnM185SDkInitResuldWithSucces:(BOOL)success andStatus:(NSString *)status {
    SDKLOG(@"init call back start");
    SDK_Log(@"开始返回初始化结果");
    NSDictionary *dict = nil;
    if (success && status.integerValue == 1) {
        success = YES;
        dict = @{@"status":@"1",@"状态":@"初始化成功"};
    } else {
        success = NO;
        dict = @{@"status":@"0",@"状态":@"初始化失败"};
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(BTWanSDKInitCallBackWithSuccess:Information:)]) {
        [self.delegate BTWanSDKInitCallBackWithSuccess:success Information:dict];
    }
    SDK_Log(@"结束返回初始化结果");
    SDKLOG(@"init call back end");
}

#pragma mark - GM SDK delegate
/** 初始化成功回调 */
- (void)GMSDK:(SY_GMSDK *)sdk initSuccess:(BOOL)success {
    if (success) {
        SDKLOG(@"GM fuction initialize success");
    } else {
        SDKLOG(@"GM function initialize failure");
    }
}

/** 发起支付回调 */
- (void)GMSDKPayStartServerID:(NSString *)serverID
                   serverName:(NSString *)serverName
                       roleID:(NSString *)roleID
                     roleName:(NSString *)roleName
                    productID:(NSString *)productID
                  productName:(NSString *)productName
                       amount:(NSString *)amount
                    extension:(NSString *)extension {

    [SYPayController GMPayStartWithServerID:serverID serverName:serverName roleID:roleID roleName:roleName productID:productID productName:productName amount:amount extension:extension Delegate:self];
}

/** 发送道具成功的回调 */
- (void)GMSDK:(SY_GMSDK *)sdk SendPropsSuccess:(BOOL)success WithInfo:(NSDictionary *)dict {
    if (self.delegate && [self.delegate respondsToSelector:@selector(BTWanSDKGMFunctionSendPropsCallBackWithSuccess:Information:)]) {
        [self.delegate BTWanSDKGMFunctionSendPropsCallBackWithSuccess:YES Information:dict];
    }
}



#pragma mark - float delegate user logout
- (void)userSignOut {
    [SY_GMSDK logOut];
    SDK_Log(@"用户登出");
    if (self.delegate && [self.delegate respondsToSelector:@selector(BTWanSDKLogOutCallBackWithSuccess:Information:)]) {
        [self.delegate BTWanSDKLogOutCallBackWithSuccess:YES Information:@{@"msg":@"user sign out"}];
    }
}



#pragma mark - loginDelegate
- (void)loginController:(LoginController *)loginController loginSuccess:(BOOL)success withStatus:(NSDictionary *)dict {
    SDKLOG(@"login call back start");
    SDK_Log(@"开始登录回调");

    if ([UserModel currentUser].switchAccount) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(BTWanSDKLoginCallBackWithSuccess:Information:)]) {
            [self.delegate BTWanSDKLoginCallBackWithSuccess:success Information:dict];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(BTWanSDKLoginCallBackWithSuccess:Information:)]) {
            [self.delegate BTWanSDKLoginCallBackWithSuccess:success Information:dict];
        }
    }

    [UserModel currentUser].switchAccount = NO;

    if (success) {

        syLog(@"channel = %@",[SDKModel sharedModel].channel);
#ifdef DEBUG
        //        if ([SDKModel sharedModel].isdisplay_buoy.boolValue) {
        //            SDK_Log(@"显示悬浮标");
        [self showFloatView];
        //        }
#else
        if ([SDKModel sharedModel].isdisplay_buoy.boolValue) {
            SDK_Log(@"显示悬浮标");
            [self showFloatView];
        }


#endif
    }


    SDK_Log(@"结束登录回调");
    SDKLOG(@"login call back end");
}

#pragma mark - pay delegate
- (void)m185_PayDelegateWithPaySuccess:(BOOL)success WithInformation:(NSDictionary *)dict {
    SDKLOG(@"pay call back start");
    SDK_Log(@"开始支付回调");
    if (self.delegate && [self.delegate respondsToSelector:@selector(BTWanSDKRechargeCallBackWithSuccess:Information:)]) {
        [self.delegate BTWanSDKRechargeCallBackWithSuccess:success Information:dict];
    }
    SDK_Log(@"结束支付回调");
    SDKLOG(@"pay call back end");
}


#pragma mark - float view
- (void)showFloatView {
    [SYFloatViewController showFloatView];
}










@end




























