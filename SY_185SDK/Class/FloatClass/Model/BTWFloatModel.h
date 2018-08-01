//
//  BTWFloatModel.h
//  BTWan
//
//  Created by 石燚 on 2017/7/18.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//
#import "Model.h"
#import "SDKModel.h"
#import "UserModel.h"

@interface BTWFloatModel : Model

/** 请求公告列表 */
+ (void)announcementListWithPage:(NSString *)page
                            Size:(NSString *)size
                      Completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 请求详细公告 */
+ (void)detailAnnouncementWithID:(NSString *)annoucementID
                      Completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 请求充值记录 */
+ (void)payNotesListWithPage:(NSString *)page
                        Size:(NSString *)size
                  Completion:(void(^)(NSDictionary *content,BOOL success))completion;

/** 请求礼包 */
+ (void)giftListWithCompletion:(void (^)(NSDictionary *content, BOOL success))completion;

/** 领取礼包 */
+ (void)getGiftWithGiftID:(NSString *)giftID
               Completion:(void(^)(NSDictionary *content,BOOL success))completion;


@end
