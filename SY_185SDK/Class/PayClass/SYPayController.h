//
//  SYPayController.h
//  SY_185SDK
//
//  Created by 燚 on 2017/10/10.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayModel.h"

@protocol SYPayControllerDeleagete <NSObject>

- (void)m185_PayDelegateWithPaySuccess:(BOOL)success WithInformation:(NSDictionary *)dict;

@end

@interface SYPayController : NSObject

/** 代理 */
@property (nonatomic, weak) id<SYPayControllerDeleagete> SYPayDelegate;

/** 支付的总控制器 */
+ (SYPayController *)sharedController;

/** 发起支付 */
+ (void)payStartWithServerID:(NSString *)serverID
                  serverName:(NSString *)serverName
                      roleID:(NSString *)roleID
                    roleName:(NSString *)roleName
                   productID:(NSString *)productID
                 productName:(NSString *)productName
                      amount:(NSString *)amount
               originalPrice:(NSString *)originalPrice
                   extension:(NSString *)extension
                    Delegate:(id<SYPayControllerDeleagete>)payDelegate;

/** 发起 GM 权限支付 */
+ (void)GMPayStartWithServerID:(NSString *)serverID
                    serverName:(NSString *)serverName
                        roleID:(NSString *)roleID
                      roleName:(NSString *)roleName
                     productID:(NSString *)productID
                   productName:(NSString *)productName
                        amount:(NSString *)amount
                     extension:(NSString *)extension
                      Delegate:(id<SYPayControllerDeleagete>)payDelegate;


@end



