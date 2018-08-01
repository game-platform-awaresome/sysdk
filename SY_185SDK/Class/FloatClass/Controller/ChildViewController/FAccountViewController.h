//
//  FAccountViewController.h
//  SDK185SY
//
//  Created by 石燚 on 2017/6/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FAccountViewController;

@protocol FAccountVeiwDelegate <NSObject>

/** 设置按钮 */
- (void)FAccountViewController:(FAccountViewController *)accountVeiwController clickSettingButton:(UIButton *)button;

/** 充值记录 */
- (void)FAccountViewController:(FAccountViewController *)accountVeiwController clickRechargeButton:(UIButton *)button;

/** 公告 */
- (void)FAccountViewController:(FAccountViewController *)accountVeiwController  clickAnnouncementButton:(UIButton *)button;

/** 问题反馈 */
- (void)FAccountViewController:(FAccountViewController *)accountVeiwController clickFeedBackButton:(UIButton *)button;

@end


@interface FAccountViewController : UIViewController



@property (nonatomic, weak) id<FAccountVeiwDelegate> delegate;

/** 设置按钮的位置 */
@property (nonatomic, assign, readonly) CGRect settingButtonFrame;

- (void)settingViews;


@end



