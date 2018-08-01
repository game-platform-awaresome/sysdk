//
//  PWechatPayController.h
//  SDK185SY
//
//  Created by 石燚 on 2017/6/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFPayDetailViewController.h"

@protocol WechatPayDelegate <NSObject>

/** 选择支付 */
- (void)WechatPayControllerSelectWechatpay;

/** 二维码支付 */
- (void)WechatPayControllerSelectQRpay;

@end

@interface PWechatPayController : FFPayDetailViewController

@property (nonatomic, weak) id<WechatPayDelegate> delegate;


@end


