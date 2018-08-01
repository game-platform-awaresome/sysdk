//
//  FFPayDetailViewController.h
//  SY_185SDK
//
//  Created by 燚 on 2018/5/2.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFPayDetailViewController : UIViewController


/** 充值类型标签 */
@property (nonatomic, strong) NSString *rechargeTitle;
/** 充值账号 */
@property (nonatomic, strong) NSString *rechargeAccount;

/** 充值类型 */
@property (nonatomic, strong) UILabel *rechargeTypeLabel;

/** 原价标签 */
@property (nonatomic, strong) UILabel *originalPiceLabel;

/** 充值按钮 */
@property (nonatomic, strong) UIButton *rechargeBtn;

/** 二维码按钮 */
@property (nonatomic, strong) UIButton *QRCodeBtn;


- (void)respondsTorechagreButton;
- (void)respondsToQRCodeButton;

- (void)initUserInterface;
- (void)addSubViews;
- (void)addLastCoinView;

- (void)setRechargeButtonTitle:(NSString *)title;
- (void)setQrCodeButtonTitle:(NSString *)title;

- (void)setNoDiscountView;
- (void)setDiscountViewWith:(NSString *)originalPrice;
- (void)setRechargeString:(NSString *)rechage;

@end
