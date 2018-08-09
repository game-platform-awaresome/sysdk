//
//  SY_BoxADImageView.h
//  SY_185SDK
//
//  Created by 燚 on 2018/8/9.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SY_BoxADImageView;

@protocol SY_BoxADImageViewDelegate <NSObject>


- (void)SY_BoxADImageView:(SY_BoxADImageView *)view CloseBoxADImage:(id)info;

@optional
- (void)SY_BoxADImageView:(SY_BoxADImageView *)view clickImage:(id)info;

@end


@interface SY_BoxADImageView : UIView

@property (nonatomic, weak) id<SY_BoxADImageViewDelegate> delegate;


@end





