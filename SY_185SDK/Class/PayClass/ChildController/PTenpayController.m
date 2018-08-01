//
//  PTenpayController.m
//  SDK185SY
//
//  Created by 石燚 on 2017/6/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "PTenpayController.h"

@interface PTenpayController ()


@end

@implementation PTenpayController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.QRCodeBtn.hidden = YES;
    self.rechargeBtn.center = CGPointMake(view_width / 2, view_height * 0.7);
    [self setRechargeButtonTitle:@"财付通支付"];
}

- (void)respondsTorechagreButton {
    
    if ([self.delegate respondsToSelector:@selector(TenPayControllerSelectTenPay)]) {
        [self.delegate TenPayControllerSelectTenPay];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
