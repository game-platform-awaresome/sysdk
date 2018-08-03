//
//  SYLoginViewController.m
//  SY_185SDK
//
//  Created by 燚 on 2018/8/2.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import "SYLoginViewController.h"

#import "m185_LoginBackGroundView.h"

#import "UserModel.h"
#import "SDKModel.h"

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


#define BackgroundView (sy_loginController.view)

@interface SYLoginViewController ()
<m185_LoginBackGroundViewDeleagte>

/** 背景视图 */
@property (nonatomic, strong) m185_LoginBackGroundView *backgroundView;


@end



static SYLoginViewController *sy_loginController = nil;
@implementation SYLoginViewController


+ (SYLoginViewController *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sy_loginController) {
            sy_loginController = [[SYLoginViewController alloc] init];
        }
    });
    return sy_loginController;
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
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:LoginViewController action:@selector(loginViewResignFirstResponds)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}


#pragma mark - method
/** 自动登录 */
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
}

/** 显示登录页面 */ 
+ (void)showLoginView {
    if ([UserModel currentUser].uid) {
        [InfomationTool showAlertMessage:@"已登录账号" dismissTime:0.7 dismiss:nil];
        return;
    }
    [self showView];
    LoginViewController.isShow = YES;
    [LoginViewController layoutViews];
}

+ (void)showView {
    if ([UIApplication sharedApplication].keyWindow) {
        if ([UIApplication sharedApplication].keyWindow.windowLevel == UIWindowLevelNormal) {
            [LoginViewController addViewToWindow:[UIApplication sharedApplication].keyWindow];
        } else {
            for (UIWindow *window in [UIApplication sharedApplication].windows) {
                if (window.windowLevel == UIWindowLevelNormal) {
                    [LoginViewController addViewToWindow:window];
                    break;
                }
            }
        }
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showView];
        });
    }
}

- (void)addViewToWindow:(UIWindow *)window {
    [[UIApplication sharedApplication].keyWindow addSubview:BackgroundView];
    [BackgroundView addSubview:LoginViewController.backgroundView];
}


+ (void)hideLoginView {

}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - layout views
- (void)layoutViews {
    [sy_loginController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([UIApplication sharedApplication].keyWindow);
    }];

    [sy_loginController.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(LOGIN_BACK_WIDTH, LOGIN_BACK_HEIGHT));
        make.center.mas_equalTo(CGPointZero);
    }];
}

#pragma mark - responds
- (void)loginViewResignFirstResponds {
    [self.backgroundView inputResignFirstResponds];
}

#pragma mark - m185_LoginBackGroundView delegate
/** 登录按钮的响应 */
- (void)m185_LoginBackGroundView:(m185_LoginBackGroundView *)viewController RespondsToLoginWituUserName:(NSString *)username PassWord:(NSString *)password {

}

/** 手机登录 */
- (void)m185_LoginBackGroundView:(m185_LoginBackGroundView *)viewController RespondsToLoginWitPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password {

}

/** 一键注册按钮的响应 */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToOneUpResgister:(NSString *)test {

}

/** 用户名注册 */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController
      respondsToRegisterUserName:(NSString *)username Password:(NSString *)password {

}

/** 手机号码注册 */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController
   respondsToRegisterPhoneNumber:(NSString *)phoneNumber Password:(NSString *)passowrd Code:(NSString *)code {

}

/** 自动登录 */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController
  respondsToAutoLoginWithAccount:(NSString *)account Password:(NSString *)password {

}

/** 手机绑定页面关闭 */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController
 respondsToCloseBindingPhoneView:(id)info {

}

/** 关闭广告页面 */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController
        respondsToCloseADPicView:(id)info {

}

/** 关闭账号列表 */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController closeAccountListView:(id)info {

}

/** 登录 子账号  */
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToLoginSuccess:(NSDictionary *)content {

}

#pragma mark - getter
- (m185_LoginBackGroundView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[m185_LoginBackGroundView alloc] init];
        _backgroundView.delegate = self;
    }
    return _backgroundView;
}











@end













