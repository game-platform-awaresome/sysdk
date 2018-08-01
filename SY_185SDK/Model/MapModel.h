//
//  MapModel.h
//  SY_185SDK
//
//  Created by 燚 on 2017/9/26.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "Model.h"

@interface MapModel : Model

@property (nonatomic, strong) NSString *ASSET_URL;
@property (nonatomic, strong) NSString *DOAMIN;
@property (nonatomic, strong) NSString *NOTICE_INFO;
@property (nonatomic, strong) NSString *NOTICE_LIST;
@property (nonatomic, strong) NSString *PACKAGE_GET_CODE;
@property (nonatomic, strong) NSString *PACKAGE_LIST;
@property (nonatomic, strong) NSString *PAY_QUERY;
@property (nonatomic, strong) NSString *PAY_READY;
@property (nonatomic, strong) NSString *PAY_START;
@property (nonatomic, strong) NSString *UPDATE_CHECK_UPDATE;
@property (nonatomic, strong) NSString *USER_BIND_MOBILE;
@property (nonatomic, strong) NSString *USER_CHECK_SMSCODE;
@property (nonatomic, strong) NSString *USER_FORGET_PWD;
@property (nonatomic, strong) NSString *USER_ID_AUTH;
@property (nonatomic, strong) NSString *USER_INIT;
@property (nonatomic, strong) NSString *USER_LOGIN;
@property (nonatomic, strong) NSString *USER_LOGIN_VERIFY;
@property (nonatomic, strong) NSString *USER_MAX_SPEED;
@property (nonatomic, strong) NSString *USER_MOBILE_EXISTS;
@property (nonatomic, strong) NSString *USER_MODIFY_PWD;
@property (nonatomic, strong) NSString *USER_PAY_LIST;
@property (nonatomic, strong) NSString *USER_REFRESH_COIN;
@property (nonatomic, strong) NSString *USER_REGISTER_BY_MOBILE;
@property (nonatomic, strong) NSString *USER_REGISTER_BY_TRIAL;
@property (nonatomic, strong) NSString *USER_REGISTER_BY_USER;
@property (nonatomic, strong) NSString *USER_SEND_MESSAGE;
@property (nonatomic, strong) NSString *USER_UNBIND_MOBILE;
@property (nonatomic, strong) NSString *GM_GET_PROP;
@property (nonatomic, strong) NSString *GM_INIT;
@property (nonatomic, strong) NSString *GM_SEND_PROP;

//new
@property (nonatomic, strong) NSString *QUESTIN_LIST;
@property (nonatomic, strong) NSString *QUESTIN_INFO;
@property (nonatomic, strong) NSString *QUESTION_ADD;
@property (nonatomic, strong) NSString *QUESTION_COMMENT;
@property (nonatomic, strong) NSString *QUESTION_TYPE;


@property (nonatomic, strong) NSString *MOBILE_LOGINV2;
@property (nonatomic, strong) NSString *CHECK_SWITCHUSER;
@property (nonatomic, strong) NSString *EDIT_BUNICKNAME;

@property (nonatomic, strong) NSString *REPORT_DATA;

+ (MapModel *)sharedModel;


- (void)getMapUrl:(void(^)(void))completion;




@end





