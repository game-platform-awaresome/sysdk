//
//  SY_BindingPhoneView.h
//  BTWan
//
//  Created by 石燚 on 2017/7/24.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BindingPhoneViewDelegate <NSObject>

- (void)bindingPhoneViewClosed;

@end

@interface SY_BindingPhoneView : UIView

@property (nonatomic, weak) id<BindingPhoneViewDelegate> delegate;

@end

