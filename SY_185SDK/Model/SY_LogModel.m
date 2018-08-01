//
//  SY_LogModel.m
//  SY_185SDK
//
//  Created by 燚 on 2018/3/22.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "SY_LogModel.h"
#import "SDKModel.h"

@implementation SY_LogModel

+ (void)showMessage:(NSString *)string {
    if ([SDKModel sharedModel].showMessage == NO) {
        return;
    }
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"YYYY-MM-dd hh:mm:ss SSS";
    NSString *timeString = [formatter stringFromDate:[NSDate date]];
    NSString *message = [NSString stringWithFormat:@"SY_185_SDK|%@|: %@",timeString,string];
    const char *messageChar = [message UTF8String];
    printf("%s \n",messageChar);
}


@end
