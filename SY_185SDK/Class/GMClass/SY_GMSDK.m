//
//  SY_GMSDK.m
//  SY_185SDK
//
//  Created by 燚 on 2017/10/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SY_GMSDK.h"
#import "GM_FloatViewController.h"

#define CHEACK_PARAMETER(parameter) \
if (parameter == nil || [parameter isEqualToString:@""]) {\
NSString *messsage = [NSString stringWithFormat:@"GMSDK初始化parameter参数错误"];\
SDK_MESSAGE(messsage);\
return;\
}

#define CHEACK_ALL_PARAMETERS   CHEACK_PARAMETER(appid);\
CHEACK_PARAMETER(appKey);\
CHEACK_PARAMETER(channel);\
CHEACK_PARAMETER(serverid);\
CHEACK_PARAMETER(username);\
CHEACK_PARAMETER(uid);\
CHEACK_PARAMETER(role_id);\
CHEACK_PARAMETER(role_name);\
CHEACK_PARAMETER(do_init_url);\
CHEACK_PARAMETER(get_prop_url);\
CHEACK_PARAMETER(send_prop_url)

#define SET_ALL_PARAMETERS_IN_DICT     NSDictionary *dict = @{@"appid":appid,@"appKey":appKey,@"channel":channel,\
@"serverid":serverid,@"serverName":serverName,\
@"username":username,@"uid":uid,\
@"role_id":role_id,@"role_name":role_name,\
@"do_init_url":do_init_url,\
@"get_prop_url":get_prop_url,\
@"send_prop_url":send_prop_url}

#define SELF_SDK ([SY_GMSDK sharedSDK])

@interface SY_GMSDK() <FloatControllerDelegate>

@end

static SY_GMSDK *sdk = nil;
static BOOL initing = NO;

@implementation SY_GMSDK

+ (SY_GMSDK *)sharedSDK {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sdk == nil) {
            sdk = [[SY_GMSDK alloc] init];
        }
    });
    return sdk;
}

+ (void)initGM_SDKWithAppid:(NSString *)appid
                     AppKey:(NSString *)appKey
                    Channel:(NSString *)channel
                   Serverid:(NSString *)serverid
                 ServerName:(NSString *)serverName
                   UserName:(NSString *)username
                        Uid:(NSString *)uid
                    Role_di:(NSString *)role_id
                  Role_name:(NSString *)role_name
                    InitUrl:(NSString *)do_init_url
                PropListUrl:(NSString *)get_prop_url
                SendPropUrl:(NSString *)send_prop_url
                  UseWindow:(BOOL)useWindow
                   Delegate:(id<GMFunctionDelegate>)delegate {

    SDKLOG(@"gm fuction init start");

    if (initing == YES) {
        SDKLOG(@"gm fuction is initializing");
        return;
    }
    initing = YES;

    SELF_SDK.delegate = delegate;

    CHEACK_ALL_PARAMETERS;

    SET_ALL_PARAMETERS_IN_DICT;

    [[GM_SDKModel sharedModel] setAllPropertyWithDict:dict];
    [GM_SDKModel sharedModel].useWindow = useWindow;

    /** 初始化 */
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [GM_SDKModel initGMSDKWithCompletion:^(NSDictionary *content, BOOL success) {

        initing = NO;

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        if (success) {

            //更新权限列表
            [GM_SDKModel sharedModel].GM_Authority_List = content[@"data"];
            //初始化成功
            [GM_SDKModel sharedModel].isInit = YES;
            //显示浮窗
            [GM_FloatViewController showFLoatView];
            //初始化成功回调
            [SY_GMSDK initSuccess];
            //            syLog(@"GM_SDK_INIT === %@",content);
        } else {
            REQUEST_STATUS;
            if (status.integerValue == 404) {
                initing = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SY_GMSDK initGM_SDKWithAppid:(NSString *)appid
                                           AppKey:(NSString *)appKey
                                          Channel:(NSString *)channel
                                         Serverid:(NSString *)serverid
                                       ServerName:(NSString *)serverName
                                         UserName:(NSString *)username
                                              Uid:(NSString *)uid
                                          Role_di:(NSString *)role_id
                                        Role_name:(NSString *)role_name
                                          InitUrl:(NSString *)do_init_url
                                      PropListUrl:(NSString *)get_prop_url
                                      SendPropUrl:(NSString *)send_prop_url
                                        UseWindow:(BOOL)useWindow
                                         Delegate:(id<GMFunctionDelegate>)delegate];
                });
            } else {
                SDK_MESSAGE(content[@"msg"]);
            }
            syLog(@"gm contetn = %@",content);
        }
    }];
}

+ (void)initSuccess {
    //设置悬浮窗代理
    [GM_FloatViewController sharedController].delegate = SELF_SDK;
    //初始化成功回调
    if (SELF_SDK.delegate && [SELF_SDK.delegate respondsToSelector:@selector(GMSDK:initSuccess:)]) {
        [SELF_SDK.delegate GMSDK:SELF_SDK initSuccess:YES];
    }
}

+ (void)refreshDetailPage {
    [GM_FloatViewController reloadGmData];
}

+ (void)logOut {
    [GM_FloatViewController logOut];
}


#pragma mark - float controller delegate
- (void)FloatController:(GM_FloatViewController *)controller openGmPermissionsWithDict:(NSDictionary *)dict {
    if (dict == nil) {
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(GMSDKPayStartServerID:serverName:roleID:roleName:productID:productName:amount:extension:)]) {

        if (!dict[@"gear_id"]) {
            return;
        }
        if (!dict[@"gear_name"]) {
            return;
        }
        if (!dict[@"gear_money"]) {
            return;
        }

        GM_SDKModel *model = [GM_SDKModel sharedModel];
        [self.delegate GMSDKPayStartServerID:model.serverid serverName:model.serverName roleID:model.role_id roleName:model.role_name productID:dict[@"gear_id"] productName:dict[@"gear_name"] amount:dict[@"gear_money"] extension:@""];

    }
}

/** 发送道具回调 */
- (void)FloatController:(GM_FloatViewController *)controller sendProposSuccessWithInfo:(NSDictionary *)dict {

    GM_SDKModel *model = [GM_SDKModel sharedModel];
    NSDictionary *callBack = @{@"power_id":model.gear_id,
                               @"prop_id":model.prop_id,
                               @"username":model.username,
                               @"server_id":model.serverid,
                               @"server_name":model.serverName,
                               @"role_id":model.role_id,
                               @"role_name":model.role_name,};

    if (self.delegate && [self.delegate respondsToSelector:@selector(GMSDK:SendPropsSuccess:WithInfo:)]) {
        [self.delegate GMSDK:self SendPropsSuccess:YES WithInfo:callBack];
    }
}





@end

















