//
//  m185WebViewController.h
//  SY_185SDK
//
//  Created by 燚 on 2017/10/24.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class m185WebViewController;


@protocol m185WebViewControllerDelegate <NSObject>

- (void)m185WebViewController:(m185WebViewController *)controller closeWebViewWith:(id)info;

@end

@interface m185WebViewController : UIViewController


@property (nonatomic, weak) id<m185WebViewControllerDelegate> delegate;

/** 加载网页 */
- (void)addWebViewWithUrl:(NSString *)url;


@end
