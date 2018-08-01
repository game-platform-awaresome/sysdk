//
//  BTWFloatModel.m
//  BTWan
//
//  Created by 石燚 on 2017/7/18.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "BTWFloatModel.h"
#import "MapModel.h"

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



@implementation BTWFloatModel

/** 请求公告列表 */
+ (void)announcementListWithPage:(NSString *)page
                            Size:(NSString *)size
                      Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"appid",@"channel",@"uid",@"page"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:SDK_GETUID forKey:@"uid"];
    [dict setObject:page forKey:@"page"];

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.NOTICE_LIST params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** 请求详细公告 1111*/
+ (void)detailAnnouncementWithID:(NSString *)annoucementID
                      Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"appid",@"id"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETAPPID forKey:@"appid"];

    [dict setObject:annoucementID forKey:@"id"];

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.NOTICE_INFO params:dict completion:completion];
}

/** 请求充值记录 */
+ (void)payNotesListWithPage:(NSString *)page
                        Size:(NSString *)size
                  Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"appid",@"uid",@"page"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETUID forKey:@"uid"];
    [dict setObject:page forKey:@"page"];

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.USER_PAY_LIST params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** 礼包列表 */
+ (void)giftListWithCompletion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"appid",@"channel",@"uid",@"system",@"page"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:SDK_GETUID forKey:@"uid"];
    [dict setObject:SDK_GETDEVICEYYPE forKey:@"system"];
    [dict setObject:@"1" forKey:@"page"];

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.PACKAGE_LIST params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** 领取礼包 */
+ (void)getGiftWithGiftID:(NSString *)giftID
               Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"appid",@"channel",@"uid",@"pid",@"machine_code"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETAPPID forKey:@"appid"];
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    [dict setObject:SDK_GETUID forKey:@"uid"];
    [dict setObject:giftID forKey:@"pid"];
    [dict setObject:SDK_GETDEVICEID forKey:@"machine_code"];

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.PACKAGE_GET_CODE params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}


@end
