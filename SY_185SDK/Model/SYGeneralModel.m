//
//  SYGeneralModel.m
//  SY_185SDK
//
//  Created by 燚 on 2018/8/1.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import "SYGeneralModel.h"
#import <objc/runtime.h>


@implementation SYGeneralModel


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
    free(properties);
    return [mArray copy];
}

+ (NSArray *)getAllPropertyTypeWithClass:(id)classType {
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([classType class], &count);

    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count;  i++) {

        objc_property_t property = properties[i];

        const char * cName = property_getAttributes(property);

        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];

        [mArray addObject:name];
    }
    return [mArray copy];
}

/** 对类的属性赋值 */
- (void)setAllPropertyWithDict:(NSDictionary *)dict {
    NSArray *names = [[self class] getAllPropertyWithClass:self];

    @try {
        if (dict == nil) {
            for (NSString *name in names) {
                if ([[self valueForKey:name] isKindOfClass:[NSObject class]]) {
                    [self setValue:nil forKey:name];
                } else {
                    [self setValue:0 forKey:name];
                }

                if ([name isEqualToString:@"maxSpped"]) {
                    [self setValue:@0 forKey:name];
                } else if ([[self valueForKey:name] isKindOfClass:[NSNumber class]]) {
                    [self setValue:@0 forKey:name];
                } else {
                    [self setValue:nil forKey:name];
                }
            }
        } else {

            for (NSString *name in names) {
                //如果字典中的值为空，赋值可能会出问题
                if (!name) {
                    continue;
                }

                if ([name isEqualToString:@"uid"] && dict[@"id"]) {
                    [self setValue:dict[@"id"] forKey:name];
                } else if(dict[name]) {
                    if ([dict[name] isKindOfClass:[NSArray class]]) {
                        [self setValue:dict[name] forKey:name];
                    } else {
                        [self setValue:[NSString stringWithFormat:@"%@",dict[name]] forKey:name];
                    }
                }
            }

        }
    } @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    } @finally {

    }

}



@end
