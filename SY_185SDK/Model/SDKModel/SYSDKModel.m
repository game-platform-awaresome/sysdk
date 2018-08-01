//
//  SYSDKModel.m
//  SY_185SDK
//
//  Created by 燚 on 2018/8/1.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import "SYSDKModel.h"

static SYSDKModel *_SDK_Model = nil;
@implementation SYSDKModel

+ (SYSDKModel *)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_SDK_Model) {
            _SDK_Model = [[SYSDKModel alloc] init];
        }
    });
    return _SDK_Model;
}







@end





