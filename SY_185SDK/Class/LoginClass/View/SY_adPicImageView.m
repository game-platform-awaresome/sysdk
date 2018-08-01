//
//  SY_adPicImageView.m
//  SY_185SDK
//
//  Created by 燚 on 2017/12/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SY_adPicImageView.h"
#import "SDKModel.h"

@interface SY_adPicImageView ()

@property (nonatomic, strong) UIView *backView;


@property (nonatomic, strong) UIImageView *imageView;


@property (nonatomic, strong) UIButton *closeButton;



@end



@implementation SY_adPicImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backView];


    NSData *imageData = SDK_USERDEFAULTS_GET_OBJECT(@"ad_pic_imageData");
    if (imageData.length > 0) {
        self.imageView.image = [UIImage imageWithData:imageData];
    } else {
        [self respondsToCloseButton];
    }
}


#pragma mark - method
- (void)respondsToCloseButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(AdPicImageViewViewDelegateClosed)]) {
        [self removeFromSuperview];
        [self.delegate AdPicImageViewViewDelegateClosed];
    }
}

- (void)respondsToImageView {
    if ([SDKModel sharedModel].ad_url.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[SDKModel sharedModel].ad_url]];
    }
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
        [_closeButton addTarget:self action:@selector(respondsToCloseButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}



@end
