//
//  SYFeedBackModel.h
//  SY_185SDK
//
//  Created by 燚 on 2018/8/6.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYFeedBackQuestionDetail : NSObject

@property (nonatomic, strong) NSString *question_title;         //问题标题
@property (nonatomic, strong) NSString *question_description;   //问题描述
@property (nonatomic, strong) NSString *question_type;          //问题类型


@end

@interface SYFeedBackQuestionMessage: NSObject

@property (nonatomic, strong) NSString *message_content;        //内容详情
@property (nonatomic, strong) NSString *message_time;           //发送时间
@property (nonatomic, strong) NSString *message_type;           //发送类型 - 1.玩家发送. 2.客服发送

@end



@interface SYFeedBackModel : NSObject

@property (nonatomic, strong) SYFeedBackQuestionDetail                    *questionDetail;    //工单详情
//@property (nonatomic, strong) NSMutableArray<SYFeedBackQuestionMessage *> *messageList;       //反馈列表
@property (nonatomic, strong) NSArray                                     *messageList;
@property (nonatomic, strong) NSString                                    *page_count;

+ (SYFeedBackModel *)setModelWithDict:(NSDictionary *)dict;





@end







