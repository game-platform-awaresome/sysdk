//
//  UserModel.h
//  SY_185SDK
//
//  Created by 燚 on 2017/9/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "Model.h"

/** type 1 注册 2绑定 3解绑 4 修改密码 */
typedef enum : NSUInteger {
    CodeRegister = 1,
    CodeBinding = 2,
    COdeUnbind,
    CodeResetPassword
} CodeMessage;

@interface UserModel : Model

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *platform_money;
@property (nonatomic, strong) NSString *id_name;
@property (nonatomic, strong) NSString *id_card;
@property (nonatomic, strong) NSString *icon_url;
@property (nonatomic, strong) NSString *question_contract_enabled;
@property (nonatomic, assign) NSInteger maxSpped;

@property (assign, nonatomic) BOOL switchAccount;



/** 当前用户 */
+ (UserModel *)currentUser;

/** 请求手机验证码 */
+ (void)requestCodeWithType:(CodeMessage)codeType
            WithPhoneNumber:(NSString *)phoneNumber
                 completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 一键注册的密码 */
+ (NSString *)oneUpRegistPassword;

/** 保存用户信息 */
+ (void)saveUserInfoWithDictionary:(NSDictionary *)content;

/** 用户名登录 */
+ (void)userLoginWithUserName:(NSString *)username
                     PassWord:(NSString *)pwd
                   completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 用户名注册 */
+ (void)userRegisterWithUserName:(NSString *)username
                        PassWord:(NSString *)pwd
                      completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 手机登录 */
+ (void)phoneLoginWithPhoneNumber:(NSString *)phoneNumber
                         Password:(NSString *)password
                       completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 发送手机注册验证码 */
+ (void)phoneRegisterCodeWithPhoneNumber:(NSString *)phoneNumber
                              completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 手机注册 */
+ (void)phoneRegisterWithPhoneNumber:(NSString *)phoneNumber
                            PassWord:(NSString *)pwd
                                Code:(NSString *)codeMessage
                          completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 一键试玩 */
+ (void)oneUpRegisterWithcompletion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 修改密码 */
+ (void)changePasswordWithOldPassWord:(NSString *)oldPassword
                          NewPassword:(NSString *)newPassword
                           completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 发送绑定验证码 */
+ (void)phoneBindingCodeWithPhoneNumber:(NSString *)phoneNumber
                             completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 绑定手机 */
+ (void)bindingAccountWithPhoneNumber:(NSString *)phoneNumber
                                 Code:(NSString *)code
                           completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 找回密码验证手机是否注册 */
+ (void)isRegisterWithphoneNumber:(NSString *)phoneNumber
                       Completion:(void(^)(NSDictionary *content, BOOL success))completion;

/** 发送找回密码(重置密码)验证码 */
+ (void)phoneResetPasswordCodeWithPhoneNumber:(NSString *)phoneNumber
                                   completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 找回密码(重置密码)验证手机 */
+ (void)resetPasswordVerificationWithCode:(NSString *)code
                              PhoneNumber:(NSString *)phoneNumber
                               completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 找回密码(重置密码) */
+ (void)ResetPasswordWithToken:(NSString *)token
                   PhoneNumber:(NSString *)phoneNumber
                      Password:(NSString *)password
                    completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 发送解绑手机验证码 */
+ (void)phoneUnBindingCodeWithPhoneNumber:(NSString *)phoneNumber
                               completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 解绑手机 */
+ (void)unBindingAccountWithPhoneNumber:(NSString *)phoneNumber
                                   Code:(NSString *)code
                             completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 实名认证 */
+ (void)IDCardVerifiedWithIDNumber:(NSString *)idNumber
                            IDName:(NSString *)idName
                        completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 请求是否可以加速 */
+ (void)isSpped:(void(^)(NSDictionary *content, BOOL success))completion;


/** 同步平台币 */
+ (void)synchronizePlatformCoin;

/** 登出 */
+ (void)logOut;

/** 显示信息 */
+ (void)showAlertWithMessage:(NSString *)message dismissTime:(float)time dismiss:(void (^)(void))dismiss;


#pragma mark - ================================ feedback list =============================
/** 工单列表 */
+ (void)FeedbackListWithPage:(NSString *)page Completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 获取问类型 */
+ (void)FeedBackQuestionTypeWithCompletion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 提交工单 */
+ (void)FeedBackSubmitWithTitle:(NSString *)title Type:(NSString *)type Description:(NSString *)desc Contract:(NSString *)contract Completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 获取问题详情 */
+ (void)FeedBackDetailWithQuestionID:(NSString *)question_id Page:(NSString *)page Completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 添加问题回复 */
+ (void)FeedBackAddCommentWith:(NSString *)comment QuestionID:(NSString *)question_id Completion:(void(^)(NSDictionary *content,BOOL success))completion;

#pragma mark - 新手机登录接口
+ (void)newPhoneNumberLoginWith:(NSString *)phoneNumber
                       PassWord:(NSString *)pwd
                     completion:(void (^)(NSDictionary * content, BOOL success))completion;

+ (void)checkSwitchUserWithPhoneNumber:(NSString *)phoneNumber
                              Username:(NSString *)username
                                 Token:(NSString *)token
                            completion:(void (^)(NSDictionary * content, BOOL success))completion;

+ (void)editBindUserNickNameWith:(NSString *)nickName
                        UserName:(NSString *)username
                      completion:(void (^)(NSDictionary * content, BOOL success))completion;


@end











