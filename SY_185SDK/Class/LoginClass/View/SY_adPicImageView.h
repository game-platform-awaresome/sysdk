//
//  SY_adPicImageView.h
//  SY_185SDK
//
//  Created by 燚 on 2017/12/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdPicImageViewDelegate <NSObject>

- (void)AdPicImageViewViewDelegateClosed;

@end

@interface SY_adPicImageView : UIView


@property (nonatomic, weak) id<AdPicImageViewDelegate> delegate;


@end
