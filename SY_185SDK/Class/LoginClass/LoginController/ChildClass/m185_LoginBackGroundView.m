//
//  m185_LoginBackGroundView.m
//  SY_185SDK
//
//  Created by 燚 on 2017/9/29.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "m185_LoginBackGroundView.h"
#import <Photos/Photos.h>

#import "FBShimmeringView.h"
#import "SY_LoginView.h"
#import "SY_RegistView.h"
#import "SY_OneUpRegisteView.h"
#import "SY_ForgetPasswordView.h"
#import "SY_AutoLoginView.h"
#import "SY_BindingPhoneView.h"
#import "SY_BindingIDCardView.h"
#import "SY_adPicImageView.h"
#import "SY_AccountListView.h"

#import "SDKModel.h"

#define LOGIN_BACK_WIDTH FLOAT_MENU_WIDTH
#define LOGIN_BACK_HEIGHT LOGIN_BACK_WIDTH * 0.8

@interface m185_LoginBackGroundView ()<SYLoginViewDelegate,SYRegistViewDelegate,SYOneUpRegistDelegate,SYForgetPaswordDelegate,SYAutoLoginDelegate,BindingPhoneViewDelegate,AdPicImageViewDelegate,SY_AccountListViewDelegate>

/** 登录页面 */
@property (nonatomic, strong) SY_LoginView *loginView;
/** 注册页面 */
@property (nonatomic, strong) SY_RegistView *registView;
/** 一键注册 */
@property (nonatomic, strong) SY_OneUpRegisteView *oneUpRegistView;
/** 忘记密码 */
@property (nonatomic, strong) SY_ForgetPasswordView *forgetPasswordView;
/** 自动登录视图 */
@property (nonatomic, strong) SY_AutoLoginView *autoLoginView;



/** 立即注册 */
@property (nonatomic, strong) UIButton *goRegister;
/** 一键注册 */
@property (nonatomic, strong) UIButton *oneUpRegister;
/** 左边线 */
@property (nonatomic, strong) UIImageView *lineLeft;
/** 右边线 */
@property (nonatomic, strong) UIImageView *lineRight;
/** 下边线 */
@property (nonatomic, strong) UIImageView *lineDown;
/** 中间图标 */
@property (nonatomic, strong) UIImageView *lineImage;


/** 显示哪个页面(登录还是注册) */
@property (nonatomic, assign) BOOL isShowLoginBack;
/** 登录页面还是注册页面 */
@property (nonatomic, assign) BOOL isGoLogin;


@end


@implementation m185_LoginBackGroundView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

#pragma mark - init user interface
- (void)initUserInterface {
    self.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH, LOGIN_BACK_HEIGHT);
    self.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);

    self.backgroundColor = LOGIN_BACKGROUNDCOLOR;

    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;

    [self addSubview:self.loginView];
    //Whether to display the registration button
    if ([SDKModel sharedModel].register_enabled.boolValue) {
        [self addSubview:self.oneUpRegister];
        [self addSubview:self.goRegister];
    }

    [self addSubview:self.lineLeft];
    [self addSubview:self.lineRight];
    [self addSubview:self.lineDown];
    [self addSubview:self.lineImage];
}

#pragma mark - responds to one up register
/** Click one button to register */
- (void)clickOneupRegister {
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185_loginBackGroundView:respondsToOneUpResgister:)]) {
        [self.delegate m185_loginBackGroundView:self respondsToOneUpResgister:nil];
    }
}


#pragma mark - animation show login view or register view
/** 跳转登录和注册页面 */
- (void)loginOrRegister:(UIButton *)sender {
    if (!_isGoLogin) {
        [self animationShowRegisterView];
    } else {
        [self animationShowLoginView];
    }
    [self animationBringSubViewTofront];
}

/** 显示登录页面 */
- (void)animationShowLoginView {

    self.userInteractionEnabled = NO;
    _isShowLoginBack = YES;

    self.loginView.frame = CGRectMake(LOGIN_BACK_WIDTH, 0, LOGIN_BACK_WIDTH, LOGIN_BACK_HEIGHT);
    self.registView.frame = CGRectMake(0, 0, LOGIN_BACK_WIDTH, LOGIN_BACK_HEIGHT);

    [self addSubview:self.loginView];

    [UIView animateWithDuration:0.3 animations:^{

        self.registView.frame = CGRectMake(-LOGIN_BACK_WIDTH, 0, LOGIN_BACK_WIDTH, LOGIN_BACK_HEIGHT);
        self.loginView.frame = CGRectMake(0, 0, LOGIN_BACK_WIDTH, LOGIN_BACK_HEIGHT);
        [self.goRegister setTitle:@"立即注册" forState:(UIControlStateNormal)];

    } completion:^(BOOL finished) {

        self.userInteractionEnabled = YES;
        [self.registView removeFromSuperview];
        _isGoLogin = NO;

    }];
}

/** 显示注册页面 */
- (void)animationShowRegisterView {

    self.userInteractionEnabled = NO;
    _isShowLoginBack = NO;
    [self addSubview:self.registView];

    self.registView.frame = CGRectMake(-LOGIN_BACK_WIDTH, 0, LOGIN_BACK_WIDTH, LOGIN_BACK_HEIGHT);
    self.loginView.frame = CGRectMake(0, 0, LOGIN_BACK_WIDTH, LOGIN_BACK_HEIGHT);

    [UIView animateWithDuration:0.3 animations:^{

        self.loginView.frame = CGRectMake(LOGIN_BACK_WIDTH, 0, LOGIN_BACK_WIDTH, LOGIN_BACK_HEIGHT);
        self.registView.frame = CGRectMake(0, 0, LOGIN_BACK_WIDTH, LOGIN_BACK_HEIGHT);

        [self.goRegister setTitle:@"返回登录" forState:(UIControlStateNormal)];

    } completion:^(BOOL finished) {

        self.userInteractionEnabled = YES;
        [self.loginView removeFromSuperview];
        _isGoLogin = YES;

    }];
}

- (void)animationBringSubViewTofront {
    [self bringSubviewToFront:self.oneUpRegister];
    [self bringSubviewToFront:self.goRegister];
    [self bringSubviewToFront:self.lineImage];
    [self bringSubviewToFront:self.lineLeft];
    [self bringSubviewToFront:self.lineRight];
    [self bringSubviewToFront:self.lineDown];
}

- (void)inputResignFirstResponds {
    if (_isGoLogin) {
        [self.registView inputResignFirstResponder];
    } else {
        [self.loginView inputResignFirstResponder];
    }
}

/** 显示手机登录 */ 
- (void)showPhoneLogin:(BOOL)showPhone {
    [self.loginView showPhoneLogin:showPhone];
}

#pragma mark - show one up register view
- (void)showOneUpRegisterViewWithUserName:(NSString *)username Password:(NSString *)password {
    [self addSubview:self.oneUpRegistView];
    self.oneUpRegistView.OURCurrentAccount = username;
    self.oneUpRegistView.OURCurrentPassword = password;
}

#pragma mark - delegate to login
- (void)SYloginViewLoginWithUsername:(NSString *)username Password:(NSString *)password {
    SDKLOG(@"user name log in");
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185_LoginBackGroundView:RespondsToLoginWituUserName:PassWord:)]) {
        [self.delegate m185_LoginBackGroundView:self RespondsToLoginWituUserName:username PassWord:password];
    }
}

- (void)SYloginViewLoginWithPhoneNunber:(NSString *)phoneNumber Passsword:(NSString *)password {
    SDKLOG(@"phone number log in");
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185_LoginBackGroundView:RespondsToLoginWitPhoneNumber:Password:)]) {
        [self.delegate m185_LoginBackGroundView:self RespondsToLoginWitPhoneNumber:phoneNumber Password:password];
    }
}

#pragma mark - delegate to one up register login
- (void)SYOneUpRegistViewLoginWithAccount:(NSString *)account Password:(NSString *)password {
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185_LoginBackGroundView:RespondsToLoginWituUserName:PassWord:)]) {
        [self.delegate m185_LoginBackGroundView:self RespondsToLoginWituUserName:account PassWord:password];
    }
}

- (void)SYOneUPRegistViewShowRegistView {

    [self animationShowRegisterView];

    [self animationBringSubViewTofront];
}

#pragma mark - bindingPhoneView delegate
- (void)bindingPhoneViewClosed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185_loginBackGroundView:respondsToCloseBindingPhoneView:)]) {
        [self.delegate m185_loginBackGroundView:self respondsToCloseBindingPhoneView:nil];
    }
}

#pragma mark - ad pic view delegate
- (void)AdPicImageViewViewDelegateClosed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185_loginBackGroundView:respondsToCloseADPicView:)]) {
        [self.delegate m185_loginBackGroundView:self respondsToCloseADPicView:nil];
    }
}

#pragma mark - account list delegate
- (void)SY_AccountListView:(SY_AccountListView *)view clickCloseButton:(id)obj {
    syLog(@"关闭账号列表");
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185_loginBackGroundView:closeAccountListView:)]) {
        [self.delegate m185_loginBackGroundView:self closeAccountListView:nil];
    }
}

- (void)SY_AccountListView:(SY_AccountListView *)view Login:(NSDictionary *)dict {
    syLog(@"登录游戏成功 === %@",dict);
    [RequestTool saveUid:[NSString stringWithFormat:@"%@",dict[@"id"]]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185_loginBackGroundView:respondsToLoginSuccess:)]) {
        [self.delegate m185_loginBackGroundView:self respondsToLoginSuccess:dict];
    }
}

#pragma mark - 一键注册截屏
- (void)SYOneUpRegistViewScreenShots {
    SDKLOG(@"截屏保存delegate");
    //获取相册访问权限
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if (authorStatus == PHAuthorizationStatusDenied) {
        SDKLOG(@"保存到相册失败");
        SDK_MESSAGE(@"请在设置中打开访问相册权限.");
    } else {
        UIView *view = self.oneUpRegistView;

        CGSize size = view.bounds.size;
        //    开启上下文
        //    UIGraphicsBeginImageContext(size);//图片质量低
        //    使用参数之后,截出来的是原图（YES,0.0）质量高
        UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
        //    根据参照视图的大小设置要裁剪的矩形范围
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        //    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        //iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
        [view drawViewHierarchyInRect:rect  afterScreenUpdates:NO];
        // 从上下文中,取出UIImage
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        // 结束上下文
        UIGraphicsEndImageContext();

        SDK_START_ANIMATION;
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(didFinishSavingImage:saveError:contextInfo:), NULL);
    }
}

- (void)didFinishSavingImage:(UIImage *)image saveError:(NSError *)error contextInfo:(id)contextInfo {
    SDK_STOP_ANIMATION;
    if(error != NULL){
        SDK_MESSAGE(@"保存截图失败");
    }else{
        SDK_MESSAGE(@"保存截图成功");
    }
}


#pragma mark - delegate to forget password
- (void)SYloginViewClickForgetPasswordButton {
    SDKLOG(@"忘记密码delegate");
    [self addSubview:self.forgetPasswordView];
}

#pragma mark - auto login delegate
- (void)SYAutoLoginViewAutoLogin {
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185_loginBackGroundView:respondsToAutoLoginWithAccount:Password:)]) {
        [self.delegate m185_loginBackGroundView:self respondsToAutoLoginWithAccount:nil Password:nil];
    }
}

- (void)hideOtherView {
    [self.oneUpRegistView removeFromSuperview];
}

#pragma mark - delegate to register
- (void)SYregistViewRegistWithUsername:(NSString *)username Password:(NSString *)password {
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185_loginBackGroundView:respondsToRegisterUserName:Password:)]) {
        [self.delegate m185_loginBackGroundView:self respondsToRegisterUserName:username Password:password];
    }
}

- (void)SYregistViewRegistWithPhoneNunber:(NSString *)phoneNumber Passsword:(NSString *)password Code:(NSString *)code {
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185_loginBackGroundView:respondsToRegisterPhoneNumber:Password:Code:)]) {
        [self.delegate m185_loginBackGroundView:self respondsToRegisterPhoneNumber:phoneNumber Password:password Code:code];
    }
}

#pragma mark - auto loginView
- (void)addAutoLoginView {
    self.autoLoginView.accountLabel.text = self.loginView.account.text;
    [self addSubview:self.autoLoginView];
}

- (void)removeAutoLoginView {
    [self.autoLoginView removeFromSuperview];
    self.autoLoginView = nil;
}


#pragma mark - setter
- (void)setUsername:(NSString *)username {
    self.loginView.account.text = username;
}

- (void)setPassWord:(NSString *)passWord {
    self.loginView.password.text = passWord;
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    [self showPhoneLogin:YES];

    self.loginView.account.text = phoneNumber;
    self.accountListView.phoneNumber = phoneNumber;
    
}

- (void)setShowArray:(NSArray *)showArray {
    self.accountListView.showArray = showArray;
}

- (void)setToken:(NSString *)token {
    self.accountListView.token = token;
}

#pragma mark - getter
/** 登录页面 */
- (SY_LoginView *)loginView {
    if (!_loginView) {
        _loginView = [[SY_LoginView alloc] init];
        _loginView.loginDelegate = self;
    }
    return _loginView;
}

/** 注册页面 */
- (SY_RegistView *)registView {
    if (!_registView) {
        _registView = [[SY_RegistView alloc] init];
        _registView.registDelegate = self;
    }
    return _registView;
}

/** 一键注册页面 */
- (SY_OneUpRegisteView *)oneUpRegistView {
    if (!_oneUpRegistView) {
        _oneUpRegistView = [[SY_OneUpRegisteView alloc] init];
        _oneUpRegistView.oneUpDelegate = self;
    }
    return _oneUpRegistView;
}

- (SY_ForgetPasswordView *)forgetPasswordView {
    if (!_forgetPasswordView) {
        _forgetPasswordView = [[SY_ForgetPasswordView alloc] init];
        _forgetPasswordView.forgetPasswordDelegate = self;
    }
    return _forgetPasswordView;
}

- (SY_AutoLoginView *)autoLoginView {
    if (!_autoLoginView) {
        _autoLoginView = [[SY_AutoLoginView alloc] init];
        _autoLoginView.autoLoginDelegate = self;
    }
    return _autoLoginView;
}

- (SY_BindingPhoneView *)bingdingPhoneView {
    if (!_bingdingPhoneView) {
        _bingdingPhoneView = [[SY_BindingPhoneView alloc] init];
        _bingdingPhoneView.delegate = self;
    }
    return _bingdingPhoneView;
}

- (SY_BindingIDCardView *)bindingIDCardView {
    if (!_bindingIDCardView) {
        _bindingIDCardView = [[SY_BindingIDCardView alloc] init];
    }
    return _bindingIDCardView;
}

- (SY_adPicImageView *)adPicImageView {
    if (!_adPicImageView) {
        _adPicImageView = [[SY_adPicImageView alloc] init];
        _adPicImageView.delegate = self;
    }
    return _adPicImageView;
}

- (SY_AccountListView *)accountListView {
    if (!_accountListView) {
        _accountListView = [[SY_AccountListView alloc] init];
        _accountListView.delegate = self;
    }
    return _accountListView;
}

/** 立即注册 */
- (UIButton *)goRegister {
    if (!_goRegister) {
        _goRegister = [UIButton buttonWithType:(UIButtonTypeCustom)];

        _goRegister.frame = CGRectMake(LOGIN_BACK_WIDTH * 0.05, LOGIN_BACK_HEIGHT * 0.85, FLOAT_MENU_WIDTH * 0.3, FLOAT_MENU_WIDTH * 0.07);
        [_goRegister setTitle:@"立即注册" forState:(UIControlStateNormal)];
        [_goRegister setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _goRegister.titleLabel.font = [UIFont systemFontOfSize:16];
        [_goRegister addTarget:self action:@selector(loginOrRegister:) forControlEvents:(UIControlEventTouchUpInside)];
        [_goRegister sizeToFit];

        _goRegister.center = CGPointMake(LOGIN_BACK_WIDTH - self.oneUpRegister.center.x, self.oneUpRegister.center.y);
    }
    return _goRegister;
}

/** 一键注册 */
- (UIButton *)oneUpRegister {
    if (!_oneUpRegister) {
        _oneUpRegister = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        _oneUpRegister.frame = CGRectMake(LOGIN_BACK_WIDTH * 0.65, LOGIN_BACK_HEIGHT * 0.85, FLOAT_MENU_WIDTH * 0.3, FLOAT_MENU_WIDTH * 0.07);
        _oneUpRegister.frame = CGRectMake(LOGIN_BACK_WIDTH / 2 + 13, CGRectGetMaxY(self.lineImage.frame) + 5, FLOAT_MENU_WIDTH * 0.3, FLOAT_MENU_WIDTH * 0.07);
        [_oneUpRegister setTitle:@"一键注册" forState:(UIControlStateNormal)];
        [_oneUpRegister setTitleColor:RGBCOLOR(201, 173, 173) forState:(UIControlStateNormal)];
        _oneUpRegister.titleLabel.font = [UIFont systemFontOfSize:16];
        [_oneUpRegister sizeToFit];
        [_oneUpRegister addTarget:self action:@selector(clickOneupRegister) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _oneUpRegister;
}

/** 图片中间 */
- (UIImageView *)lineImage {
    if (!_lineImage) {
        _lineImage = [[UIImageView alloc] initWithImage:SDK_IMAGE(@"SDK_Login_line_center")];
        _lineImage.bounds = CGRectMake(0, 0, 15, 15);
        _lineImage.center = CGPointMake(LOGIN_BACK_WIDTH / 2, LOGIN_BACK_HEIGHT * 0.8);
    }
    return _lineImage;
}

- (UIImageView *)lineLeft {
    if (!_lineLeft) {
        _lineLeft = [[UIImageView alloc] init];
//        _lineLeft.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH / 2 - 40, 2);
//        _lineLeft.center = CGPointMake(LOGIN_BACK_WIDTH / 4, LOGIN_BACK_HEIGHT * 0.8);
        _lineLeft.frame = CGRectMake(LOGIN_BACK_WIDTH * 0.05, CGRectGetMidY(self.lineImage.frame), LOGIN_BACK_WIDTH * 0.45 - 13, 2);
        _lineLeft.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        _lineLeft.layer.cornerRadius = 1;
        _lineLeft.layer.masksToBounds = YES;
    }
    return _lineLeft;
}

- (UIImageView *)lineRight {
    if (!_lineRight) {
        _lineRight = [[UIImageView alloc] init];
//        _lineRight.bounds = CGRectMake(0, 0, LOGIN_BACK_WIDTH / 2 - 30, 2);
//        _lineRight.center = CGPointMake(LOGIN_BACK_WIDTH / 4 * 3, LOGIN_BACK_HEIGHT * 0.8);
        _lineRight.frame = CGRectMake(LOGIN_BACK_WIDTH * 0.5 + 13, CGRectGetMidY(self.lineImage.frame), LOGIN_BACK_WIDTH * 0.45 - 13, 2);
        _lineRight.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        _lineRight.layer.cornerRadius = 1;
        _lineRight.layer.masksToBounds = YES;
    }
    return _lineRight;
}

- (UIImageView *)lineDown {
    if (!_lineDown) {
        _lineDown = [[UIImageView alloc] init];
        _lineDown.bounds = CGRectMake(0, 0, 2, LOGIN_BACK_HEIGHT * 0.07);
        _lineDown.center = CGPointMake(LOGIN_BACK_WIDTH / 2, self.oneUpRegister.center.y);
        _lineDown.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        _lineDown.layer.cornerRadius = 1;
        _lineDown.layer.masksToBounds = YES;
    }
    return _lineDown;
}




@end












