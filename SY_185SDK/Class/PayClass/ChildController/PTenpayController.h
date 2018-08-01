//
//  PTenpayController.h
//  SDK185SY
//
//  Created by 石燚 on 2017/6/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//


#import "FFPayDetailViewController.h"

@protocol TenPayDelegate <NSObject>

/** 选择支付 */
- (void)TenPayControllerSelectTenPay;

@end

@interface PTenpayController : FFPayDetailViewController

@property (nonatomic, weak) id<TenPayDelegate> delegate;

@end

