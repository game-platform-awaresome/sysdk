//
//  SYFeedBackModel.m
//  SY_185SDK
//
//  Created by 燚 on 2018/8/6.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import "SYFeedBackModel.h"

@implementation SYFeedBackQuestionDetail


@end



@implementation SYFeedBackQuestionMessage



@end


@implementation SYFeedBackModel


+ (SYFeedBackModel *)setModelWithDict:(NSDictionary *)dict {
    SYFeedBackModel *model = [[SYFeedBackModel alloc] init];
    [model setValueWithDict:dict];
    return model;
}



- (void)setValueWithDict:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        [self setquestionDetailWith:dict[@"question"]];
        [self setMessageWith:dict[@"question_list"]];
    } else {
        [InfomationTool showAlertMessage:@"工单信息出错,请稍后尝试" dismissTime:0.7 dismiss:nil];
    }
}

- (void)setquestionDetailWith:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        self.questionDetail = [[SYFeedBackQuestionDetail alloc] init];
        self.questionDetail.question_title          = [NSString stringWithFormat:@"%@",dict[@"title"] ?: @""];
        self.questionDetail.question_type           = [NSString stringWithFormat:@"%@",dict[@"type"] ?: @""];
        self.questionDetail.question_description    = [NSString stringWithFormat:@"%@",dict[@"desc"] ?: @""];
    }
}

- (void)setMessageWith:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        self.page_count = [NSString stringWithFormat:@"%@",dict[@"count"] ?: @"1"];
        self.messageList = dict[@"list"] ?: nil;
//        if (listArray && listArray.count) {
//            self.messageList = [NSMutableArray arrayWithCapacity:listArray.count];
//            for (NSDictionary *dict in listArray) {
//
//            }
//        } else {
//            self.messageList = nil;
//        }
    }
}




@end
