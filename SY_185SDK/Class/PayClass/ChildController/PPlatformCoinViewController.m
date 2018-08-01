//
//  PPlatformCoinViewController.m
//  BTWan
//
//  Created by 石燚 on 2017/7/19.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "PPlatformCoinViewController.h"
#import "PayModel.h"

@interface PPlatformCoinViewController ()

@end

@implementation PPlatformCoinViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.QRCodeBtn.hidden = YES;
    self.rechargeBtn.center = CGPointMake(view_width / 2, view_height * 0.7);
    [self setRechargeButtonTitle:@"平台币支付"];
}

- (void)addSubViews {
    [super addSubViews];
    [self addLastCoinView];
}

#pragma mark - method
- (void)respondsTorechagreButton {
    if ([self.delegate respondsToSelector:@selector(PlatformCoinControllerSelectPlatformCoinpay)]) {
        [self.delegate PlatformCoinControllerSelectPlatformCoinpay];
    }
}


#pragma mark - setter
- (void)setNoDiscountView {
    [super setNoDiscountView];
    self.rechargeTypeLabel.text = [NSString stringWithFormat:@"支付 : %.0f 个",self.rechargeTitle.floatValue * 10];
}


- (void)setDiscountViewWith:(NSString *)originalPrice {
    [super setDiscountViewWith:originalPrice];
    [self setRechargeString:[NSString stringWithFormat:@"%.0f",self.rechargeTitle.floatValue * 10]];
    self.originalPiceLabel.text = [NSString stringWithFormat:@"原平台币 : %.0f 个",[PayModel sharedModel].originalPrice.floatValue * 10];
}

- (void)setRechargeString:(NSString *)rechage {
    NSString *string = [NSString stringWithFormat:@"支付 : %@ 个",rechage];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range1 = [string rangeOfString:[NSString stringWithFormat:@"%@",rechage]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
    self.rechargeTypeLabel.attributedText = attributeString;
}






@end
