//
//  SYStatisticsModel.h
//  SY_185SDK
//
//  Created by 燚 on 2018/5/31.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 初始化统计 */
void initStatisticsModel(void);
/** 登录统计 */
void loginStatistics(NSString *account);
/** 注册统计 */
void registStatistics(NSString *account);



@interface SYStatisticsModel : NSObject

@property (nonatomic, strong) NSArray *static_type;

+ (SYStatisticsModel *)sharedModel;

@end



