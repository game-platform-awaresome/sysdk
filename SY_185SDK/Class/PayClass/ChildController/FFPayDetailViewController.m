//
//  FFPayDetailViewController.m
//  SY_185SDK
//
//  Created by 燚 on 2018/5/2.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFPayDetailViewController.h"
#import "PayModel.h"
#import "UserModel.h"

@interface FFPayDetailViewController ()

/** 充值账号 */
@property (nonatomic, strong) UILabel *accountLabel;

/** 剩余平台币 */
@property (nonatomic, strong) UILabel *lastCoin;

/** 折扣 */
@property (nonatomic, strong) UILabel *discountLabel;


@end

@implementation FFPayDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setOriginalPice];
    self.lastCoin.text = [NSString stringWithFormat:@"剩余平台币 : %@",[UserModel currentUser].platform_money];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(PAYVIEW_WIDTH / 3 + 1, 0, PAYVIEW_WIDTH / 3 * 2 - 1, PAYVIEW_HEIGHT);
    [self addSubViews];
}

- (void)addSubViews {
    [self.view addSubview:self.accountLabel];
    [self.view addSubview:self.rechargeTypeLabel];
    [self.view addSubview:self.originalPiceLabel];
    [self.view addSubview:self.rechargeBtn];
    [self.view addSubview:self.QRCodeBtn];
}

- (void)addLastCoinView {
    [self.view addSubview:self.lastCoin];
}

#pragma mark - method
- (void)respondsTorechagreButton {
    syLog(@"二维码按钮 %s",__func__);
}

- (void)respondsToQRCodeButton {
    syLog(@"二维码按钮 %s",__func__);
}

#pragma mark - setter
- (void)setRechargeTitle:(NSString *)rechargeTitle {
    _rechargeTitle = rechargeTitle;
    self.rechargeTypeLabel.text = [NSString stringWithFormat:@"支付金额 : %@ 元",rechargeTitle];
}

- (void)setRechargeAccount:(NSString *)rechargeAccount {
    _rechargeAccount = rechargeAccount;
    self.accountLabel.text = [NSString stringWithFormat:@"充值账号 : %@",rechargeAccount];
}

- (void)setRechargeButtonTitle:(NSString *)title {
    [_rechargeBtn setTitle:title forState:(UIControlStateNormal)];
}

- (void)setQrCodeButtonTitle:(NSString *)title {
    [_QRCodeBtn setTitle:title forState:(UIControlStateNormal)];
}

- (void)setOriginalPice {
    if ([[PayModel sharedModel].originalPrice isEqualToString:@""] ||
        [[PayModel sharedModel].originalPrice isEqualToString:@"0"] ||
        [PayModel sharedModel].originalPrice == nil) {
        [self setNoDiscountView];
    } else {
        [self setDiscountViewWith:[PayModel sharedModel].originalPrice];
    }
}

- (void)setNoDiscountView {
    self.originalPiceLabel.hidden = YES;
    [self.discountLabel removeFromSuperview];

    [self label:self.rechargeTypeLabel Bounds:CGRectMake(0, 0, view_width * 0.8, 30) center:CGPointMake(view_width / 2, view_height * 0.3 + 40) textColor:TEXTCOLOR font:[UIFont systemFontOfSize:18]];

    self.rechargeTypeLabel.text = [NSString stringWithFormat:@"支付金额 : %@ 元",self.rechargeTitle];
}

- (void)setDiscountViewWith:(NSString *)originalPrice {
    self.originalPiceLabel.hidden = NO;
    [self.view addSubview:self.discountLabel];
    if ([PayModel sharedModel].originalPrice.floatValue > 0 && [PayModel sharedModel].originalPrice.floatValue > self.rechargeTitle.floatValue) {

        [self label:self.originalPiceLabel Bounds:CGRectMake(0, 0, view_width * 0.8, 25) center:CGPointMake(view_width / 2, view_height * 0.3 + 30) textColor:TEXTCOLOR font:[UIFont systemFontOfSize:16]];

        [self label:self.discountLabel Bounds:CGRectMake(0, 0, view_width * 0.8, 25) center:CGPointMake(view_width / 2, view_height * 0.3 + 57) textColor:TEXTCOLOR font:[UIFont systemFontOfSize:16]];

        [self label:self.rechargeTypeLabel Bounds:CGRectMake(0, 0, view_width * 0.8, 25) center:CGPointMake(view_width / 2, view_height * 0.3 + 84) textColor:TEXTCOLOR font:[UIFont systemFontOfSize:16]];


        CGFloat discount = self.rechargeTitle.floatValue / [PayModel sharedModel].originalPrice.floatValue * 10;

        self.originalPiceLabel.text = [NSString stringWithFormat:@"原价 : %@ 元",[PayModel sharedModel].originalPrice];

        [self setDiscountString:discount];
        [self setRechargeString:self.rechargeTitle];
    }
}

- (void)label:(UILabel *)label Bounds:(CGRect)bounds center:(CGPoint)center textColor:(UIColor *)textColor font:(UIFont *)font {
    label.bounds = bounds;
    label.center = center;
    label.textColor = textColor;
    label.font = font;
}

- (void)setDiscountString:(CGFloat)discount {
    NSString *string = [NSString stringWithFormat:@"折扣 : %.2f 折",discount];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range1 = [string rangeOfString:[NSString stringWithFormat:@"%.2f",discount]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
    self.discountLabel.attributedText = attributeString;
}

- (void)setRechargeString:(NSString *)rechage {
    NSString *string = [NSString stringWithFormat:@"支付金额 : %@ 元",rechage];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range1 = [string rangeOfString:[NSString stringWithFormat:@"%@",rechage]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
    self.rechargeTypeLabel.attributedText = attributeString;
}


#pragma mark - getter
/** 充值账号 */
- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.bounds = CGRectMake(0, 0, view_width * 0.8, 30);
        _accountLabel.center = CGPointMake(view_width / 2, view_height * 0.3);
        _accountLabel.textColor = TEXTCOLOR;
        _accountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _accountLabel;
}

/** 充值类型 */
- (UILabel *)rechargeTypeLabel {
    if (!_rechargeTypeLabel) {
        _rechargeTypeLabel = [[UILabel alloc] init];
        _rechargeTypeLabel.bounds = CGRectMake(0, 0, view_width * 0.8, 30);
        _rechargeTypeLabel.center = CGPointMake(view_width / 2, view_height * 0.3 + 40);
        _rechargeTypeLabel.textColor = TEXTCOLOR;
        _rechargeTypeLabel.textAlignment = NSTextAlignmentCenter;
        _rechargeTypeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _rechargeTypeLabel;
}

/** 折扣 */
- (UILabel *)discountLabel {
    if (!_discountLabel) {
        _discountLabel = [[UILabel alloc] init];
        _discountLabel.bounds = CGRectMake(0, 0, view_width * 0.8, 30);
        _discountLabel.center = CGPointMake(view_width / 2, view_height * 0.3 + 40);
        _discountLabel.textColor = [UIColor redColor];
        _discountLabel.textAlignment = NSTextAlignmentCenter;
        _discountLabel.font = [UIFont systemFontOfSize:14];
    }
    return _discountLabel;
}

/** 原价 */
- (UILabel *)originalPiceLabel {
    if (!_originalPiceLabel) {
        _originalPiceLabel = [[UILabel alloc] init];
        _originalPiceLabel.bounds = CGRectMake(0, 0, view_width * 0.8, 30);
        _originalPiceLabel.center = CGPointMake(view_width / 2, view_height * 0.3 + 70);
        _originalPiceLabel.textColor = TEXTCOLOR;
        _originalPiceLabel.textAlignment = NSTextAlignmentCenter;
        _originalPiceLabel.font = [UIFont systemFontOfSize:14];
    }
    return _originalPiceLabel;
}


/** 充值按钮 */
- (UIButton *)rechargeBtn {
    if (!_rechargeBtn) {
        _rechargeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _rechargeBtn.bounds = CGRectMake(0, 0, view_width / 2 - 10, 36);
        _rechargeBtn.center = CGPointMake(view_width / 4, view_height * 0.7);
        [_rechargeBtn setBackgroundColor:BUTTON_GREEN_COLOR];
        _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _rechargeBtn.layer.cornerRadius = 8;
        _rechargeBtn.layer.masksToBounds = YES;
        [_rechargeBtn addTarget:self action:@selector(respondsTorechagreButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rechargeBtn;
}

/** 二维码支付按钮 */
- (UIButton *)QRCodeBtn {
    if (!_QRCodeBtn) {
        _QRCodeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _QRCodeBtn.bounds = CGRectMake(0, 0, view_width / 2 - 10, 36);
        _QRCodeBtn.center = CGPointMake(view_width / 4 * 3, view_height * 0.7);
        [_QRCodeBtn setBackgroundColor:BUTTON_YELLOW_COLOR];
        _QRCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _QRCodeBtn.layer.cornerRadius = 8;
        _QRCodeBtn.layer.masksToBounds = YES;
        [_QRCodeBtn addTarget:self action:@selector(respondsToQRCodeButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _QRCodeBtn;
}

/** 剩余平台币 */
- (UILabel *)lastCoin {
    if (!_lastCoin) {
        _lastCoin = [[UILabel alloc] init];
        _lastCoin.bounds = CGRectMake(0, 0, view_width * 0.8, 30);
        _lastCoin.center = CGPointMake(view_width / 2, view_height * 0.3 - 35);
        _lastCoin.textColor = TEXTCOLOR;
        _lastCoin.textAlignment = NSTextAlignmentCenter;
    }
    return _lastCoin;
}





@end
