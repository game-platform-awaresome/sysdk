//
//  SYBasicViewController.h
//  SY_185SDK
//
//  Created by 燚 on 2018/8/2.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "UserModel.h"

@interface SYBasicViewController : UIViewController





- (void)initDataSource;
- (void)initUserInterface;


- (void)startAnimation;
- (void)stopAnimation;
- (void)stopAnimationAfter:(NSUInteger)time;


/** 显示提示框 */
- (void)showAlertMessage:(NSString *)message dismissTime:(float)second dismiss:(void(^)(void))dismiss;




@end





