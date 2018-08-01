//
//  SY_AutoLoginView.h
//  SDK185SY
//
//  Created by 石燚 on 2017/7/14.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYAutoLoginDelegate <NSObject>

- (void)SYAutoLoginViewAutoLogin;

@end

@interface SY_AutoLoginView : UIView

/** 账号 */
@property (nonatomic, strong) UILabel *accountLabel;

@property (nonatomic, weak) id<SYAutoLoginDelegate> autoLoginDelegate;

@end



