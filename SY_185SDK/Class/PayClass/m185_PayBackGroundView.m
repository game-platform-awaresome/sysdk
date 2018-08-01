//
//  m185_PayBackGroundView.m
//  SY_185SDK
//
//  Created by 燚 on 2017/10/10.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "m185_PayBackGroundView.h"
#import <WebKit/WebKit.h>

#import "PAlipayController.h"
#import "PWechatPayController.h"
#import "PTenpayController.h"
#import "PPhonepayController.h"
#import "PPlatformCoinViewController.h"

#import "PSelectCell.h"

#define CELLIDE @"PSELECTCELL"

#define CLOSEBUTTON_BRING_TO_FRONT [self.payBack bringSubviewToFront:self.closeButton]
#define WEAK_CLOSEBUTTON_BRING_TO_FRONT [weakSelf.payBack bringSubviewToFront:self.closeButton]

#define SELF_DELEGATE_PAYMETHOD(method) \
if (self.delegate && [self.delegate respondsToSelector:@selector(payViewPayStartWithPayType:CardID:CardPassword:CardAmount:)]) { \
    [self.delegate payViewPayStartWithPayType:method CardID:nil CardPassword:nil CardAmount:nil]; \
}

@interface m185_PayBackGroundView ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,WKUIDelegate,UIWebViewDelegate,AlipayDelegate,WechatPayDelegate,TenPayDelegate,PhonepayDelegate,PlatformCoinDelegate>

/** 支付的背景 */
@property (nonatomic, strong) UIImageView *payBack;

/** 选择支付的方式 */
@property (nonatomic, strong) UITableView *selectTableView;
@property (nonatomic, strong) NSArray *seleectArray;
@property (nonatomic, strong) NSArray *selectImageArray;

/** 子支付控制器 */
@property (nonatomic, strong) PAlipayController             *aliPayController;
@property (nonatomic, strong) PWechatPayController          *wechatPayController;
@property (nonatomic, strong) PTenpayController             *tenPayController;
@property (nonatomic, strong) PPhonepayController           *phonePayController;
@property (nonatomic, strong) PPlatformCoinViewController   *platformCoinController;
@property (strong, nonatomic) NSArray <UIViewController *>  *selectControllers;
/** 当前子控制器 */
@property (nonatomic, strong) UIViewController *currentController;

/** 分割线 */
@property (nonatomic, strong) UIView *separaLine;

/** 关闭按钮 */
@property (nonatomic, strong) UIButton *closeButton;

/** webView */
@property (nonatomic, strong) WKWebView *payWebView;
/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;

@end


@implementation m185_PayBackGroundView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addobserver];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    [self addChildViewController:self.aliPayController];
    self.currentController = self.aliPayController;
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];

#warning show platform
//    BOOL isShowPlatform = YES;
    if ([SDKModel sharedModel].platform_money_enabled.boolValue) {
//        _seleectArray = @[@"支付宝",@"微信",@"财付通",@"手机付",@"平台币"];
        _seleectArray = @[@"支付宝",@"微信",@"手机付",@"平台币"];
        _selectImageArray = @[@"SDKAlipay",@"SDKWechatPay",@"SDKPhonePay",@"SDKPlatformCoinPay"];
        _selectControllers = @[self.aliPayController,self.wechatPayController,self.phonePayController,self.platformCoinController];
        
    } else {
//        _seleectArray = @[@"支付宝",@"微信",@"财付通",@"手机付"];
        _seleectArray = @[@"支付宝",@"微信",@"手机付"];
//        _selectImageArray = @[@"SDKAlipay",@"SDKWechatPay",@"SDKTenPay",@"SDKPhonePay"];
        _selectImageArray = @[@"SDKAlipay",@"SDKWechatPay",@"SDKPhonePay"];
        _selectControllers = @[self.aliPayController,self.wechatPayController,self.phonePayController];
    }

    [self.view addSubview:self.payBack];
    [self.payBack addSubview:self.separaLine];
    [self.payBack addSubview:self.closeButton];
    [self.selectTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:(UITableViewScrollPositionNone)];
}

#pragma mark - payDelegate
/** 阿里支付 */
- (void)AliPayControllerSelectAlipay {
    SDK_Log(@"支付宝支付");
    SELF_DELEGATE_PAYMETHOD((PayType)Alipay);
}

/** 阿里二维码 */
- (void)AliPayControllerSelectQRpay {
    SDK_Log(@"支付宝扫码");
    SELF_DELEGATE_PAYMETHOD(AliQRcode);
}

/** 微信支付 */
- (void)WechatPayControllerSelectWechatpay {
    SDK_Log(@"微信支付");
    SELF_DELEGATE_PAYMETHOD(WechatPay);
}

/** 微信二维码 */
- (void)WechatPayControllerSelectQRpay {
    SDK_Log(@"微信扫码");
    SELF_DELEGATE_PAYMETHOD(WechatQRcode);
}

/** 财付通支付 */
- (void)TenPayControllerSelectTenPay {
    SDK_Log(@"财付通");
    SELF_DELEGATE_PAYMETHOD(TenPay);
}

/** 手机充值 */
- (void)PhonePayControllerSelectPhonePayWithPhoneTye:(PhonePayTye)payType CardID:(NSString *)cardID CardPassword:(NSString *)cardPassword CardAmount:(NSString *)cardAmount {
    SDK_Log(@"手机充值");
    if (self.delegate && [self.delegate respondsToSelector:@selector(payViewPayStartWithPayType:CardID:CardPassword:CardAmount:)]) {
        [self.delegate payViewPayStartWithPayType:(PayType)payType CardID:cardID CardPassword:cardPassword CardAmount:cardAmount];
    }
}


/** 平台币支付 */
- (void)PlatformCoinControllerSelectPlatformCoinpay {
    SELF_DELEGATE_PAYMETHOD(platformCoin);
}


#pragma mark - UIWebViewDelegate
- (void)addWebViewWithUrl:(NSString *)url {
    NSURL *webUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",url]];
    [self.payWebView loadRequest:[NSURLRequest requestWithURL:webUrl]];
    [self.payBack addSubview:self.payWebView];
    CLOSEBUTTON_BRING_TO_FRONT;
}


#pragma mark - replaceController
//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController {

    [self addChildViewController:newController];

    [self transitionFromViewController:oldController toViewController:newController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {

        //if (finished) {

            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentController = newController;

        //}else{

           // self.currentController = oldController;
//
       // }
    }];
}

#pragma mark - 监听屏幕旋转
/** 添加监听事件 */
- (void)addobserver {

    UIDevice *device = [UIDevice currentDevice];
    [device beginGeneratingDeviceOrientationNotifications];

    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];

    [notification addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];

}

/** 监听屏幕的旋转 */
- (void)orientationChanged:(NSNotification *)note  {
    self.payBack.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.seleectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.height = PAYVIEW_HEIGHT / _seleectArray.count;

    if (indexPath.row == 0) {
        [cell setSelected:YES animated:NO];
    } else {
        [cell setSelected:NO animated:NO];
    }


    cell.logoTitle = _seleectArray[indexPath.row];

    cell.logoImage = SDK_IMAGE(_selectImageArray[indexPath.row]);


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  PAYVIEW_HEIGHT / self.seleectArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentController != self.selectControllers[indexPath.row]) {
        [self replaceController:self.currentController newController:self.selectControllers[indexPath.row]];
    }
//    switch (indexPath.row) {
//        case 0:
//        {
//            if (self.currentController != self.aliPayController) {
//                [self replaceController:self.currentController newController:self.aliPayController];
//            }
//        }
//            break;
//        case 1:
//        {
//            if (self.currentController != self.wechatPayController) {
//                [self replaceController:self.currentController newController:self.wechatPayController];
//            }
//        }
//            break;
//        case 2:
//        {
//            if (self.currentController != self.tenPayController) {
//                [self replaceController:self.currentController newController:self.tenPayController];
//            }
//        }
//            break;
//        case 3:
//        {
//            if (self.currentController != self.phonePayController) {
//                [self replaceController:self.currentController newController:self.phonePayController];
//            }
//        }
//            break;
//        case 4:
//        {
//            if (self.currentController != self.platformCoinController) {
//                [self replaceController:self.currentController newController:self.platformCoinController];
//            }
//        }
//            break;
//        default:
//            break;
//    }
    [self.payBack bringSubviewToFront:self.closeButton];
}

#pragma mark - setter
- (void)setUserID:(NSString *)userID {
    _userID = userID;
    self.aliPayController.rechargeAccount = [NSString stringWithFormat:@"%@",userID];
    self.wechatPayController.rechargeAccount = [NSString stringWithFormat:@"%@",userID];
    self.tenPayController.rechargeAccount = [NSString stringWithFormat:@"%@",userID];
    self.phonePayController.rechargeAccount = [NSString stringWithFormat:@"%@",userID];
    self.platformCoinController.rechargeAccount = [NSString stringWithFormat:@"%@",userID];
}

- (void)setAmount:(NSString *)amount {
    _amount = amount;
    self.aliPayController.rechargeTitle = [NSString stringWithFormat:@"%@",_amount];
    self.wechatPayController.rechargeTitle = [NSString stringWithFormat:@"%@",_amount];
    self.tenPayController.rechargeTitle = [NSString stringWithFormat:@"%@",_amount];
    self.phonePayController.rechargeTitle = [NSString stringWithFormat:@"%@",_amount];
    self.platformCoinController.rechargeTitle = [NSString stringWithFormat:@"%@",_amount];
}


- (void)closePayView {

    if (self.delegate && [self.delegate respondsToSelector:@selector(payViewCloseView)]) {
        [self.delegate payViewCloseView];
    } else {
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }

    [self.payWebView removeFromSuperview];
}

#pragma mark - getter
/** 支付页面的背景 */
- (UIImageView *)payBack {
    if (!_payBack) {
        _payBack = [[UIImageView alloc] init];
        _payBack.bounds = CGRectMake(0, 0, PAYVIEW_WIDTH,  PAYVIEW_HEIGHT);
        _payBack.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
        _payBack.userInteractionEnabled = YES;
        _payBack.backgroundColor = [UIColor whiteColor];

        _payBack.layer.cornerRadius = 8;
        _payBack.layer.masksToBounds = YES;

        [_payBack addSubview:self.aliPayController.view];
        [_payBack addSubview:self.selectTableView];
    }
    return _payBack;
}

/** 选择器(tableview) */
- (UITableView *)selectTableView {
    if (!_selectTableView) {
        _selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.payBack.frame.size.width / 3, self.payBack.frame.size.height) style:(UITableViewStylePlain)];

        _selectTableView.dataSource = self;
        _selectTableView.delegate = self;

        _selectTableView.showsHorizontalScrollIndicator = NO;
        _selectTableView.showsVerticalScrollIndicator = NO;

        [_selectTableView registerClass:[PSelectCell class] forCellReuseIdentifier:CELLIDE];

        _selectTableView.tableFooterView = [UIView new];
        _selectTableView.scrollEnabled = NO;
        _selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _selectTableView;
}

/** 子控制器 */
- (PAlipayController *)aliPayController {
    if (!_aliPayController) {
        _aliPayController = [PAlipayController new];
        _aliPayController.delegate = self;
    }
    return _aliPayController;
}

- (PWechatPayController *)wechatPayController {
    if (!_wechatPayController) {
        _wechatPayController = [PWechatPayController new];
        _wechatPayController.delegate = self;
    }
    return _wechatPayController;
}

- (PTenpayController *)tenPayController {
    if (!_tenPayController) {
        _tenPayController = [PTenpayController new];
        _tenPayController.delegate = self;
    }
    return _tenPayController;
}

- (PPhonepayController *)phonePayController {
    if (!_phonePayController) {
        _phonePayController = [[PPhonepayController alloc] init];
        _phonePayController.delegate = self;
    }
    return _phonePayController;
}

- (PPlatformCoinViewController *)platformCoinController {
    if (!_platformCoinController) {
        _platformCoinController = [[PPlatformCoinViewController alloc] init];
        _platformCoinController.delegate = self;
    }
    return _platformCoinController;
}

/** 分割线 */
- (UIView *)separaLine {
    if (!_separaLine) {
        _separaLine = [[UIView alloc] initWithFrame:CGRectMake(PAYVIEW_WIDTH / 3, 0, 1, PAYVIEW_HEIGHT)];

        _separaLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    }
    return _separaLine;
}

/** 关闭按钮 */
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _closeButton.frame = CGRectMake(PAYVIEW_WIDTH - 35, 5, 30, 30);
        [_closeButton setImage:SDK_IMAGE(@"SYSDK_closeButton") forState:(UIControlStateNormal)];
        [_closeButton addTarget:self action:@selector(closePayView) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}





@end
