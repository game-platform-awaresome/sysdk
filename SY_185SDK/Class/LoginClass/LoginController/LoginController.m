//
//  LoginController.m
//  SY_185SDK
//
//  Created by 燚 on 2017/9/29.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "LoginController.h"

#import "m185_LoginBackGroundView.h"
#import "UserModel.h"
#import "SDKModel.h"

@class SY_BindingPhoneView;



#define LOGIN_BACK_WIDTH FLOAT_MENU_WIDTH
#define LOGIN_BACK_HEIGHT LOGIN_BACK_WIDTH * 0.8


#ifdef DEBUG

#define BACKGROUNDCOLOR controller.useWindow ? RGBACOLOR(0, 0, 200, 150) : RGBACOLOR(200, 0, 0, 150)

#else

#define BACKGROUNDCOLOR RGBACOLOR(111, 111, 111, 111)

#endif

#define LOGINSUCCESS \
    if (success) {\
    SDKLOG(@"log in success");\
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginController:loginSuccess:withStatus:)]) {\
        [self.delegate loginController:self loginSuccess:YES withStatus:@{@"status":@"1",@"username":SDK_CONTENT_DATA[@"username"],@"token":SDK_CONTENT_DATA[@"token"]}];\
    }\
    [[UserModel currentUser] setAllPropertyWithDict:SDK_CONTENT_DATA];\
    [viewController setUsername:account];\
    [viewController setPassWord:password];\
    [LoginController showBingPhoneView];\
    [viewController hideOtherView];\
    } else {\
        SDKLOG(@"log in failure");\
        [InfomationTool showAlertMessage:content[@"msg"] dismissTime:1 dismiss:nil];\
    }\

static UIWindow *appWindow = nil;
@interface LoginController ()<m185_LoginBackGroundViewDeleagte>

/** window 加载 */
@property (nonatomic, strong) UIWindow *loginControllerBackGroundWindow;
@property (nonatomic, strong) UIViewController *windowRootViewController;

/** view 加载 */
@property (nonatomic, strong) UIView *loginControllerBackGroundView;

/** 背景视图 */
@property (nonatomic, strong) m185_LoginBackGroundView *backgroundView;




@property (nonatomic, strong) UIViewController *testViewController;



@end


LoginController *controller = nil;


@implementation LoginController

#pragma mark - init
+ (LoginController *)sharedController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (controller == nil) {
            controller = [[LoginController alloc] init];
        }
    });
    return controller;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addAutoLoginView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (void)addAutoLoginView {
    NSString *autoLogin = SDK_ISAUTOLOGIN;
    NSString *isUserLogOut = SDK_USERDEFAULTS_GET_OBJECT(@"isUserLogOut");

    NSDictionary *dict = [UserModel getAccountAndPassword];
    NSString *account = dict[@"account"];
    NSString *password = dict[@"password"];
    NSString *phoneNumber = dict[@"phoneNumber"];
    if (account && password) {
        [self.backgroundView setUsername:account];
        [self.backgroundView setPassWord:password];
    } else if (phoneNumber && password) {
        [self.backgroundView setPhoneNumber:phoneNumber];
        [self.backgroundView setPassWord:password];
    } else {
        [self.backgroundView setUsername:@""];
        [self.backgroundView setPassWord:@""];
        autoLogin = @"0";
    }
    if (autoLogin && autoLogin.integerValue != 0 && isUserLogOut.integerValue != 1) {
        SDKLOG(@"loading auto login view");
        SDK_Log(@"显示自动登录页面");
        [self.backgroundView addAutoLoginView];
    }

//    SDKModel *model = [SDKModel sharedModel];
//    NSDictionary *dict = nil;
//    SDK_Log(@"开始显示登录页面");
//    if (model.username.length > 4) {
//        dict = [UserModel getAccountAndPassword];
//        NSString *account = dict[@"account"];
//        NSString *password = dict[@"password"];
//        if (account && password && [model.username isEqualToString:account]) {
//            [self.backgroundView setUsername:account];
//            [self.backgroundView setPassWord:password];
//        } else {
//            [self.backgroundView setUsername:model.username];
//            [self.backgroundView setPassWord:@""];
//            autoLogin = @"0";
//        }
//
//        if (autoLogin && autoLogin.integerValue != 0 && isUserLogOut.integerValue != 1) {
//            SDKLOG(@"loading auto login view");
//            SDK_Log(@"显示自动登录页面");
//            [self.backgroundView addAutoLoginView];
//        }
//
//    } else {
//#warning show one up register view
////        [self m185_loginBackGroundView:self.backgroundView respondsToOneUpResgister:nil];
//        SDK_Log(@"显示登录页面");
//        [self.backgroundView showPhoneLogin:YES];
//    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - show login controller
+ (void)showLoginViewUseTheWindow:(BOOL)useWindow
                     WithDelegate:(id<LoginControllerDeleagete>)delegate {

    [LoginController sharedController].delegate = delegate;

    controller.useWindow = useWindow;

    if ([UserModel currentUser].uid) {
        [InfomationTool showAlertMessage:@"已登录账号" dismissTime:0.7 dismiss:nil];
        return;
    }

    [self showView];
    controller.isShow = YES;
//    [controller startAnimation];
//
//    [controller stopAnimationAfter:10];

//    if (useWindow) {
//        syLog(@"befor key window  === %@", [UIApplication sharedApplication].keyWindow);
//        appWindow = [UIApplication sharedApplication].keyWindow;
//        [controller.loginControllerBackGroundWindow makeKeyAndVisible];
//        [controller.loginControllerBackGroundWindow resignKeyWindow];
//        [appWindow makeKeyWindow];
//        [controller.windowRootViewController.view addSubview:controller.backgroundView];
//        [controller.windowRootViewController.view addGestureRecognizer:tap];
//        syLog(@"after key window  === %@", [UIApplication sharedApplication].keyWindow);
//    } else {
//        [[InfomationTool rootViewController].view addSubview:controller.loginControllerBackGroundView];
//        [controller.loginControllerBackGroundView addSubview:controller.backgroundView];
//        [controller.loginControllerBackGroundView addGestureRecognizer:tap];
//    }

}

+ (void)showView {
    if ([UIApplication sharedApplication].keyWindow) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:controller action:@selector(loginViewResignFirstResponds)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;

        if ([UIApplication sharedApplication].keyWindow.windowLevel == UIWindowLevelNormal) {
            [[UIApplication sharedApplication].keyWindow addSubview:controller.loginControllerBackGroundView];
            [controller.loginControllerBackGroundView addSubview:controller.backgroundView];
            [controller.loginControllerBackGroundView addGestureRecognizer:tap];
        } else {
            for (UIWindow *window in [UIApplication sharedApplication].windows) {
                if (window.windowLevel == UIWindowLevelNormal) {
                    [[UIApplication sharedApplication].keyWindow addSubview:controller.loginControllerBackGroundView];
                    [controller.loginControllerBackGroundView addSubview:controller.backgroundView];
                    [controller.loginControllerBackGroundView addGestureRecognizer:tap];
                    break;
                }
            }
        }


        [controller.loginControllerBackGroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo([UIApplication sharedApplication].keyWindow);
        }];

        [controller.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(LOGIN_BACK_WIDTH, LOGIN_BACK_HEIGHT));
            make.center.mas_equalTo(CGPointZero);
        }];

        if (!controller.testViewController) {
            controller.testViewController = [UIViewController new];
        }
        [[UIApplication sharedApplication].keyWindow addSubview:controller.testViewController.view];
        [[UIApplication sharedApplication].keyWindow sendSubviewToBack:controller.testViewController.view];

    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showView];
        });
    }
}

- (void)loginViewResignFirstResponds {
    [self.backgroundView inputResignFirstResponds];
}

+ (void)signOut {
    [LoginController hideLoginView];
}

+ (void)hideLoginView {
//    if (controller.useWindow) {
//        [controller.loginControllerBackGroundWindow resignKeyWindow];
//        controller.windowRootViewController = nil;
//        controller.loginControllerBackGroundView.hidden = YES;
//        controller.loginControllerBackGroundWindow = nil;

//        if (appWindow) {
//            [appWindow makeKeyAndVisible];
//        }

//        [controller.loginControllerBackGroundWindow setHidden:YES];

//        NSArray *windowArray = [UIApplication sharedApplication].windows;
//        for (UIWindow *window in windowArray) {
//            NSLog(@"\nwindow === %@\n",window);
//        }
//    } else {
//        [controller.loginControllerBackGroundView removeFromSuperview];
//    }
    [LoginController sharedController].isShow = NO;
    [controller.loginControllerBackGroundView removeFromSuperview];
}

+ (void)showADPicView {
#warning show ad pic image view
    BOOL isShowAdPicView = [SDKModel sharedModel].isdisplay_ad.boolValue;
    if (isShowAdPicView) {
        [self hideLoginView];


        [[UIApplication sharedApplication].keyWindow addSubview:(UIView *)controller.backgroundView.adPicImageView];
//        [controller.backgroundView removeFromSuperview];

//        if (controller.useWindow) {
//            [controller.windowRootViewController.view addSubview:(UIView *)controller.backgroundView.adPicImageView];
//            [self hideLoginView];
////        }
//        } else {
//            [[InfomationTool rootViewController].view addSubview:(UIView *)controller.backgroundView.adPicImageView];
//        }
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [[UIApplication sharedApplication].keyWindow addSubview:(UIView *)controller.backgroundView.adPicImageView];
//        });
    } else {


        [LoginController showBingPhoneView];


    }
}

+ (void)showBingPhoneView {
#warning show bind mobile view
    //添加绑定手机页面
//    BOOL isShowbindView = YES;
    BOOL isShowbindView = [SDKModel sharedModel].bind_mobile_enabled.boolValue;
    if (isShowbindView && ([UserModel currentUser].mobile == nil || [UserModel currentUser].mobile.length < 11)) {
        //显示绑定手机页面
        SDK_Log(@"显示绑定手机页面");
        [controller.backgroundView removeFromSuperview];
//        if (controller.useWindow) {
//            [controller.windowRootViewController.view addSubview:(UIView *)controller.backgroundView.bingdingPhoneView];
//        } else {
//            [[InfomationTool rootViewController].view addSubview:(UIView *)controller.backgroundView.bingdingPhoneView];
//        }
        [controller.loginControllerBackGroundView addSubview:(UIView *)controller.backgroundView.bingdingPhoneView];
    } else {
        [LoginController showBindNameView];
    }
}

+ (void)showBindNameView {
#warning show bind idcard view
    BOOL isShowBindView = [SDKModel sharedModel].name_auth_enabled.boolValue;
    if (isShowBindView && ([UserModel currentUser].id_card == nil || [UserModel currentUser].id_card.length == 0)) {
        [controller.backgroundView removeFromSuperview];
        SDK_Log(@"显示绑定信息页面");
//        if (controller.useWindow) {
//            [controller.windowRootViewController.view addSubview:(UIView *)controller.backgroundView.bindingIDCardView];
//        } else {
//            [[InfomationTool rootViewController].view addSubview:(UIView *)controller.backgroundView.bindingIDCardView];
//        }
        [controller.loginControllerBackGroundView addSubview:(UIView *)controller.backgroundView.bindingIDCardView];
    } else {
        [LoginController hideLoginView];
    }
}

#pragma mark - close ad pic view
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToCloseADPicView:(id)info {
    [LoginController showBingPhoneView];
}

#pragma mark - close bind phone view
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToCloseBindingPhoneView:(id)info {
    [LoginController showBindNameView];
}

#pragma mark - show account list view
- (void)showAccountListView {
    [controller.backgroundView removeFromSuperview];
    SDK_Log(@"显示绑定信息页面");
//    if (controller.useWindow) {
//        [controller.windowRootViewController.view addSubview:(UIView *)controller.backgroundView.accountListView];
//    } else {
//        [[InfomationTool rootViewController].view addSubview:(UIView *)controller.backgroundView.accountListView];
//    }
    [controller.loginControllerBackGroundView addSubview:(UIView *)controller.backgroundView.accountListView];
}

#pragma mark - delegate login
#warning login 
- (void)loginWithUserName:(BOOL)isUserName Account:(NSString *)account Password:(NSString *)password WithController:(m185_LoginBackGroundView *)viewController {
//    syLog(@"name == %@   password == %@",account,password);
    SDK_START_ANIMATION;
    if (isUserName) {
        SDK_Log(@"开始用户名登录");
        [UserModel userLoginWithUserName:account PassWord:password completion:^(NSDictionary *content, BOOL success) {
            SDK_STOP_ANIMATION;
            [UserModel saveAccount:account Password:password PhoneNumber:nil];
            LOGINSUCCESS;
            SDK_Log(@"结束登录");
        }];
    } else {
        SDK_Log(@"开始手机登录");

        [UserModel newPhoneNumberLoginWith:account PassWord:password completion:^(NSDictionary *content, BOOL success) {
            SDK_STOP_ANIMATION;

            syLog(@"login === %@",content);
            if (success) {
                NSArray *listArray = content[@"data"][@"list"];
                [UserModel saveAccount:nil Password:password PhoneNumber:account];

                if (listArray && listArray.count > 0) {
                    /** 选择列表账号 */
#warning account list
                    syLog(@"选择账号");
                    self.backgroundView.showArray = listArray;
                    [self.backgroundView setPhoneNumber:account];
                    [self.backgroundView setToken:content[@"data"][@"token"]];
                    [self showAccountListView];
                    
                } else {
                    /** 普通账号返回 */
                    SDKLOG(@"log in success");\
                    if (self.delegate && [self.delegate respondsToSelector:@selector(loginController:loginSuccess:withStatus:)]) {\
                        [self.delegate loginController:self loginSuccess:YES withStatus:@{@"status":@"1",@"username":SDK_CONTENT_DATA[@"username"],@"token":SDK_CONTENT_DATA[@"token"]}];\
                    }\
                    [[UserModel currentUser] setAllPropertyWithDict:SDK_CONTENT_DATA];\
                    [viewController setUsername:account];\
                    [viewController setPassWord:password];\
                    [LoginController showBingPhoneView];\
                    [viewController hideOtherView];\
                }
            } else {
                [InfomationTool showAlertMessage:content[@"msg"] dismissTime:1 dismiss:nil];
            }

        }];
    }
}

- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToLoginSuccess:(NSDictionary *)content {
    SDKLOG(@"log in success");
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginController:loginSuccess:withStatus:)]) {
        [self.delegate loginController:self loginSuccess:YES withStatus:@{@"status":@"1",@"username":SDK_CONTENT_DATA[@"username"],@"token":SDK_CONTENT_DATA[@"token"]}];\
    }
    [[UserModel currentUser] setAllPropertyWithDict:SDK_CONTENT_DATA];
    [((UIView *)self.backgroundView.accountListView) removeFromSuperview];
    [LoginController showBingPhoneView];
    [viewController hideOtherView];
}

- (void)m185_LoginBackGroundView:(m185_LoginBackGroundView *)viewController RespondsToLoginWituUserName:(NSString *)username PassWord:(NSString *)password {

    if (![self isLegalUserName:username]) {
        return;
    }

    if (![self isLegalPassword:password]) {
        return;
    }

    [self loginWithUserName:YES Account:username Password:password WithController:viewController];
}

- (void)m185_LoginBackGroundView:(m185_LoginBackGroundView *)viewController RespondsToLoginWitPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password {

    if (![self isLegalPhoneNumber:phoneNumber]) {
        return;
    }

    if (![self isLegalPassword:password]) {
        return;
    }

    [self loginWithUserName:NO Account:phoneNumber Password:password WithController:viewController];
}

#pragma mark - delegate one uo register
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToOneUpResgister:(NSString *)test {

#warning 是否继续申请一键注册.
    if ([SDKModel sharedModel].oneUpRegisterAccount && [SDKModel sharedModel].oneUpregisterPassword) {

        [viewController showOneUpRegisterViewWithUserName:[SDKModel sharedModel].oneUpRegisterAccount Password:[SDKModel sharedModel].oneUpregisterPassword];
    } else {

        SDK_START_ANIMATION;
        [UserModel oneUpRegisterWithcompletion:^(NSDictionary *content, BOOL success) {

            SDK_STOP_ANIMATION;
            if (success) {
                SDK_Log(@"显示一键注册");
                [viewController showOneUpRegisterViewWithUserName:SDK_CONTENT_DATA[@"username"] Password:[UserModel oneUpRegistPassword]];

                [SDKModel sharedModel].oneUpRegisterAccount = [NSString stringWithFormat:@"%@",(SDK_CONTENT_DATA[@"username"])];
                [SDKModel sharedModel].oneUpregisterPassword = [NSString stringWithFormat:@"%@",[UserModel oneUpRegistPassword]];

            } else {
                [InfomationTool showAlertMessage:[NSString stringWithFormat:@"%@",content[@"msg"]] dismissTime:0.7 dismiss:nil];
            }

        }];
    }
}

- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController closeAccountListView:(id)info {

    [(UIView *)(self.backgroundView.accountListView) removeFromSuperview];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:controller action:@selector(loginViewResignFirstResponds)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;

//    if (controller.useWindow) {
//        [controller.loginControllerBackGroundWindow makeKeyAndVisible];
//        [controller.windowRootViewController.view addSubview:controller.backgroundView];
//        [controller.windowRootViewController.view addGestureRecognizer:tap];
//    } else {
//        [[InfomationTool rootViewController].view addSubview:controller.loginControllerBackGroundView];
//        [controller.loginControllerBackGroundView addSubview:controller.backgroundView];
//        [controller.loginControllerBackGroundView addGestureRecognizer:tap];
//    }

    [controller.loginControllerBackGroundView addSubview:self.backgroundView];
}

#pragma mark - delegate to register
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToRegisterUserName:(NSString *)username Password:(NSString *)password {
    SDK_Log(@"开始注册");
    SDK_START_ANIMATION;
    [UserModel userRegisterWithUserName:username PassWord:password completion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;
        if (success) {
            [self loginWithUserName:YES Account:username Password:password WithController:viewController];
        } else {
            [InfomationTool showAlertMessage:[NSString stringWithFormat:@"%@",content[@"msg"]] dismissTime:0.7 dismiss:nil];
        }
        SDK_Log(@"结束注册");
    }];
}

- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToRegisterPhoneNumber:(NSString *)phoneNumber Password:(NSString *)passowrd Code:(NSString *)code {
    SDK_START_ANIMATION;
    [UserModel phoneRegisterWithPhoneNumber:phoneNumber PassWord:passowrd Code:code completion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;
        if (success) {
            SDK_START_ANIMATION;
            [self loginWithUserName:NO Account:phoneNumber Password:passowrd WithController:viewController];
        } else {
            [InfomationTool showAlertMessage:[NSString stringWithFormat:@"%@",content[@"msg"]] dismissTime:0.7 dismiss:nil];
        }
    }];
}

#pragma mark - delegate auto login
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToAutoLoginWithAccount:(NSString *)account Password:(NSString *)password {

    NSDictionary *dict = [UserModel getAccountAndPassword];
    account = dict[@"account"];
    password = dict[@"password"];
    NSString * phoneNumber = dict[@"phoneNumber"];
    if (account && password) {
        [self loginWithUserName:YES Account:account Password:password WithController:viewController];
    } else if (password && phoneNumber) {
        [self loginWithUserName:NO Account:phoneNumber Password:password WithController:viewController];
    } else {
        [viewController removeAutoLoginView];
    }
}

#pragma mark - check is legal
- (BOOL)isLegalUserName:(NSString *)username {
    if (username.length < 1) {
        [InfomationTool showAlertMessage:@"账号长度不正确" dismissTime:0.7 dismiss:nil];
        return NO;
    }
    return YES;
}

- (BOOL)isLegalPassword:(NSString *)password {
    if (password.length < 1) {
        [InfomationTool showAlertMessage:@"密码长度不正确" dismissTime:0.7 dismiss:nil];
        return NO;
    }
    return YES;
}

- (BOOL)isLegalPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber.length < 11) {
        [InfomationTool showAlertMessage:@"手机号长度不正确" dismissTime:0.7 dismiss:nil];
        return NO;
    }
    //手机号有误
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (![regextestmobile evaluateWithObject:phoneNumber]) {
        [InfomationTool showAlertMessage:@"输入的手机号码有误" dismissTime:0.7 dismiss:nil];
        return NO;
    }
    return YES;
}

+ (BOOL)isInit {
    if (controller) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - getter
- (UIWindow *)loginControllerBackGroundWindow {
    if (!_loginControllerBackGroundWindow) {
        _loginControllerBackGroundWindow = [[UIWindow alloc] init];
        _loginControllerBackGroundWindow.rootViewController = self.windowRootViewController;
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

- (UIView *)loginControllerBackGroundView {
    if (!self.view) {
        self.view = [[UIView alloc] init];
        self.view .backgroundColor = BACKGROUNDCOLOR;
    } else {
        self.view .backgroundColor = BACKGROUNDCOLOR;
    }
    return self.view;
}

- (m185_LoginBackGroundView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[m185_LoginBackGroundView alloc] init];
        _backgroundView.delegate = self;
    }
    return _backgroundView;
}






@end











