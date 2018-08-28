//
//  SY185SDK.m
//  SY_185SDK
//
//  Created by 燚 on 2017/9/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SY185SDK.h"
#import "SYPayController.h"
#import "LoginController.h"
#import "SY_GMSDK.h"
#import "SYFloatViewController.h"
#import "SDK_ADImage.h"
#import "SYStatisticsModel.h"


#ifdef DEBUG
#import "SYDeviceTool.h"
#import "SYSDKModel.h"
#endif

//new
#import "SYLoginViewController.h"


@interface SY185SDK ()
<LoginControllerDeleagete,
SYfloatViewDelegate,
SYPayControllerDeleagete,
GMFunctionDelegate,
ADImageDelegate>

@property (nonatomic, weak) id<SY185SDKDelegate> delegate;

@end

static SY185SDK *sdk = nil;

@implementation SY185SDK

+ (SY185SDK *)sharedSDK {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sdk == nil) {
            sdk = [[SY185SDK alloc] init];
#ifdef DEBUG
            [sdk testFunction];
#endif
        }
    });
    return sdk;
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
    [LoginViewController setLoginResult:^(BOOL success, NSDictionary *content) {

    }];

    //登出回调
    [LoginViewController setLogoutResult:^(BOOL success, NSDictionary *content) {

    }];
}

+ (void)SDKShowMessage {
    [SDKModel sharedModel].showMessage = YES;
}

+ (void)resignDefaultSDK {
    [SY185SDK sharedSDK];
}

#pragma mark - sdk init

+ (void)initWithAppID:(NSString *)appID Appkey:(NSString *)appkey Delegate:(id)delegate UseWindow:(BOOL)useWindow {
    SDKLOG(@"init start");

    SDK_Log(@"开始设置初始化信息");
    //设置代理
    [SY185SDK sharedSDK].delegate = delegate;

    //请求映射 url
    [[MapModel sharedModel] getMapUrl:nil];

    //是否使用 window
    [SDKModel sharedModel].useWindow = useWindow;

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
            [SYFloatViewController sharedController].delegate = [SY185SDK sharedSDK];
            /** 用户登出 */
            SDK_USER_SELF_LOGOUT(@"0");
            SDK_Log(@"结束设置初始化信息");
            /** 显示广告图片 */
            BOOL showAdImage = [SDK_ADImage showADImageWithDelegate:[SY185SDK sharedSDK] andStatus:content[@"status"]];
            if (showAdImage == NO) {
                /** 发送回调 */
                [SY185SDK returnM185SDkInitResuldWithSucces:success andStatus:content[@"status"]];
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
                    [SY185SDK initWithAppID:appID Appkey:appkey Delegate:delegate UseWindow:useWindow];
                });
            } else {
                SDKLOG(@"init failure");
                [SY185SDK returnM185SDkInitResuldWithSucces:success andStatus:content[@"status"]];
            }
        }
        SDKLOG(@"init end");
    }];
}


#pragma mark  - init method
/** 隐藏广告业 */
- (void)m185ADImage:(SDK_ADImage *)ADImage respondsToCloseButton:(id)info {
    /** 发送回调 */
    [SY185SDK returnM185SDkInitResuldWithSucces:YES andStatus:info];
}


/** 返回初始化结果代理 */
+ (void)returnM185SDkInitResuldWithSucces:(BOOL)success andStatus:(NSString *)status {
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

    if (sdk && sdk.delegate && [sdk.delegate respondsToSelector:@selector(m185SDKInitCallBackWithSuccess:withInformation:)]) {
        [sdk.delegate m185SDKInitCallBackWithSuccess:success withInformation:dict];
    }
    SDK_Log(@"结束返回初始化结果");
    SDKLOG(@"init call back end");
}

#pragma mark - logout
+ (void)signOut {
    SDKLOG(@"external sign out");
    SDK_Log(@"SDK 登出");
    [[SYFloatViewController sharedController] resignOut];
    [SY_GMSDK logOut];
//    [UserModel logOut];
}

#pragma mark - float delegate user logout
- (void)userSignOut {
    [SY_GMSDK logOut];
    SDK_Log(@"用户登出");
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185SDKLogOutCallBackWithSuccess:withInformation:)]) {
        [self.delegate m185SDKLogOutCallBackWithSuccess:YES withInformation:@{@"msg":@"user sign out"}];
    }
}

#pragma mark - use window
+ (void)SDKUseWindow:(BOOL)useWindow {
    [SDKModel sharedModel].useWindow = useWindow;
}

#pragma mark - showLoginView
+ (BOOL)showLoginView {
    SDKLOG(@"show float view");
    SDK_Log(@"显示登录页面");
    if ([SDKModel sharedModel].AppID) {
        [LoginController showLoginViewUseTheWindow:[SDKModel sharedModel].useWindow WithDelegate:sdk];
//        [SYLoginViewController showLoginView];
    } else {
        SDK_MESSAGE(@"正在初始化或未接入网络,请稍后尝试");
    }
    return YES;
}

#pragma mark - pay
+ (void)payStartWithServerID:(NSString *)serverID serverName:(NSString *)serverName roleID:(NSString *)roleID roleName:(NSString *)roleName productID:(NSString *)productID productName:(NSString *)productName amount:(NSString *)amount extension:(NSString *)extension {

    [SYPayController payStartWithServerID:serverID serverName:serverName roleID:roleID roleName:roleName productID:productID productName:productName amount:amount originalPrice:nil extension:extension Delegate:[SY185SDK sharedSDK]];


}

#pragma mark - loginDelegate
- (void)loginController:(LoginController *)loginController loginSuccess:(BOOL)success withStatus:(NSDictionary *)dict {
    SDKLOG(@"login call back start");
    SDK_Log(@"开始登录回调");
    
    if ([UserModel currentUser].switchAccount) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(m185SDKSwitchAccountCallBackWithSuccess:withInformation:)]) {
            [self.delegate m185SDKSwitchAccountCallBackWithSuccess:success withInformation:dict];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(m185SDKLoginCallBackWithSuccess:withInformation:)]) {
            [self.delegate m185SDKLoginCallBackWithSuccess:success withInformation:dict];
        }
    }
    
    [UserModel currentUser].switchAccount = NO;

    if (success) {

        syLog(@"channel = %@",[SDKModel sharedModel].channel);
#warning show float view

#ifdef DEBUG
//        if ([SDKModel sharedModel].isdisplay_buoy.boolValue) {
//            SDK_Log(@"显示悬浮标");
            [SY185SDK showFloatView];
//        }
#else
        if ([SDKModel sharedModel].isdisplay_buoy.boolValue) {
            SDK_Log(@"显示悬浮标");
            [SY185SDK showFloatView];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185SDKRechargeCallBackWithSuccess:withInformation:)]) {
        [self.delegate m185SDKRechargeCallBackWithSuccess:success withInformation:dict];
    }
    SDK_Log(@"结束支付回调");
    SDKLOG(@"pay call back end");
}

#pragma mark - float view
+ (void)showFloatView {
    [SYFloatViewController showFloatView];
}


#pragma mark - ================================================================================
#pragma mark - GM SDK
+ (void)initGMFunctionWithServerid:(NSString *)serverID
                        ServerName:(NSString *)serverName
                            RoleID:(NSString *)roleID
                          RoleName:(NSString *)roleName {

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

    [SY_GMSDK initGM_SDKWithAppid:[SDKModel sharedModel].AppID AppKey:[SDKModel sharedModel].AppKey Channel:SDK_GETCHANNELID Serverid:serverID ServerName:serverName UserName:[UserModel currentUser].username Uid:SDK_GETUID Role_di:roleID Role_name:roleName InitUrl:[MapModel sharedModel].GM_INIT PropListUrl:[MapModel sharedModel].GM_GET_PROP SendPropUrl:[MapModel sharedModel].GM_SEND_PROP UseWindow:[SDKModel sharedModel].useWindow Delegate:[SY185SDK sharedSDK]];
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

    [SYPayController GMPayStartWithServerID:serverID serverName:serverName roleID:roleID roleName:roleName productID:productID productName:productName amount:amount extension:extension Delegate:[SY185SDK sharedSDK]];
}

/** 发送道具成功的回调 */
- (void)GMSDK:(SY_GMSDK *)sdk SendPropsSuccess:(BOOL)success WithInfo:(NSDictionary *)dict {
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185SDKGMFunctionSendPropsCallBackWithSuccess:withInformation:)]) {
        [self.delegate m185SDKGMFunctionSendPropsCallBackWithSuccess:YES withInformation:dict];
    }
}


#pragma mark - 数据上报
/**
 * 上报数据
 * @param type          上报数据的类型
 * @param serverID      服务器 ID
 * @param serverName    服务器名称
 * @param roleID        角色 ID
 * @param roleName      角色名称
 * @param roleLevel     角色等级
 * @param money         账号游戏币钻石等
 * @param vipLevel      VIP 等级,尽量填写数字字符,也可以接受字符串
 */
+ (void)submitExtraDataWithType:(SY185SDKReportType)type ServerID:(NSString *)serverID ServerName:(NSString *)serverName RoleID:(NSString *)roleID RoleName:(NSString *)roleName RoleLevel:(NSString *)roleLevel Money:(NSString *)money VipLevel:(NSString *)vipLevel {
    [SDKModel reportDataWithType:type ServerID:serverID ServerName:serverName RoleID:roleID RoleName:roleName RoleLevel:roleLevel Money:money VipLevel:vipLevel];
}




#pragma mark - test
- (void)testFunction {
    syLog(@"运营商  === %@",[SYDeviceTool MobilePhoneOperators]);
    syLog(@"属性类型 === %@",[SYSDKModel getAllPropertyTypeWithClass:[SYSDKModel class]]);
}





@end












