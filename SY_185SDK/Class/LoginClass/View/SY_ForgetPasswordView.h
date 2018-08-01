//
//  SY_ForgetPasswordView.h
//  SDK185SY
//
//  Created by 石燚 on 2017/7/13.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYForgetPaswordDelegate <NSObject>

@end

@interface SY_ForgetPasswordView : UIView


@property (nonatomic, weak) id<SYForgetPaswordDelegate> forgetPasswordDelegate;


@end
