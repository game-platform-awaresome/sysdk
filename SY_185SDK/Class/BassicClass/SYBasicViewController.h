//
//  SYBasicViewController.h
//  SY_185SDK
//
//  Created by 燚 on 2018/8/2.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"


@interface SYBasicViewController : UIViewController





- (void)initDataSource;
- (void)initUserInterface;


- (void)startAnimation;
- (void)stopAnimation;
- (void)stopAnimationAfter:(NSUInteger)time;


@end





