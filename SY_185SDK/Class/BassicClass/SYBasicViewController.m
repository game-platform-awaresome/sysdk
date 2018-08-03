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
    [self.hud showAnimated:YES];
}

- (void)stopAnimation {
    [self.hud hideAnimated:YES];
}

- (void)stopAnimationAfter:(NSUInteger)time {
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


@end









