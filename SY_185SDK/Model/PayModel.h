//
//  PayModel.h
//  SY_185SDK
//
//  Created by 燚 on 2017/10/10.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "Model.h"
#import "UserModel.h"
#import "SDKModel.h"
#import "MapModel.h"

/** 支付的枚举 */
typedef enum : NSUInteger {
    AliQRcode = 1,
    Alipay = 11,
    WechatQRcode = 3,
    WechatPay = 4,
    TenPay = 6,
    ChinaMobile = 7,
    ChinaTelecom = 8,
    ChinaUnicom = 9,
    platformCoin = 10
} PayType;

@interface PayModel : Model

/** 支付用的参数 */
@property (nonatomic, strong) NSString *serverID;
@property (nonatomic, strong) NSString *serverNAME;
@property (nonatomic, strong) NSString *roleID;
@property (nonatomic, strong) NSString *roleNAME;
@property (nonatomic, strong) NSString *productID;
@property (nonatomic, strong) NSString *productNAME;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *originalPrice;      //原价 ,折扣服用参数
@property (nonatomic, strong) NSString *extend;
@property (nonatomic, assign) NSString *payType;
@property (nonatomic, strong) NSString *payModel;
@property (nonatomic, strong) NSString *cardID;
@property (nonatomic, strong) NSString *cardPass;
@property (nonatomic, strong) NSString *cardMoney;
@property (nonatomic, strong) NSString *discount;

+ (PayModel *)sharedModel;

/** 准备支付 */
+ (void)payReadyWithCompletion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 发起支付 */
- (void)payStartWithCompletion:(void(^)(NSDictionary *content, BOOL success))completion;

/** GM 支付 */
//- (void)GMPayStartWithCompletion:(void(^)(NSDictionary *content, BOOL success))completion;

/** 支付状态查询 */
+ (void)payQueryWithOrderID:(NSString *)orderID
                 Completion:(void(^)(NSDictionary *content,BOOL success))completion;



@end



