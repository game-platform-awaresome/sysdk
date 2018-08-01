//
//  FeedbackNavigationController.m
//  SY_185SDK
//
//  Created by 燚 on 2017/12/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FeedbackNavigationController.h"

@interface FeedbackNavigationController ()

@end

@implementation FeedbackNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setTintColor:[UIColor blackColor]];
}

//#pragma mark - 控制屏幕旋转方法
//是否自动旋转,返回YES可以自动旋转,返回NO禁止旋转
- (BOOL)shouldAutorotate {
    return NO;
}

//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//由模态推出的视图控制器 优先支持的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
//
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}


@end
