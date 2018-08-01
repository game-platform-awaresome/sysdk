//
//  m185CheackPayResults.m
//  SY_185SDK
//
//  Created by 燚 on 2017/10/24.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "m185CheackPayResults.h"
#import "PayModel.h"

@interface m185CheackPayResults ()

/** 支付查询状态 */
@property (nonatomic, assign) NSInteger payState;
/** 定时器时间 */
@property (nonatomic, assign) BOOL isCheack;
@property (nonatomic, assign) NSInteger currentCheackTime;

@end

@implementation m185CheackPayResults


+ (m185CheackPayResults *)cheackResultsWithOrderID:(NSString *)orderID delegage:(id<CheckResultsDelegate>)delegate {
    m185CheackPayResults *cheackResults = [[m185CheackPayResults alloc] init];
    cheackResults.delegate = delegate;
    cheackResults.isCheack = YES;
    cheackResults.currentCheackTime = 0;
    cheackResults.orderID = orderID;
    return cheackResults;
}

#pragma mark - setter
- (void)setOrderID:(NSString *)orderID {
    _orderID = orderID;
    [self checkRechargeResult];
}

/** 检查支付 */
- (void)checkRechargeResult {
    SDKLOG(@"payment querying");
    SDK_Log(([NSString stringWithFormat:@"支付查询中 orderID == %@",self.orderID]));
    if (self.isCheack) {
        //        syLog(@"开始检查-------%@",[NSThread currentThread]);
        if (self.payState == 1 || self.payState == 2) {

            if (self.delegate && [self.delegate respondsToSelector:@selector(checkResultsDelegateCheckResultSuccess:infomation:)]) {
                [self.delegate checkResultsDelegateCheckResultSuccess:YES infomation:@{@"orderID":self.orderID}];
            }
            SDK_Log(([NSString stringWithFormat:@"查询到结果 orderID == %@",self.orderID]));
            //            syLog(@"查到结果-------%@",[NSThread currentThread]);
            self.isCheack = NO;
        } else {
            SDK_Log(([NSString stringWithFormat:@"未查询到结果 orderID == %@",self.orderID]));
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                _currentCheackTime++;
                //                syLog(@"继续查询-------%@",[NSThread currentThread]);
                SDK_Log(([NSString stringWithFormat:@"继续支付查询 orderID == %@",self.orderID]));
                if (_currentCheackTime == 100) {
                    self.isCheack = NO;
                    [self checkRechargeResult];
                } else {
                    [PayModel payQueryWithOrderID:self.orderID Completion:^(NSDictionary *content, BOOL success) {
                        if (success) {
                            NSDictionary *dict = content[@"data"];
                            NSString *paystate = [NSString stringWithFormat:@"%@",dict[@"order_status"]];
                            self.payState = paystate.integerValue;
                        }
                        [self checkRechargeResult];
                    }];
                }
            });
        }
    } else {
        //        syLog(@"支付失败-------%@",[NSThread currentThread]);
        SDK_Log(([NSString stringWithFormat:@"支付结果 -> 失败 orderID == %@",self.orderID]));
        [self.delegate checkResultsDelegateCheckResultSuccess:NO infomation:@{@"orderID":self.orderID}];
    }
}



@end
