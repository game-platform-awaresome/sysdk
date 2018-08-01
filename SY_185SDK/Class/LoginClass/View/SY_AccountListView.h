//
//  SY_AccountListView.h
//  SY_185SDK
//
//  Created by 燚 on 2018/7/6.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SY_AccountListView;

@protocol SY_AccountListViewDelegate <NSObject>

- (void)SY_AccountListView:(SY_AccountListView *)view clickCloseButton:(id)obj;

- (void)SY_AccountListView:(SY_AccountListView *)view Login:(NSDictionary *)dict;


@end


@interface SY_AccountListView : UIView


@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSMutableArray *showArray;

@property (nonatomic, weak) id<SY_AccountListViewDelegate> delegate;




@end
