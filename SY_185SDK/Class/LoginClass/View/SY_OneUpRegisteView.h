//
//  SY_OneUpRegisteView.h
//  SDK185SY
//
//  Created by 石燚 on 2017/7/13.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYOneUpRegistDelegate <NSObject>

- (void)SYOneUPRegistViewShowRegistView;

- (void)SYOneUpRegistViewLoginWithAccount:(NSString *)account Password:(NSString *)password;

- (void)SYOneUpRegistViewScreenShots;

@end

@interface SY_OneUpRegisteView : UIView

@property (nonatomic, strong) NSString *OURCurrentAccount;
@property (nonatomic, strong) NSString *OURCurrentPassword;

@property (nonatomic, weak) id<SYOneUpRegistDelegate> oneUpDelegate;

@end
