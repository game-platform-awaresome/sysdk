//
//  GM_PropsNumView.h
//  SY_GMSDK
//
//  Created by 燚 on 2017/10/18.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GM_PropsNumView;

@protocol GMPropsNumViewDelegate <NSObject>

- (void)GMPropsNumView:(GM_PropsNumView *)view completeInputWithString:(NSString *)num;

@end

@interface GM_PropsNumView : UIView

@property (nonatomic, weak) id<GMPropsNumViewDelegate> delegate;


- (void)clearNumber;


@end
