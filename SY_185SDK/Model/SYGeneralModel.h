//
//  SYGeneralModel.h
//  SY_185SDK
//
//  Created by 燚 on 2018/8/1.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYRequestTool.h"

@interface SYGeneralModel : NSObject

/** 获取所有类的属性 */
+ (NSArray *)getAllPropertyWithClass:(id)classType;

+ (NSArray *)getAllPropertyTypeWithClass:(id)classType;

/** 对类的所有属性赋值 */
- (void)setAllPropertyWithDict:(NSDictionary *)dict;


@end
