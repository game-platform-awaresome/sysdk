//
//  SY_RegistView.h
//  SDK185SY
//
//  Created by 石燚 on 2017/7/13.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYRegistViewDelegate <NSObject>

//用户名密码登录
- (void)SYregistViewRegistWithUsername:(NSString *)username Password:(NSString *)password;


//手机号,验证码,密码登录
- (void)SYregistViewRegistWithPhoneNunber:(NSString *)phoneNumber Passsword:(NSString *)password Code:(NSString *)code;


@end;

@interface SY_RegistView : UIView

@property (nonatomic, weak) id<SYRegistViewDelegate> registDelegate;

- (void)inputResignFirstResponder;

@end
