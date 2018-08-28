//
//  UserModel.m
//  SY_185SDK
//
//  Created by 燚 on 2017/9/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "UserModel.h"
#import "MapModel.h"
#import "SDKModel.h"
#import "SYStatisticsModel.h"

#define MAP_URL [MapModel sharedModel]

#define REQUEST_COMPLETION \
REQUEST_STATUS;\
if (success) {\
    if (status.integerValue == 1) {\
        completion(content,true);\
    } else {\
        completion(@{@"status":content[@"status"],@"msg":content[@"msg"]},false);\
    }\
} else {\
    completion(@{@"status":@"404",@"msg":@"请求超时"},false);\
}\

static UserModel *userModel = nil;
static NSString *oneUpRegisterPassword = nil;

@interface UserModel ()


@end

@implementation UserModel


/** 手机验证码 */
+ (void)requestCodeWithType:(CodeMessage)codeType
            WithPhoneNumber:(NSString *)phoneNumber
                 completion:(void(^)(NSDictionary *content,BOOL success))completion {

    NSArray *pamarasKey = @[@"appid",@"mobile",@"type"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(unsigned long)codeType] forKey:@"type"];

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.USER_SEND_MESSAGE params:dict completion:completion];

}

#pragma mark =
/** 单利 */
+ (UserModel *)currentUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[UserModel alloc]init];
    });
    return userModel;
}

+ (NSString *)oneUpRegistPassword {
    if (oneUpRegisterPassword) {
        return oneUpRegisterPassword;
    }
    return nil;
}

+ (void)saveUserInfoWithDictionary:(NSDictionary *)content {
    if (content) {
        [userModel setAllPropertyWithDict:content];
    }
}


#pragma mark - username and password
/** 用户名登录 */
+ (void)userLoginWithUserName:(NSString *)username
                     PassWord:(NSString *)pwd
                   completion:(void (^)(NSDictionary *, BOOL))completion {
    NSArray *pamarasKey = @[@"username",@"type",@"password",@"appid",@"channel",@"system",@"machine_code"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:username forKey:@"username"];
    [dict setObject:@"1" forKey:@"type"];
    [dict setObject:pwd forKey:@"password"];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:SDK_GETDEVICEYYPE forKey:@"system"];
    [dict setObject:SDK_GETDEVICEID forKey:@"machine_code"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];
    [dict setObject:[InfomationTool cheackChannel] forKey:@"random"];
    syLog(@"login == %@",dict);
    [RequestTool postRequestWithURL:MAP_URL.USER_LOGIN params:dict completion:^(NSDictionary *content, BOOL success) {
//        syLog(@"%@",content);
        REQUEST_COMPLETION;
        if (status.integerValue == 1) {
            /** 保存 UID */
            (dict[@"id"]) ? [RequestTool saveUid:[NSString stringWithFormat:@"%@",dict[@"id"]]] : 0;
            /** 登录统计 */
            loginStatistics(username);
        }
    }];

}

/** 用户名注册 */
+ (void)userRegisterWithUserName:(NSString *)username
                        PassWord:(NSString *)pwd
                      completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"username",@"password",@"appid",@"channel",@"system",@"maker",@"mobile_model",@"machine_code",@"system_version"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:username forKey:@"username"];
    [dict setObject:pwd forKey:@"password"];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:SDK_GETDEVICEYYPE forKey:@"system"];
    [dict setObject:SDK_GETDEVICEMAKER forKey:@"maker"];
    [dict setObject:SDK_GETDEVICEMODEL forKey:@"mobile_model"];
    [dict setObject:SDK_GETDEVICEID forKey:@"machine_code"];
    [dict setObject:SDK_GETSYSTEMVERSION forKey:@"system_version"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];
    [dict setObject:[InfomationTool cheackChannel] forKey:@"random"];

    [RequestTool postRequestWithURL:MAP_URL.USER_REGISTER_BY_USER params:dict completion:^(NSDictionary *content, BOOL success) {
//        syLog(@"%@",content);
        REQUEST_COMPLETION;
        if (status.integerValue == 1) {
            /** 注册统计 */
            registStatistics(username);
        }
    }];
}

#pragma mark - phone and password
/** 手机注册验证码 */
+ (void)phoneRegisterCodeWithPhoneNumber:(NSString *)phoneNumber
                              completion:(void (^)(NSDictionary *, BOOL))completion {

    [UserModel requestCodeWithType:CodeRegister WithPhoneNumber:phoneNumber completion:completion];
}

/** 手机号码注册 */
+ (void)phoneRegisterWithPhoneNumber:(NSString *)phoneNumber
                            PassWord:(NSString *)pwd
                                Code:(NSString *)codeMessage
                          completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"code",@"mobile",@"password",@"appid",@"channel",@"system",@"maker",@"mobile_model",@"machine_code",@"system_version"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:codeMessage forKey:@"code"];
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:pwd forKey:@"password"];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:SDK_GETDEVICEYYPE forKey:@"system"];
    [dict setObject:SDK_GETDEVICEMAKER forKey:@"maker"];
    [dict setObject:SDK_GETDEVICEMODEL forKey:@"mobile_model"];
    [dict setObject:SDK_GETDEVICEID forKey:@"machine_code"];
    [dict setObject:SDK_GETSYSTEMVERSION forKey:@"system_version"];
    [dict setObject:[InfomationTool cheackChannel] forKey:@"random"];

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.USER_REGISTER_BY_MOBILE params:dict completion:^(NSDictionary *content, BOOL success) {

//        syLog(@"register ===== %@",content);
        REQUEST_COMPLETION;
        if (status.integerValue == 1) {
            /** 注册统计 */
            registStatistics(phoneNumber);
        }
    }];

}

/** 一键试玩 */
+ (void)oneUpRegisterWithcompletion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"password",@"appid",@"channel",@"system",@"maker",@"mobile_model",@"machine_code",@"system_version"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    NSInteger pwd = arc4random() % 1000000;
    NSString *password = [NSString stringWithFormat:@"%.6ld",(long)pwd];
    oneUpRegisterPassword = [password copy];

    [dict setObject:password forKey:@"password"];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:SDK_GETDEVICEYYPE forKey:@"system"];
    [dict setObject:SDK_GETDEVICEMAKER forKey:@"maker"];
    [dict setObject:SDK_GETDEVICEMODEL forKey:@"mobile_model"];
    [dict setObject:SDK_GETDEVICEID forKey:@"machine_code"];
    [dict setObject:SDK_GETSYSTEMVERSION forKey:@"system_version"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];
    [dict setObject:[InfomationTool cheackChannel] forKey:@"random"];

    [RequestTool postRequestWithURL:MAP_URL.USER_REGISTER_BY_TRIAL params:dict completion:^(NSDictionary *content, BOOL success) {

//        syLog(@"%@",content);
        REQUEST_COMPLETION;
        if (status.integerValue == 1) {
            /** 注册统计 */
            registStatistics(SDK_CONTENT_DATA[@"username"]);
        }
    }];
}

/** 手机登录 */
+ (void)phoneLoginWithPhoneNumber:(NSString *)phoneNumber
                         Password:(NSString *)password
                       completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"username",@"type",@"password",@"appid",@"channel",@"system",@"machine_code"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:phoneNumber forKey:@"username"];
    [dict setObject:@"2" forKey:@"type"];
    [dict setObject:password forKey:@"password"];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:SDK_GETDEVICEYYPE forKey:@"system"];
    [dict setObject:SDK_GETDEVICEID forKey:@"machine_code"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];
    [dict setObject:[InfomationTool cheackChannel] forKey:@"random"];

    [RequestTool postRequestWithURL:MAP_URL.USER_LOGIN params:dict completion:^(NSDictionary *content, BOOL success) {

//        syLog(@"%@",content);
        REQUEST_COMPLETION;
        if (status.integerValue == 1) {
            /** 登录统计 */
            loginStatistics(phoneNumber);
        }
    }];
}

/** 修改密码 */
+ (void)changePasswordWithOldPassWord:(NSString *)oldPassword
                          NewPassword:(NSString *)newPassword
                           completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"id",@"appid",@"password",@"newpassword"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETUID forKey:@"id"];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:oldPassword forKey:@"password"];
    [dict setObject:newPassword forKey:@"newpassword"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.USER_MODIFY_PWD params:dict completion:completion];
}

/** 发送绑定手机验证码 */
+ (void)phoneBindingCodeWithPhoneNumber:(NSString *)phoneNumber
                             completion:(void (^)(NSDictionary *, BOOL))completion {
    [UserModel requestCodeWithType:CodeBinding WithPhoneNumber:phoneNumber completion:completion];
}

/** 绑定手机 */
+ (void)bindingAccountWithPhoneNumber:(NSString *)phoneNumber
                                 Code:(NSString *)code
                           completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"uid",@"mobile",@"appid",@"code"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETUID forKey:@"uid"];
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:code forKey:@"code"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.USER_BIND_MOBILE params:dict completion:completion];

}

/** 验证手机号是否注册或者绑定 */
+ (void)isRegisterWithphoneNumber:(NSString *)phoneNumber
                       Completion:(void(^)(NSDictionary *const, BOOL success))completion {

    NSArray *pamarasKey = @[@"appid",@"mobile"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.USER_MOBILE_EXISTS params:dict completion:^(NSDictionary *content, BOOL success) {

//        syLog(@"%@",content);
        REQUEST_COMPLETION;

    }];
}

/** 发送找回密码验证短信 */
+ (void)phoneResetPasswordCodeWithPhoneNumber:(NSString *)phoneNumber
                                   completion:(void (^)(NSDictionary *, BOOL))completion {
    [UserModel requestCodeWithType:CodeResetPassword WithPhoneNumber:phoneNumber completion:completion];
}

/** 找回密码验证手机 */
+ (void)resetPasswordVerificationWithCode:(NSString *)code
                              PhoneNumber:(NSString *)phoneNumber
                               completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"mobile",@"code",@"appid"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:code forKey:@"code"];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.USER_CHECK_SMSCODE params:dict completion:^(NSDictionary *content, BOOL success) {

//        syLog(@"%@",content);
        REQUEST_COMPLETION

    }];

}

/** 找回密码(重置密码) */
+ (void)ResetPasswordWithToken:(NSString *)token
                   PhoneNumber:(NSString *)phoneNumber
                      Password:(NSString *)password
                    completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"id",@"password",@"token",@"appid"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETUID forKey:@"id"];
    [dict setObject:password forKey:@"password"];
    [dict setObject:token forKey:@"token"];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.USER_FORGET_PWD params:dict completion:^(NSDictionary *content, BOOL success) {

//        syLog(@"%@",content);
        REQUEST_COMPLETION;

    }];

}

/** 发送解绑短信 */
+ (void)phoneUnBindingCodeWithPhoneNumber:(NSString *)phoneNumber
                               completion:(void (^)(NSDictionary *, BOOL))completion {
    [UserModel requestCodeWithType:COdeUnbind WithPhoneNumber:phoneNumber completion:completion];
}

/** 解绑手机 */
+ (void)unBindingAccountWithPhoneNumber:(NSString *)phoneNumber
                                   Code:(NSString *)code
                             completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"uid",@"mobile",@"appid",@"code"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETUID forKey:@"uid"];
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:code forKey:@"code"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.USER_UNBIND_MOBILE params:dict completion:completion];
}

/** 实名认证 */
+ (void)IDCardVerifiedWithIDNumber:(NSString *)idNumber
                            IDName:(NSString *)idName
                        completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"uid",@"real_name",@"id_card",@"appid"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETUID forKey:@"uid"];
//    syLog(@"uid === %@",SDK_GETUID);
    [dict setObject:idName forKey:@"real_name"];
    [dict setObject:idNumber forKey:@"id_card"];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.USER_ID_AUTH params:dict completion:completion];

}

/** 是否加速 */
+ (void)isSpped:(void (^)(NSDictionary *, BOOL))completion {

    if (!SDK_GETUID) {
        completion(nil,NO);
        return;
    }
    NSArray *pamarasKey = @[@"appid",@"channel",@"uid"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:SDK_GETUID forKey:@"uid"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.USER_MAX_SPEED params:dict completion:completion];

}

/** 同步平台币 */
+ (void)synchronizePlatformCoin {
    if (![UserModel currentUser].uid) {
        return;
    }

    NSArray *pamarasKey = @[@"appid",@"channel",@"uid"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:SDK_GETUID forKey:@"uid"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.USER_REFRESH_COIN params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_STATUS;
        if (success && status.integerValue == 1) {
            [UserModel currentUser].platform_money = [NSString stringWithFormat:@"%@",content[@"data"]];
        }
    }];
}

+ (void)logOut {
    //清除用户数据
    [userModel setAllPropertyWithDict:nil];
//    syLog(@"logout === uid ==== %@",userModel.uid);
    [RequestTool deleteUid];
}


+ (void)showAlertWithMessage:(NSString *)message dismissTime:(float)time dismiss:(void (^)(void))dismiss {
    [InfomationTool showAlertMessage:message dismissTime:time dismiss:dismiss];
}

#pragma mark - ================================ feedback list =============================
/** 工单列表 */
+ (void)FeedbackListWithPage:(NSString *)page Completion:(void (^)(NSDictionary *, BOOL))completion {
    if (![UserModel currentUser].uid) {
        return;
    }

    NSArray *pamarasKey = @[@"appid",@"uid",@"channel",@"page"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETUID forKey:@"uid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:page forKey:@"page"];

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.QUESTIN_LIST params:dict completion:^(NSDictionary *content, BOOL success) {

        REQUEST_COMPLETION;

    }];
}

/** 获取问类型 */
+ (void)FeedBackQuestionTypeWithCompletion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"appid",@"channel"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.QUESTION_TYPE params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}


//提交工单
+ (void)FeedBackSubmitWithTitle:(NSString *)title Type:(NSString *)type Description:(NSString *)desc Contract:(NSString *)contract Completion:(void (^)(NSDictionary *, BOOL))completion {
    if (![UserModel currentUser].uid) {
        return;
    }

    NSArray *pamarasKey = @[@"appid",@"uid",@"channel",@"title",@"type",@"desc",@"contract"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETUID forKey:@"uid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:title forKey:@"title"];
    [dict setObject:type forKey:@"type"];
    [dict setObject:desc forKey:@"desc"];
    if (contract == nil) {
        contract = @"";
    }
    [dict setObject:contract forKey:@"contract"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.QUESTION_ADD params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** 获取问题详情 */
+ (void)FeedBackDetailWithQuestionID:(NSString *)question_id Page:(NSString *)page Completion:(void (^)(NSDictionary *, BOOL))completion {
    if (![UserModel currentUser].uid) {
        return;
    }

    NSArray *pamarasKey = @[@"appid",@"uid",@"channel",@"question_id",@"page"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETUID forKey:@"uid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:question_id forKey:@"question_id"];
    [dict setObject:page forKey:@"page"];

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.QUESTIN_INFO params:dict completion:^(NSDictionary *content, BOOL success) {
        
        REQUEST_COMPLETION;

    }];
}

/** 添加问题回复 */
+ (void)FeedBackAddCommentWith:(NSString *)comment QuestionID:(NSString *)question_id Completion:(void (^)(NSDictionary *, BOOL))completion {
    if (![UserModel currentUser].uid) {
        return;
    }

    NSArray *pamarasKey = @[@"appid",@"uid",@"channel",@"question_id",@"comment"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETUID forKey:@"uid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:question_id forKey:@"question_id"];
    [dict setObject:comment forKey:@"comment"];

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];
    [RequestTool postRequestWithURL:MAP_URL.QUESTION_COMMENT params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** 客服评价 */
+ (void)CustomerServiceEvaluationWithQuestionID:(NSString *)questionID Rate:(id)rate Reason:(NSString *)reason Completion:(UserModelCompletion)completion {
    if (![UserModel currentUser].uid) {
        return;
    }

    NSArray *pamarasKey = @[@"uid",@"question_id",@"appid",@"channel",@"rate",@"reason"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SDK_GETUID forKey:@"uid"];
    [dict setObject:questionID forKey:@"question_id"];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    NSString *rateResult;
    if ([rate isKindOfClass:[NSString class]]) {
        rateResult = rate;
    } else {
        rateResult = [NSString stringWithFormat:@"%@",rate];
    }
    [dict setObject:rateResult forKey:@"rate"];

    if (reason && rateResult.integerValue < 3) {
        [dict setObject:reason forKey:@"reason"];
    } else {
        [dict setObject:@"" forKey:reason];
    }

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];



    
    [RequestTool postRequestWithURL:MAP_URL.QUESTION_RATE params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}


#pragma mark - new login
+ (void)newPhoneNumberLoginWith:(NSString *)phoneNumber
                       PassWord:(NSString *)pwd
                     completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"mobile",@"password",@"appid",@"channel",@"system",@"machine_code"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:pwd forKey:@"password"];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:SDK_GETDEVICEYYPE forKey:@"system"];
    [dict setObject:SDK_GETDEVICEID forKey:@"machine_code"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.MOBILE_LOGINV2 params:dict completion:^(NSDictionary *content, BOOL success) {
        syLog(@"new phone number login === %@",content);
        REQUEST_COMPLETION;
        if (status.integerValue == 1) {
            /** 保存 UID */
            (dict[@"id"]) ? [RequestTool saveUid:[NSString stringWithFormat:@"%@",dict[@"id"]]] : 0;
            /** 登录统计 */
            loginStatistics(phoneNumber);
        }
    }];
}

+ (void)checkSwitchUserWithPhoneNumber:(NSString *)phoneNumber
                              Username:(NSString *)username
                                 Token:(NSString *)token
                            completion:(void (^)(NSDictionary * content, BOOL success))completion {
    NSArray *pamarasKey = @[@"mobile",@"username",@"token",@"appid",@"channel",@"system",@"machine_code"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:username forKey:@"username"];
    [dict setObject:token forKey:@"token"];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:SDK_GETDEVICEYYPE forKey:@"system"];
    [dict setObject:SDK_GETDEVICEID forKey:@"machine_code"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.CHECK_SWITCHUSER params:dict completion:^(NSDictionary *content, BOOL success) {
        syLog(@"new phone number login user name  === %@",content);
        REQUEST_COMPLETION;
        if (status.integerValue == 1) {
            /** 保存 UID */
            (dict[@"id"]) ? [RequestTool saveUid:[NSString stringWithFormat:@"%@",dict[@"id"]]] : 0;
            /** 登录统计 */
            loginStatistics(phoneNumber);
        }
    }];
}

+ (void)editBindUserNickNameWith:(NSString *)nickName
                        UserName:(NSString *)username
                      completion:(void (^)(NSDictionary * content, BOOL success))completion {
    NSArray *pamarasKey = @[@"username",@"nick_name",@"appid",@"channel"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:username forKey:@"username"];
    [dict setObject:nickName forKey:@"nick_name"];
    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.EDIT_BUNICKNAME params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}



@end








