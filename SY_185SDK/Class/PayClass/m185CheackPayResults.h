//
//  m185CheackPayResults.h
//  SY_185SDK
//
//  Created by 燚 on 2017/10/24.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CheckResultsDelegate <NSObject>

- (void)checkResultsDelegateCheckResultSuccess:(BOOL)success infomation:(NSDictionary *)dict;


@end

@interface m185CheackPayResults : NSObject

@property (nonatomic, weak) id<CheckResultsDelegate> delegate;

/** orderID */
@property (nonatomic, strong) NSString *orderID;

+ (m185CheackPayResults *)cheackResultsWithOrderID:(NSString *)orderID delegage:(id<CheckResultsDelegate>)delegate;

@end
