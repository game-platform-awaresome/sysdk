//
//  SY_LoginView.h
//  SDK185SY
//
//  Created by 石燚 on 2017/7/12.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYLoginViewDelegate <NSObject>

/** 点击登录按钮 */
- (void)SYloginViewLoginWithUsername:(NSString *)username Password:(NSString *)password;
- (void)SYloginViewLoginWithPhoneNunber:(NSString *)phoneNumber Passsword:(NSString *)password;

/** 忘记密码 */
- (void)SYloginViewClickForgetPasswordButton;


@end


@interface SY_LoginView : UIView

/** 账号 */
@property (nonatomic, strong) UITextField *account;
/** 密码 */
@property (nonatomic, strong) UITextField *password;


@property (nonatomic, weak) id<SYLoginViewDelegate> loginDelegate;


- (void)inputResignFirstResponder;


- (void)showPhoneLogin:(BOOL)show;




@end
