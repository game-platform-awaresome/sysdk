//
//  GM_PropsListView.h
//  SY_GMSDK
//
//  Created by 燚 on 2017/10/18.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GM_PropsListView;

@protocol GMPropsListViewDelegate <NSObject>

- (void)GMPropsListView:(GM_PropsListView *)propsListView didSelectPropsWithDict:(NSDictionary *)dict;

@end

@interface GM_PropsListView : UIView

@property (nonatomic, weak) id<GMPropsListViewDelegate> delegate;

@property (nonatomic, strong) NSArray *propsList;


@end
