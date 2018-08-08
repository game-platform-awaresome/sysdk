//
//  FBDetailViewController.h
//  SY_185SDK
//
//  Created by 燚 on 2017/12/12.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYBasicViewController.h"

@interface FBDetailViewController : SYBasicViewController

@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, assign) BOOL canEdit;

+ (void)setDict:(NSDictionary *)dict;

+ (UINavigationController *)showDetail;

+ (void)setCaneEdit:(BOOL)canEdit;


@end
