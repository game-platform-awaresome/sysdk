//
//  MapModel.m
//  SY_185SDK
//
//  Created by 燚 on 2017/9/26.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "MapModel.h"
#import "RequestTool.h"

#define MAPURLKEY @"SDK_MAYURLKEY_185"

@interface MapModel ()

@property (nonatomic, strong) NSDictionary *lastDict;

@end

static MapModel *model = nil;

@implementation MapModel

+ (MapModel *)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[MapModel alloc] init];
        }
    });
    return model;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setAllPropertyWithUserDefaults];
    }
    return self;
}

- (void)getMapUrl:(void(^)(void))completion {

    WeakSelf;
    [RequestTool postRequestWithURL:@"http://api.185sy.com/index.php?g=api&m=index&a=map" params:nil completion:^(NSDictionary *content, BOOL success) {

        syLog(@"%@",content);
        REQUEST_STATUS;

        if (success && status.integerValue == 1) {

            //对所有属性赋值;
            [weakSelf setAllPropertyWithDict:content[@"data"]];

            //储存所有的 mapurl
            SDK_USERDEFAULTS_SAVE_OBJECT(content[@"data"],MAPURLKEY);

        } else {
            [weakSelf setAllPropertyWithUserDefaults];
        }

        if (completion) {
            completion();
        }

    }];

}

/** 对类的属性赋值(从数据持久化中) */
- (void)setAllPropertyWithUserDefaults {
    WeakSelf;
    NSDictionary *dict = SDK_USERDEFAULTS_GET_OBJECT(MAPURLKEY);

    //如果没有找到就从本地设置的值中赋值
    if (!dict) {
        dict = weakSelf.lastDict;
    }

    [weakSelf setAllPropertyWithDict:dict];
}


#pragma mark - getter
- (NSDictionary *)lastDict {
    if (!_lastDict) {
        _lastDict = @{@"ASSET_URL":@"http://www.sy527.com",
                      @"DOAMIN":@"http://api.185sy.com",
                      @"NOTICE_INFO":@"http://api.185sy.com/index.php?g=api&m=notice&a=notice_info",
                      @"NOTICE_LIST":@"http://api.185sy.com/index.php?g=api&m=notice&a=notice_list",
                      @"PACKAGE_GET_CODE":@"http://api.185sy.com/index.php?g=api&m=package&a=get_package_code",
                      @"PACKAGE_LIST":@"http://api.185sy.com/index.php?g=api&m=package&a=package_list",
                      @"PAY_QUERY":@"http://api.185sy.com/index.php?g=api&m=pay&a=payQuery",
                      @"PAY_READY":@"http://api.185sy.com/index.php?g=api&m=pay&a=payReady",
                      @"PAY_START":@"http://api.185sy.com/index.php?g=api&m=pay&a=payStart",
                      @"UPDATE_CHECK_UPDATE":@"http://api.185sy.com/index.php?g=api&m=update&a=check_update",
                      @"USER_BIND_MOBILE":@"http://api.185sy.com/index.php?g=api&m=user&a=bind_mobile",
                      @"USER_CHECK_SMSCODE":@"http://api.185sy.com/index.php?g=api&m=user&a=check_smscode",
                      @"USER_FORGET_PWD":@"http://api.185sy.com/index.php?g=api&m=user&a=forget_password",
                      @"USER_ID_AUTH":@"http://api.185sy.com/index.php?g=api&m=user&a=id_auth",
                      @"USER_INIT":@"http://api.185sy.com/index.php?g=api&m=user&a=do_init",
                      @"USER_LOGIN":@"http://api.185sy.com/index.php?g=api&m=user&a=login",
                      @"USER_LOGIN_VERIFY":@"http://api.185sy.com/index.php?g=api&m=user&a=login_verify",
                      @"USER_MAX_SPEED":@"http://api.185sy.com/index.php?g=api&m=user&a=max_speed",
                      @"USER_MOBILE_EXISTS":@"http://api.185sy.com/index.php?g=api&m=user&a=exsits_mobile",
                      @"USER_MODIFY_PWD":@"http://api.185sy.com/index.php?g=api&m=user&a=modify_password",
                      @"USER_PAY_LIST":@"http://api.185sy.com/index.php?g=api&m=user&a=pay_list_by_user",
                      @"USER_REFRESH_COIN":@"http://api.185sy.com/index.php?g=api&m=user&a=refresh_platmoney",
                      @"USER_REGISTER_BY_MOBILE":@"http://api.185sy.com/index.php?g=api&m=user&a=register_by_mobile",
                      @"USER_REGISTER_BY_TRIAL":@"http://api.185sy.com/index.php?g=api&m=user&a=register_by_trial",
                      @"USER_REGISTER_BY_USER":@"http://api.185sy.com/index.php?g=api&m=user&a=register_by_user",
                      @"USER_SEND_MESSAGE":@"http://api.185sy.com/index.php?g=api&m=user&a=send_message",
                      @"USER_UNBIND_MOBILE":@"http://api.185sy.com/index.php?g=api&m=user&a=unbind_mobile",
                      @"GM_GET_PROP":@"http://api.185sy.com/index.php?g=api&m=gmpri&a=get_prop",
                      @"GM_INIT":@"http://api.185sy.com/index.php?g=api&m=gmpri&a=do_init",
                      @"GM_SEND_PROP":@"http://api.185sy.com/index.php?g=api&m=gmpri&a=send_prop",
                      @"QUESTIN_INFO":@"http://api.185sy.com/index.php?g=api&m=question&a=get_question_info",
                      @"QUESTIN_LIST":@"http://api.185sy.com/index.php?g=api&m=question&a=get_list",
                      @"QUESTION_ADD":@"http://api.185sy.com/index.php?g=api&m=question&a=add_question",
                      @"QUESTION_COMMENT":@"http://api.185sy.com/index.php?g=api&m=question&a=add_comment",
                      @"QUESTION_TYPE":@"http://api.185sy.com/index.php?g=api&m=question&a=get_type",
                      @"MOBILE_LOGINV2":@"http://api.185sy.com/index.php?g=api&m=user&a=mobile_login_v2",
                      @"CHECK_SWITCHUSER":@"http://api.185sy.com/index.php?g=api&m=user&a=check_switch_user",
                      @"EDIT_BUNICKNAME":@"http://api.185sy.com/index.php?g=api&m=user&a=edit_binduser_nickname",
                      @"REPORT_DATA":@"http://api.185sy.com/index.php?g=api&m=user&a=report_data",
                      @"QUESTION_RATE":@"http://api.185sy.com/index.php?g=api&m=question&a=do_rate_by_player"
                      };
    }
    return _lastDict;
}

@end
