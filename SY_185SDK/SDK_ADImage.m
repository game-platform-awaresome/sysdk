//
//  SDK_ADImage.m
//  SY_185SDK
//
//  Created by 燚 on 2017/12/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SDK_ADImage.h"
#import "SDKModel.h"
#import <UIKit/UIKit.h>


#ifdef DEBUG

#define BACKGROUNDCOLOR ([SDKModel sharedModel].useWindow) ? RGBACOLOR(0, 0, 200, 150) : RGBACOLOR(200, 0, 0, 150)

#else

#define BACKGROUNDCOLOR RGBACOLOR(111, 111, 111, 111)

#endif



@interface SDK_ADImage ()

@property (nonatomic, strong) UIWindow *imageBackWindow;
@property (nonatomic, strong) UIViewController *imageBackViewController;



@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) NSString *status;

@end


static SDK_ADImage *controller = nil;
@implementation SDK_ADImage



+ (BOOL)showADImageWithDelegate:(id)delegate andStatus:(NSString *)status {

    if ([SDKModel sharedModel].isdisplay_ad.boolValue) {
        NSData *imageData = SDK_USERDEFAULTS_GET_OBJECT(@"ad_pic_imageData");
        if (imageData.length > 0) {
            controller = [[SDK_ADImage alloc] init];
            controller.delegate = delegate;
            controller.status = status;
            [controller showADimage];
        } else {
            syLog(@"不展示广告页");
            return NO;
        }
    } else {
        syLog(@"不展示广告页1");
        return NO;
    }

    return YES;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    [self.imageBackViewController.view addSubview:self.backView];
    NSData *imageData = SDK_USERDEFAULTS_GET_OBJECT(@"ad_pic_imageData");
    self.imageView.image = [UIImage imageWithData:imageData];
}

- (void)showADimage {
    syLog(@"显示广告页");
    if ([SDKModel sharedModel].useWindow) {
        [self.imageBackWindow makeKeyAndVisible];
        syLog(@"?????????????");
    } else {
        [[InfomationTool rootViewController].view addSubview:self.imageBackViewController.view];
    }
}


#pragma mark - method
- (void)respondsToCloseButton1 {
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185ADImage:respondsToCloseButton:)]) {
        [self hideADImage];
        [self.delegate m185ADImage:self respondsToCloseButton:self.status];
        controller = nil;
    }
}

- (void)respondsToImageView {
    if ([SDKModel sharedModel].ad_url.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[SDKModel sharedModel].ad_url]];
    }
}

- (void)hideADImage {

    if ([SDKModel sharedModel].useWindow) {
        [self.imageBackWindow resignKeyWindow];
        self.imageBackWindow = nil;
    } else {
        [self.imageBackViewController.view removeFromSuperview];
    }


    syLog(@"关闭广告业");

}


#pragma mark - getter
/** 背景视图 */
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT);
        _backView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
        _backView.backgroundColor = LOGIN_BACKGROUNDCOLOR;

        _backView.layer.cornerRadius = 8;
        _backView.layer.borderColor = [UIColor grayColor].CGColor;
        _backView.layer.borderWidth = 1.f;
        _backView.layer.masksToBounds = YES;

        [_backView addSubview:self.imageView];
        [_backView addSubview:self.closeButton];

    }
    return _backView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        if (FLOAT_MENU_WIDTH > 320) {
            _imageView.bounds = CGRectMake(0, 0, 320, 250);
        } else {
            _imageView.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_WIDTH / 32 * 25);
        }
        _imageView.center = CGPointMake(FLOAT_MENU_WIDTH / 2, _imageView.bounds.size.height / 2 + 10);

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToImageView)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;

        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _closeButton.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH * 0.6, 30);
        _closeButton.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT - 38);
        [_closeButton setTitle:@"朕知道了" forState:(UIControlStateNormal)];
        [_closeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _closeButton.layer.borderColor = [UIColor orangeColor].CGColor;
        _closeButton.layer.borderWidth = 1;
        _closeButton.layer.cornerRadius = 4;
        _closeButton.layer.masksToBounds = YES;
        [_closeButton addTarget:self action:@selector(respondsToCloseButton1) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

- (UIWindow *)imageBackWindow {
    if (!_imageBackWindow) {
        _imageBackWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _imageBackWindow.rootViewController = self.imageBackViewController;
        _imageBackWindow.backgroundColor = [UIColor clearColor];
        _imageBackWindow.windowLevel = UIWindowLevelNormal;
        _imageBackWindow.hidden = NO;
    }
    return _imageBackWindow;
}

- (UIViewController *)imageBackViewController {
    if (!_imageBackViewController) {
        _imageBackViewController = [[UIViewController alloc] init];
        _imageBackViewController.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        _imageBackViewController.view.backgroundColor = BACKGROUNDCOLOR;
    }
    return _imageBackViewController;
}




@end








