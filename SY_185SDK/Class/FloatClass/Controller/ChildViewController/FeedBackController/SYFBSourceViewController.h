//
//  SYFBSourceViewController.h
//  SY_185SDK
//
//  Created by 燚 on 2018/8/6.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYBasicViewController.h"

typedef void(^SourceSuccessBlock)(void);

@interface SYFBSourceViewController : SYBasicViewController

@property (nonatomic, strong) NSString *questionID;
@property (nonatomic, strong) SourceSuccessBlock block;


+ (SYFBSourceViewController *)showSourceCongrollerWith:(NSString *)questionID CallBackBlock:(SourceSuccessBlock)block;



@end
