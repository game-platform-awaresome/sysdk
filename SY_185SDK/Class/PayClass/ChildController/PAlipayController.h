//
//  PAlipayController.h
//  SDK185SY
//
//  Created by 石燚 on 2017/6/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFPayDetailViewController.h"


@class PAlipayController;

@protocol AlipayDelegate <NSObject>

/** 选择支付 */
- (void)AliPayControllerSelectAlipay;

/** 二维码支付 */
- (void)AliPayControllerSelectQRpay;

@end


@interface PAlipayController : FFPayDetailViewController


@property (nonatomic, weak) id<AlipayDelegate> delegate;


@end















