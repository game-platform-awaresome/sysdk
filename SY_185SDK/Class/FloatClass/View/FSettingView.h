//
//  FSettingView.h
//  SDK185SY
//
//  Created by 石燚 on 2017/7/5.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSettingView : UIView

/** 版本 */ 
@property (nonatomic, strong) NSString *version;

/** 设置开关 */
- (void)isAutoLogin;

/** 移除所有子视图 */
- (void)removeAllChildViews;

- (instancetype)init;


@end
