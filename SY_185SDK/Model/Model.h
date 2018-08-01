//
//  Model.h
//  SY_185SDK
//
//  Created by 燚 on 2017/9/27.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "RequestTool.h"

@interface Model : RequestTool

/** 获取所有类的属性 */
+ (NSArray *)getAllPropertyWithClass:(id)classType;

/** 对类的所有属性赋值 */ 
- (void)setAllPropertyWithDict:(NSDictionary *)dict;



@end
