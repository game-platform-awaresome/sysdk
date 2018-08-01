//
//  FBSubmitViewController.h
//  SY_185SDK
//
//  Created by 燚 on 2017/12/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBSubmitViewController : UIViewController


@property (nonatomic, strong) NSString *limitNumber;

@property (nonatomic, strong) NSArray *slectType;

+ (UINavigationController *)showSubmit;

+ (void)setLimitNumber:(NSString *)limitNumber;

+ (void)setSelectType:(NSArray *)selectType;


@end
