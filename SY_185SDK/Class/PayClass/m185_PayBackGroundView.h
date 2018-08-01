//
//  m185_PayBackGroundView.h
//  SY_185SDK
//
//  Created by 燚 on 2017/10/10.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayModel.h"

@protocol m185_PayBackGroundViewDelegate <NSObject>

/** 关闭了支付页面 */
- (void)payViewCloseView;

/** 发起支付 */
- (void)payViewPayStartWithPayType:(PayType)payType CardID:(NSString *)cardID CardPassword:(NSString *)cardPassword CardAmount:(NSString *)cardAmount;


@end

@interface m185_PayBackGroundView : UIViewController

/** 代理 */
@property (nonatomic, weak) id<m185_PayBackGroundViewDelegate> delegate;

/** 支付账号 */
@property (nonatomic, strong) NSString *userID;

/** 支付金额 */
@property (nonatomic, strong) NSString *amount;

/** 加载网页 */ 
- (void)addWebViewWithUrl:(NSString *)url;


@end


