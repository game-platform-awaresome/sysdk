//
//  PWechatPayController.m
//  SDK185SY
//
//  Created by 石燚 on 2017/6/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "PWechatPayController.h"

@interface PWechatPayController ()

@end

@implementation PWechatPayController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    [self setRechargeButtonTitle:@"微信支付"];
    [self setQrCodeButtonTitle:@"扫码支付"];
}


- (void)respondsTorechagreButton {
    syLog(@"支付按钮%s",__func__);
    if ([self.delegate respondsToSelector:@selector(WechatPayControllerSelectWechatpay)]) {
        [self.delegate WechatPayControllerSelectWechatpay];
    }
}

- (void)respondsToQRCodeButton {
    syLog(@"二维码按钮 %s",__func__);
    if ([self.delegate respondsToSelector:@selector(WechatPayControllerSelectQRpay)]) {
        [self.delegate WechatPayControllerSelectQRpay];
    }
}






@end
