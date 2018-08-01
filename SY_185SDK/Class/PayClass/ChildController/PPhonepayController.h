//
//  PPhonepayController.h
//  SDK185SY
//
//  Created by 石燚 on 2017/6/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ChinaMobile1 = 7,
    ChinaTelecom1 = 8,
    ChinaUnicom1 = 9,
} PhonePayTye;


@protocol PhonepayDelegate <NSObject>

/** 选择支付 */
- (void)PhonePayControllerSelectPhonePayWithPhoneTye:(PhonePayTye)payType
                                              CardID:(NSString *)cardID
                                        CardPassword:(NSString *)cardPassword
                                          CardAmount:(NSString *)cardAmount;

@end


@interface PPhonepayController : UIViewController

@property (nonatomic, weak) id<PhonepayDelegate> delegate;

/** 充值类型标签 */
@property (nonatomic, strong) NSString *rechargeTitle;
/** 充值账号 */
@property (nonatomic, strong) NSString *rechargeAccount;

@end







