//
//  SYPayController.m
//  SY_185SDK
//
//  Created by 燚 on 2017/10/10.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SYPayController.h"
#import "m185_PayBackGroundView.h"
#import "m185WebViewController.h"
#import "m185CheackPayResults.h"
#import "SDKModel.h"

#ifdef DEBUG

#define BACKGROUNDCOLOR controller.useWindow ? RGBACOLOR(0, 0, 200, 150) : RGBACOLOR(200, 0, 0, 150)

#else

#define BACKGROUNDCOLOR RGBACOLOR(111, 111, 111, 111)

#endif



@interface SYPayController ()<m185_PayBackGroundViewDelegate, m185WebViewControllerDelegate, CheckResultsDelegate>

/** 是否使用窗口 */
@property (nonatomic, assign) BOOL useWindow;

/** window 加载 */
@property (nonatomic, strong) UIWindow *loginControllerBackGroundWindow;
@property (nonatomic, strong) UIViewController *windowRootViewController;

///** view 加载 */
//@property (nonatomic, strong) UIView *loginControllerBackGroundView;

/** 背景视图 */
@property (nonatomic, strong) m185_PayBackGroundView *backgroundViewController;
/** web View back */
@property (nonatomic, strong) m185WebViewController *webViewController;

/** 是否已经支付 */
@property (nonatomic, assign) BOOL isUserPay;


/** 支付回调参数 */
@property (nonatomic, strong) NSString *orderID;

/** 是否加载了网页 */
@property (nonatomic, assign) BOOL isShowWebView;

/** 检查支付的字典 */
@property (nonatomic, strong) NSMutableDictionary *cheackResultsDict;


@end

static SYPayController *controller = nil;

@implementation SYPayController

/** 单例 */
+ (SYPayController *)sharedController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (controller == nil) {
            controller = [[SYPayController alloc] init];
        }
    });
    return controller;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _useWindow = [SDKModel sharedModel].useWindow;
    }
    return self;
}

/** 支付 */
+ (void)payStartWithServerID:(NSString *)serverID
                  serverName:(NSString *)serverName
                      roleID:(NSString *)roleID
                    roleName:(NSString *)roleName
                   productID:(NSString *)productID
                 productName:(NSString *)productName
                      amount:(NSString *)amount
               originalPrice:(NSString *)originalPrice
                   extension:(NSString *)extension Delegate:(id<SYPayControllerDeleagete>)payDelegate {

    [SYPayController payStartWithServerID:serverID
                               serverName:serverName
                                   roleID:roleID
                                 roleName:roleName
                                productID:productID
                              productName:productName
                                   amount:amount
                            originalPrice:originalPrice
                                extension:extension
                                 payModel:@"1"
                                 Delegate:payDelegate];

}

/** GM 支付 */
+ (void)GMPayStartWithServerID:(NSString *)serverID serverName:(NSString *)serverName roleID:(NSString *)roleID roleName:(NSString *)roleName productID:(NSString *)productID productName:(NSString *)productName amount:(NSString *)amount extension:(NSString *)extension Delegate:(id<SYPayControllerDeleagete>)payDelegate {

    [SYPayController payStartWithServerID:serverID serverName:serverName roleID:roleID roleName:roleName productID:productID productName:productName amount:amount originalPrice:@"0" extension:extension payModel:@"2" Delegate:payDelegate];


}


+ (void)payStartWithServerID:(NSString *)serverID
                  serverName:(NSString *)serverName
                      roleID:(NSString *)roleID
                    roleName:(NSString *)roleName
                   productID:(NSString *)productID
                 productName:(NSString *)productName
                      amount:(NSString *)amount
               originalPrice:(NSString *)originalPrice
                   extension:(NSString *)extension
                    payModel:(NSString *)payModel
                    Delegate:(id<SYPayControllerDeleagete>)payDelegate {

    SDK_Log(@"开始支付验证");
    if (SDK_GETUID == nil) {
        SDK_MESSAGE(@"尚未登录");
        return;
    }

    if (SDK_GETAPPID == nil || [SDK_GETAPPID isEqualToString:@""]) {
        SDK_MESSAGE(@"尚未注册");
        return;
    }

    if (extension == nil) {
        extension = @"";
    }

    if (originalPrice == nil) {
        originalPrice = @"0";
    }

    SDK_Log(@"开始支付");
    SDK_START_ANIMATION;
    SDK_Log(@"请求是否可以支付");
    [PayModel payReadyWithCompletion:^(NSDictionary *content, BOOL success) {

        SDK_STOP_ANIMATION;
        [SYPayController sharedController].isUserPay = NO;
        controller.SYPayDelegate = payDelegate;

        syLog(@"是否可以支付  === %@",content);



        if (success) {


            NSString *originAmount;
            NSString *currentAmount;
            syLog(@"discout === %@", [SDKModel sharedModel].discount);
            if ([SDKModel sharedModel].discount == nil || [[SDKModel sharedModel].discount isEqualToString:@"0"]) {
                currentAmount = amount;
                originAmount = @"0";
            } else {

                originAmount = amount.copy;
                currentAmount = [NSString stringWithFormat:@"%.2lf",amount.floatValue * [SDKModel sharedModel].discount.floatValue / 10];

                syLog(@"origint === %@  curretn == %@",originAmount,currentAmount);
            }

            controller.backgroundViewController.userID = [UserModel currentUser].username;
            controller.backgroundViewController.amount = currentAmount;

            SDKLOG(@"allow payment");
            SDK_Log(@"可以支付");
            [[PayModel sharedModel] setAllPropertyWithDict:@{@"serverID":serverID,
                                                             @"serverNAME":serverName,
                                                             @"roleID":roleID,
                                                             @"roleNAME":roleName,
                                                             @"productID":productID,
                                                             @"productNAME":productName,
                                                             @"amount":currentAmount,
                                                             @"originalPrice":originAmount,
                                                             @"extend":extension,
                                                             @"payModel":payModel}];
            //显示支付页面
            [controller showPayView];

            //同步平台币
            [UserModel synchronizePlatformCoin];

        } else {
            //请求失败
            SDK_Log(@"不可以支付");
            SDK_Log(@"回调支付失败");
            if (controller.SYPayDelegate && [controller.SYPayDelegate respondsToSelector:@selector(m185_PayDelegateWithPaySuccess:WithInformation:)]) {
                [controller.SYPayDelegate m185_PayDelegateWithPaySuccess:NO WithInformation:content];
            }
        }
    }];
}



#pragma mark - Background view controller delegate
/** 关闭了支付页面 */
- (void)payViewCloseView {
    if (_isUserPay) {

    } else {
        //如果还没支付 就关闭了页面,回调失败
        SDK_Log(@"关闭了支付页面 : 回调支付失败");
        if (self.SYPayDelegate && [self.SYPayDelegate respondsToSelector:@selector(m185_PayDelegateWithPaySuccess:WithInformation:)]) {
            [self.SYPayDelegate m185_PayDelegateWithPaySuccess:NO WithInformation:@{@"orderID":@"",@"msg":@"user close the payment page"}];
        }
    }
    [self hidePayView];
}


/** 发起支付 */
- (void)payViewPayStartWithPayType:(PayType)payType CardID:(NSString *)cardID CardPassword:(NSString *)cardPassword CardAmount:(NSString *)cardAmount {
    SDK_Log(@"发起支付");
    if (cardID == nil) {
        cardID = @"";
    }
    if (cardAmount == nil) {
        cardAmount = @"";
    }
    if (cardPassword == nil) {
        cardPassword = @"";
    }




    NSDictionary *dict = @{@"payType":[NSString stringWithFormat:@"%ld",(long)payType],
                           @"cardID":cardID,
                           @"cardPass":cardPassword,
                           @"cardMoney":cardAmount};

//    NSDictionary *dict = @{@"payType":[NSString stringWithFormat:@"%ld",(long)payType],
//                          @"cardID":cardID,
//                          @"cardPass":cardPassword,
//                          @"cardMoney":cardAmount};



//    NSLog(@"sy_sdk pay para === %@",dict);

    [[PayModel sharedModel] setAllPropertyWithDict:dict];

    SDK_Log(@"开始支付");
//    NSLog(@"sy_sdk pay start");
    SDK_START_ANIMATION;
    [[PayModel sharedModel] payStartWithCompletion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;

        SDK_Log(@"结束支付");
        if (success) {
            NSDictionary *dict = SDK_CONTENT_DATA;
            //已经开始支付
            self.isUserPay = YES;
            //设置支付查询
            self.orderID = [NSString stringWithFormat:@"%@",dict[@"orderID"]];
            //隐藏支付页面
            [self hidePayView];
            //显示网页
//            [self.backgroundViewController addWebViewWithUrl:dict[@"url"]];
            SDK_Log(@"显示网页");
            [self showWebView];
            [self.webViewController addWebViewWithUrl:dict[@"url"]];
        } else {
            SDK_MESSAGE(content[@"msg"]);
        }
    }];
}

#pragma mark - Pay view
- (void)showPayView {
    self.backgroundViewController.view.backgroundColor = BACKGROUNDCOLOR;
    if ([SDKModel sharedModel].useWindow) {
        self.loginControllerBackGroundWindow.rootViewController = self.backgroundViewController;
        [self.loginControllerBackGroundWindow makeKeyAndVisible];
    } else {
        if ([InfomationTool rootViewController]) {
//            [[InfomationTool rootViewController] addChildViewController:self.backgroundViewController];
            [[InfomationTool rootViewController].view addSubview:self.backgroundViewController.view];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showPayView];
            });
        }
    }
}

- (void)hidePayView {
    SDK_Log(@"隐藏支付页");
    if ([SDKModel sharedModel].useWindow) {
        [self.loginControllerBackGroundWindow resignKeyWindow];
        self.loginControllerBackGroundWindow = nil;
    }
//    [self.backgroundViewController removeFromParentViewController];
    [self.backgroundViewController.view removeFromSuperview];
}

#pragma mark - show web view
- (void)showWebView {
    self.backgroundViewController.view.backgroundColor = BACKGROUNDCOLOR;
    if ([SDKModel sharedModel].useWindow) {
        self.loginControllerBackGroundWindow.rootViewController = self.webViewController;
        [self.loginControllerBackGroundWindow makeKeyAndVisible];
    } else {
        if ([InfomationTool rootViewController]) {
            [[InfomationTool rootViewController] addChildViewController:self.webViewController];
            [[InfomationTool rootViewController].view addSubview:self.webViewController.view];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showWebView];
            });
        }
    }
}

- (void)hideWebView {

    [self.webViewController removeFromParentViewController];
    [self.webViewController.view removeFromSuperview];

    if ([SDKModel sharedModel].useWindow) {
        [self.loginControllerBackGroundWindow resignKeyWindow];
        self.loginControllerBackGroundWindow = nil;
    }
}

#pragma mark - webView delegate (close web view)
- (void)m185WebViewController:(m185WebViewController *)controller closeWebViewWith:(id)info {
    [self hideWebView];
}

#pragma mark - delegate
- (void)checkResultsDelegateCheckResultSuccess:(BOOL)success infomation:(NSDictionary *)dict {
    SDKLOG(@"payment queried");
    SDK_Log(@"支付查询结果");
    if (self.SYPayDelegate && [self.SYPayDelegate respondsToSelector:@selector(m185_PayDelegateWithPaySuccess:WithInformation:)]) {
        [self.SYPayDelegate m185_PayDelegateWithPaySuccess:success WithInformation:dict];
    }
}

#pragma mark - setter
- (void)setOrderID:(NSString *)orderID {
    SDKLOG(@"payment query");
    _orderID = orderID;
    SDK_Log(@"开始支付查询");
    [m185CheackPayResults cheackResultsWithOrderID:orderID delegage:self];
}

#pragma mark - getter
- (UIWindow *)loginControllerBackGroundWindow {
    if (!_loginControllerBackGroundWindow) {
        _loginControllerBackGroundWindow = [[UIWindow alloc] init];
//        _loginControllerBackGroundWindow.rootViewController = self.windowRootViewController;
        _loginControllerBackGroundWindow.backgroundColor = [UIColor clearColor];
        _loginControllerBackGroundWindow.windowLevel = SDK_WINDOW_LEVEL;
    }
    return _loginControllerBackGroundWindow;
}

- (UIViewController *)windowRootViewController {
    if (!_windowRootViewController) {
        _windowRootViewController = [[UIViewController alloc] init];
        _windowRootViewController.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        _windowRootViewController.view.backgroundColor = BACKGROUNDCOLOR;
    }
    return _windowRootViewController;
}

//- (UIView *)loginControllerBackGroundView {
//    if (!_loginControllerBackGroundView) {
//        _loginControllerBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
//        _loginControllerBackGroundView.backgroundColor = BACKGROUNDCOLOR;
//    }
//    return _loginControllerBackGroundView;
//}

- (m185_PayBackGroundView *)backgroundViewController {
    if (!_backgroundViewController) {
        _backgroundViewController = [[m185_PayBackGroundView alloc] init];
        _backgroundViewController.delegate = self;
    }
    return _backgroundViewController;
}

- (m185WebViewController *)webViewController {
    if (!_webViewController) {
        _webViewController = [[m185WebViewController alloc] init];
        _webViewController.delegate = self;
    }
    return _webViewController;
}


@end






