//
//  Model.m
//  SY_185SDK
//
//  Created by 燚 on 2017/9/27.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "Model.h"
#import <objc/runtime.h>

@implementation Model

/** 获取类的所有属性 */
+ (NSArray *)getAllPropertyWithClass:(id)classType {
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([classType class], &count);

    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count;  i++) {

        objc_property_t property = properties[i];

        const char *cName = property_getName(property);

        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];

        [mArray addObject:name];
    }
    return [mArray copy];
}

/** 对类的属性赋值 */
- (void)setAllPropertyWithDict:(NSDictionary *)dict {
    WeakSelf;
    NSArray *names = [Model getAllPropertyWithClass:self];

    //    syLog(@"names = %@",names);

    if (dict == nil) {
        for (NSString *name in names) {
            if ([name isEqualToString:@"maxSpped"]) {
                [weakSelf setValue:@0 forKey:name];
            } else if ([[weakSelf valueForKey:name] isKindOfClass:[NSNumber class]]) {
                [weakSelf setValue:@0 forKey:name];
            } else {
                [weakSelf setValue:nil forKey:name];
            }
        }
    } else {

        for (NSString *name in names) {
            //如果字典中的值为空，赋值可能会出问题
            if (!name) {
                continue;
            }

            if ([name isEqualToString:@"uid"] && dict[@"id"]) {
                [weakSelf setValue:dict[@"id"] forKey:name];
            } else if(dict[name]) {
                if ([dict[name] isKindOfClass:[NSArray class]]) {
                    [weakSelf setValue:dict[name] forKey:name];
                } else {
                    [weakSelf setValue:[NSString stringWithFormat:@"%@",dict[name]] forKey:name];
                }
            }
        }
    }
}



@end
