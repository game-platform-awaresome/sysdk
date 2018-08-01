//
//  FFRefreshTableView.h
//  SY_185SDK
//
//  Created by 燚 on 2017/12/14.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLRefreshHeaderView.h"
#import "LLRefreshFooterView.h"

@interface FFRefreshTableView : UITableView

- (void)setLLRefreshHeader:(LLRefreshHeaderView *)aRefreshHeader;
- (LLRefreshHeaderView *)LLRefreshHeader;

- (void)setLLRefreshFooter:(LLRefreshFooterView *)aRefreshFooter;
- (LLRefreshFooterView *)LLRefreshFooter;

@end
