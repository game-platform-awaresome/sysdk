//
//  PAlipayController.m
//  SDK185SY
//
//  Created by 石燚 on 2017/6/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "PAlipayController.h"

@interface PAlipayController ()

@end

@implementation PAlipayController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    [self setRechargeButtonTitle:@"支付宝支付"];
    [self setQrCodeButtonTitle:@"扫码支付"];
}

#pragma mark - method
- (void)respondsTorechagreButton {
    if ([self.delegate respondsToSelector:@selector(AliPayControllerSelectAlipay)]) {
        [self.delegate AliPayControllerSelectAlipay];
    }
}

- (void)respondsToQRCodeButton {
    if ([self.delegate respondsToSelector:@selector(AliPayControllerSelectQRpay)]) {
        [self.delegate AliPayControllerSelectQRpay];
    }
}

#pragma mark - getter




@end
