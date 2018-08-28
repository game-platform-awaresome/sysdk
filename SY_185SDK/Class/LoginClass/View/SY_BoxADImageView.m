//
//  SY_BoxADImageView.m
//  SY_185SDK
//
//  Created by 燚 on 2018/8/9.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import "SY_BoxADImageView.h"
#import "SDKModel.h"
#import "UIImageView+WebCache.h"

@interface SY_BoxADImageView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *closeButton;


@end


@implementation SY_BoxADImageView


- (instancetype)init {
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
    if ([SDKModel sharedModel].box_pic_url.length > 0) {

//        dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
//        dispatch_async(globalQueue, ^{
//            syLog(@"开始下载图片:%@", [NSThread currentThread]);
//
//            NSString *imageStr = [NSString stringWithFormat:@"%@",[SDKModel sharedModel].box_pic_url];
//            NSURL *imageURL = [NSURL URLWithString:imageStr];
//            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                syLog(@"图片下载完成");
//                [self.imageView setImage:[UIImage imageWithData:imageData]];
//            });
//        });

//        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[SDKModel sharedModel].box_pic_url]] options:(0) progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.imageView setImage:image];
//            });
//        }];

        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[SDKModel sharedModel].box_pic_url]]];

    } else {
        [self respondsToCloseButton];
    }
}



#pragma mark - method
- (void)respondsToCloseButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SY_BoxADImageView:CloseBoxADImage:)]) {
        [self removeFromSuperview];
        [self.delegate SY_BoxADImageView:self CloseBoxADImage:nil];
    }
}

- (void)respondsToImageView {
    if ([SDKModel sharedModel].box_url.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[SDKModel sharedModel].box_url]];
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
//        if (FLOAT_MENU_WIDTH > 320) {
//            _imageView.bounds = CGRectMake(0, 0, 320, 250);
//        } else {
//            _imageView.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_WIDTH / 32 * 25);
//        }
//        _imageView.center = CGPointMake(FLOAT_MENU_WIDTH / 2, _imageView.bounds.size.height / 2 + 10);

        _imageView.frame = self.backView.bounds;
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
        _closeButton.frame = CGRectMake(FLOAT_MENU_WIDTH - 40, 10, 30, 30);
        [_closeButton setImage:SDK_IMAGE(@"SYSDK_closeButton") forState:(UIControlStateNormal)];
        [_closeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_closeButton addTarget:self action:@selector(respondsToCloseButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}





@end
