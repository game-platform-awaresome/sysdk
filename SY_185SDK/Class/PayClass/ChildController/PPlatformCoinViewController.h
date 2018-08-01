//
//  PPlatformCoinViewController.h
//  BTWan
//
//  Created by 石燚 on 2017/7/19.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFPayDetailViewController.h"

@protocol PlatformCoinDelegate <NSObject>

/** 平台币支付 */
- (void)PlatformCoinControllerSelectPlatformCoinpay;


@end

@interface PPlatformCoinViewController : FFPayDetailViewController

@property (nonatomic, weak) id<PlatformCoinDelegate> delegate;



@end
