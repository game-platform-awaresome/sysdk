//
//  SYBasicViewController.m
//  SY_185SDK
//
//  Created by 燚 on 2018/8/2.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import "SYBasicViewController.h"

#import "MBProgressHUD.h"



@interface SYBasicViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;



@end




@implementation SYBasicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)initDataSource {

}

- (void)initUserInterface {

}

- (void)startAnimation {
    self.hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.hud];
    [self.hud showAnimated:YES];
}

- (void)stopAnimation {
    self.hud.removeFromSuperViewOnHide = YES;
    [self.hud hideAnimated:YES];
}

- (void)stopAnimationAfter:(NSUInteger)time {
    self.hud.removeFromSuperViewOnHide = YES;
    [self.hud hideAnimated:YES afterDelay:time];
}

#pragma mark - getter
- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
        _hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
        _hud.bezelView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.9];
    }
    return _hud;
}

- (void)showAlertMessage:(NSString *)message dismissTime:(float)second dismiss:(void (^)(void))dismiss  {

//    UILabel *label = [[UILabel alloc] init];
//    label.text = message;
//    label.layer.cornerRadius = 4;
//    label.layer.masksToBounds = YES;
//    label.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
//    label.textAlignment = NSTextAlignmentCenter;
//
//    [[UIApplication sharedApplication].keyWindow addSubview:label];
//    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
//
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(CGPointZero);
//    }];




//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [label removeFromSuperview];
//    });


    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];

    //    [[InfomationTool rootViewController] presentViewController:alertController animated:YES completion:nil];

    [self presentViewController:alertController animated:YES completion:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:^{
            if (dismiss) {
                dismiss();
            }
        }];
    });


}


@end









