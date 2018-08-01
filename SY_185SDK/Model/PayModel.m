//
//  PayModel.m
//  SY_185SDK
//
//  Created by 燚 on 2017/10/10.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "PayModel.h"


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

static PayModel *model = nil;

@implementation PayModel


+ (PayModel *)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[PayModel alloc] init];
        }
    });
    return model;
}

/** 准备支付 */
+ (void)payReadyWithCompletion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"appid",@"uid"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETAPPID forKey:@"appid"];

    if ([UserModel currentUser].uid) {
        [dict setObject:[UserModel currentUser].uid forKey:@"uid"];
    }

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.PAY_READY params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];

}

/** 开始支付 */
+ (void)payStartWithServerID:(NSString *)serverID
                  serverName:(NSString *)serverName
                      roleID:(NSString *)roleID
                    roleName:(NSString *)roleName
                   productID:(NSString *)productID
                 productName:(NSString *)productName
                     payType:(NSString *)payType
                    payModel:(NSString *)payModel
                      amount:(NSString *)amount
               originalPrice:(NSString *)originalPrice
                   extension:(NSString *)extension
                      cardID:(NSString *)cardID
                cardPassword:(NSString *)cardPassword
                   cardMoney:(NSString *)cardMoney
                  Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"deviceType",@"appid",@"channel",@"uid",
                            @"serverID",@"serverNAME",@"roleID",@"roleNAME",
                            @"productID",@"productNAME",@"payType",@"payMode",
                            @"cardID",@"cardPass",@"cardMoney",@"amount",
                            @"extend"];

    NSLog(@"sy_sdk pay Start request");

    SDK_Log(([NSString stringWithFormat:@"pay info befor -> \n server_id : %@\n server_name : %@\n role_id : %@\n role_name : %@\n product_id : %@\n product_name : %@\n amount : %@\n extend : %@\n",serverID,serverName,roleID,roleName,productID,productName,amount,extension]));

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:SDK_GETDEVICEYYPE forKey:@"deviceType"];
    if (SDK_GETAPPID) {
        [dict setObject:SDK_GETAPPID forKey:@"appid"];
    } else {
        return;
    }
    [dict setObject:SDK_GETCHANNELID forKey:@"channel"];
    if (SDK_GETUID) {
        [dict setObject:SDK_GETUID forKey:@"uid"];
    } else {
        return;
    }

    [dict setObject:serverID forKey:@"serverID"];
    [dict setObject:serverName forKey:@"serverNAME"];
    [dict setObject:roleID forKey:@"roleID"];
    [dict setObject:roleName forKey:@"roleNAME"];

    [dict setObject:productID forKey:@"productID"];
    [dict setObject:productName forKey:@"productNAME"];
    [dict setObject:payType forKey:@"payType"];
    [dict setObject:payModel forKey:@"payMode"];

    if (!cardID) {
        cardID = @"";
    }
    [dict setObject:cardID forKey:@"cardID"];

    if (!cardPassword) {
        cardPassword = @"";
    }
    [dict setObject:cardPassword forKey:@"cardPass"];

    if (!cardMoney) {
        cardMoney = @"";
    }
    [dict setObject:cardMoney forKey:@"cardMoney"];

    [dict setObject:amount forKey:@"amount"];


    if ([originalPrice isEqualToString:@""] || originalPrice == nil) {
        originalPrice = @"0";
    }
    [dict setObject:originalPrice forKey:@"origPrice"];


    if ([extension isEqualToString:@""] || extension == nil) {
        extension = @"%";
    }
    [dict setObject:extension forKey:@"extend"];


    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];
    SDK_Log(([NSString stringWithFormat:@"pay info after -> \n server_id : %@\n server_name : %@\n role_id : %@\n role_name : %@\n product_id : %@\n product_name : %@\n amount : %@\n extend : %@\n",serverID,serverName,roleID,roleName,productID,productName,amount,extension]));

    [RequestTool postRequestWithURL:MAP_URL.PAY_START params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}


- (void)payStartWithCompletion:(void (^)(NSDictionary *, BOOL))completion {

    [PayModel payStartWithServerID:self.serverID
                        serverName:self.serverNAME
                            roleID:self.roleID
                          roleName:self.roleNAME
                         productID:self.productID
                       productName:self.productNAME
                           payType:self.payType
                          payModel:self.payModel
                            amount:self.amount
                     originalPrice:self.originalPrice
                         extension:self.extend
                            cardID:self.cardID
                      cardPassword:self.cardPass
                         cardMoney:self.cardMoney
                        Completion:completion];

}


/** 支付查询 */
+ (void)payQueryWithOrderID:(NSString *)orderID
                 Completion:(void (^)(NSDictionary *, BOOL))completion {

    NSArray *pamarasKey = @[@"orderID"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:orderID forKey:@"orderID"];

    [dict setObject:SDK_GETSIGN(dict, pamarasKey) forKey:@"sign"];

    [RequestTool postRequestWithURL:MAP_URL.PAY_QUERY params:dict completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}


@end
