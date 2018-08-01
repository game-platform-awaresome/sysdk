//
//  PPhonepayController.m
//  SDK185SY
//
//  Created by 石燚 on 2017/6/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "PPhonepayController.h"

#define SELECTBTNTAG 12086
#define SUMMONEtBTNTAG 13086

#define INTERESTINGWIDTH ([self getInterestDifference] -  view_width / 5 * 4) / 3
#define INETRESTINGOriginX [self getInterestOriginX]

@interface PPhonepayController ()<UIScrollViewDelegate>

/** 滑动背景 */
@property (nonatomic, strong) UIScrollView *scrollView;

/** 选择运营商 */
@property (nonatomic, strong) UIView *selectOperatorView;
@property (nonatomic, strong) UIButton *lastSelectBtn;

/** 提示信息 - 充值账号 */
@property (nonatomic, strong) UILabel *accountLabel;
/** 提示信息 - 充值类型 */
@property (nonatomic, strong) UILabel *rechargeTypeLabel;

/** 充值面额 */
//提示标签
@property (nonatomic, strong) UILabel *sumMoneyLabel;
//选择标签
@property (nonatomic, strong) UIView *sumMoneySelectView;
@property (nonatomic, strong) NSArray *sumMoneyArray;
@property (nonatomic, strong) UIButton *lastSumMoneyBtn;

/** 信息录入 */
@property (nonatomic, strong) UITextField *PrepaidCardID;
@property (nonatomic, strong) UITextField *PrepaidCardPassword;

/** 充值按钮 */
@property (nonatomic, strong) UIButton *rechargeBtn;

/** 充值运营商 */
@property (nonatomic, assign) PhonePayTye phonePayType;
/** 充值金额 */
@property (nonatomic, strong) NSString *amountMoney;

@end



@implementation PPhonepayController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.rechargeTypeLabel.text = [NSString stringWithFormat:@"支付金额 : %@ 元",_rechargeTitle];
    self.accountLabel.text = [NSString stringWithFormat:@"充值账号 : %@",_rechargeAccount];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(PAYVIEW_WIDTH / 3 + 1, 0, PAYVIEW_WIDTH / 3 * 2 - 1, PAYVIEW_HEIGHT);
    [self.view addSubview:self.scrollView];
}

- (void)respondsToRechargeButton {
    if ([self.delegate respondsToSelector:@selector(PhonePayControllerSelectPhonePayWithPhoneTye:CardID:CardPassword:CardAmount:)]) {

        //判断运营商
        if (self.phonePayType != ChinaMobile1 && self.phonePayType != ChinaUnicom1 && self.phonePayType != ChinaTelecom1) {
            SDK_MESSAGE(@"请选择运营商");
            return;

        }

        //判断金额
        if (self.lastSumMoneyBtn == nil || self.amountMoney == nil) {
            SDK_MESSAGE(@"请选择充值金额");
            return;
        }

        //判断卡号
        if (self.PrepaidCardID.text.length == 0) {
            SDK_MESSAGE(@"请输入充值卡号");
            return;
        }

        //判断密码
        if (self.PrepaidCardPassword.text.length == 0) {
            SDK_MESSAGE(@"请输入充值卡密码");
            return;
        }


        [self.delegate PhonePayControllerSelectPhonePayWithPhoneTye:self.phonePayType CardID:self.PrepaidCardID.text CardPassword:self.PrepaidCardPassword.text CardAmount:self.amountMoney];
    }
}

#pragma mark - responds
- (void)respondsToSelectOperator:(UIButton *)sender {
    NSInteger idx = sender.tag - SELECTBTNTAG + 7;

    self.phonePayType = (PhonePayTye)idx;
    if (_lastSelectBtn != sender) {
        _lastSelectBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        _lastSelectBtn = sender;
        _lastSelectBtn.backgroundColor = RGBCOLOR(42, 179, 231);
    }
}

- (void)respondsToSumMoneySeletc:(UIButton *)sender {
    NSInteger idx = sender.tag - SUMMONEtBTNTAG;
    self.amountMoney = self.sumMoneyArray[idx];

    if (_lastSumMoneyBtn != sender) {
        _lastSumMoneyBtn.backgroundColor = [UIColor whiteColor];
        _lastSumMoneyBtn = sender;
        _lastSumMoneyBtn.backgroundColor = RGBCOLOR(42, 179, 231);
    }
}


#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {


}

#pragma mark - setter
- (void)setRechargeTitle:(NSString *)rechargeTitle {

    _rechargeTitle = rechargeTitle;
}

- (void)setRechargeAccount:(NSString *)rechargeAccount {
    _rechargeAccount = rechargeAccount;

}

#pragma mark - getter
//滑动背景
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, view_width, view_height)];

        [_scrollView setContentSize:CGSizeMake(view_width, 500)];
        
        _scrollView.backgroundColor = [UIColor whiteColor];
        
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.scrollEnabled = YES;
        
        _scrollView.delegate = self;
        
        [_scrollView flashScrollIndicators];
        
        //运营商按钮
        [_scrollView addSubview:self.selectOperatorView];
        //充值信息
        [_scrollView addSubview:self.accountLabel];
        [_scrollView addSubview:self.rechargeTypeLabel];
        //充值金额
        [_scrollView addSubview:self.sumMoneyLabel];
        [_scrollView addSubview:self.sumMoneySelectView];
        //信息录入
        [_scrollView addSubview:self.PrepaidCardID];
        [_scrollView addSubview:self.PrepaidCardPassword];
        //充值按钮
        [_scrollView addSubview:self.rechargeBtn];
    }
    return _scrollView;
}


//运营商选择背景
- (UIView *)selectOperatorView {
    if (!_selectOperatorView) {
        _selectOperatorView = [[UIView alloc] init];
        
        _selectOperatorView.frame = CGRectMake(0, 40, view_width, 30);
        
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            
            button.bounds = CGRectMake(0, 0, view_width / 4, 30);
            button.center = CGPointMake(view_width / 4 * (i + 1), 15);
            [button setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
            button.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
            button.layer.borderWidth = 1;
            button.layer.cornerRadius = 8;
            button.layer.masksToBounds = YES;
            [button setTitleColor:TEXTCOLOR forState:(UIControlStateNormal)];
            button.tag = SELECTBTNTAG + i;
            
            [button addTarget:self action:@selector(respondsToSelectOperator:) forControlEvents:(UIControlEventTouchUpInside)];
            
            switch (i) {
                case 0: {
                    button.center = CGPointMake(view_width / 16 * 3, 15);
                    [button setTitle:@"移动" forState:(UIControlStateNormal)];
                    break;
                }
                case 1: {
                    button.center = CGPointMake(view_width / 2, 15);
                    [button setTitle:@"联通" forState:(UIControlStateNormal)];
                    break;
                }
                case 2: {
                    button.center = CGPointMake(view_width / 16 * 13, 15);
                    [button setTitle:@"电信" forState:(UIControlStateNormal)];
                    break;
                }
                default:
                    break;
            }
            
            [_selectOperatorView addSubview:button];
        }
    }
    return _selectOperatorView;
}

/** 充值账号 */
- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        UIButton *button = (UIButton *)[self.selectOperatorView viewWithTag:SELECTBTNTAG];

//        syLog(@"充值账号 btn ::  %@",self.selectOperatorView.subviews);
        _accountLabel.frame = CGRectMake(CGRectGetMinX(button.frame), CGRectGetMaxY(self.selectOperatorView.frame) + 5, view_width - CGRectGetMinX(button.frame), 15);

//        syLog(@"=== %@",_accountLabel);

        _accountLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        _accountLabel.font = [UIFont systemFontOfSize:12];
        _accountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _accountLabel;
}

/** 充值类型 */
- (UILabel *)rechargeTypeLabel {
    if (!_rechargeTypeLabel) {
        _rechargeTypeLabel = [[UILabel alloc] init];
        _rechargeTypeLabel.frame = CGRectMake(CGRectGetMinX(self.accountLabel.frame), CGRectGetMaxY(self.accountLabel.frame), self.accountLabel.frame.size.width, 15);

//        syLog(@"充值类型 === %@",_rechargeTypeLabel);

        _rechargeTypeLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        _rechargeTypeLabel.font = [UIFont systemFontOfSize:12];
        _rechargeTypeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rechargeTypeLabel;
}

//金额提示 leibel
- (UILabel *)sumMoneyLabel {
    if (!_sumMoneyLabel) {
        _sumMoneyLabel = [[UILabel alloc] init];
        _sumMoneyLabel.frame = CGRectMake(CGRectGetMinX(self.accountLabel.frame), CGRectGetMaxY(self.rechargeTypeLabel.frame) + 5, view_width * 0.9, 15);



        _sumMoneyLabel.text = @"充值卡面额 : ";
        _sumMoneyLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        _sumMoneyLabel.font = [UIFont systemFontOfSize:12];
    }
    return _sumMoneyLabel;
}

- (UIView *)sumMoneySelectView {
    if (!_sumMoneySelectView) {
        _sumMoneySelectView = [[UIView alloc] init];
        _sumMoneySelectView.frame = CGRectMake(0, CGRectGetMaxY(self.sumMoneyLabel.frame) + 2, PAYVIEW_WIDTH, 65);
        
        for (int i = 0 ; i < 8 ; i++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];

            button.frame = CGRectMake(INETRESTINGOriginX + (i % 4) * (view_width / 5 + INTERESTINGWIDTH), i / 4 * 35, view_width / 5, 30);
            
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:TEXTCOLOR forState:(UIControlStateNormal)];
            button.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
            button.layer.borderWidth = 1;
            button.layer.cornerRadius = 8;
            button.layer.masksToBounds = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.tag = SUMMONEtBTNTAG + i;
            [button setTitle:[NSString stringWithFormat:@"%@元",self.sumMoneyArray[i]] forState:(UIControlStateNormal)];
            
            [button addTarget:self action:@selector(respondsToSumMoneySeletc:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [_sumMoneySelectView addSubview:button];
        }
        
    }
    return _sumMoneySelectView;
}

- (NSArray *)sumMoneyArray {
    if (!_sumMoneyArray) {
        _sumMoneyArray = @[@"10",@"20",@"30",@"50",@"100",@"200",@"300",@"500"];
    }
    return _sumMoneyArray;
}

/** 充值卡号 */
- (UITextField *)PrepaidCardID {
    if (!_PrepaidCardID) {
        _PrepaidCardID = [[UITextField alloc] init];

        _PrepaidCardID.bounds = CGRectMake(0, 0, [self getInterestDifference], 36);
        _PrepaidCardID.center = CGPointMake(view_width / 2 , CGRectGetMaxY(self.sumMoneySelectView.frame) + 25);
        _PrepaidCardID.placeholder = @"  充值卡号 :";
        _PrepaidCardID.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _PrepaidCardID.borderStyle = UITextBorderStyleNone;
        _PrepaidCardID.layer.borderWidth = 1;
        _PrepaidCardID.layer.borderColor = RGBCOLOR(223, 202, 211).CGColor;
        _PrepaidCardID.layer.cornerRadius = 5;
        _PrepaidCardID.layer.masksToBounds = YES;
        
        [_PrepaidCardID setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
        
    }
    return _PrepaidCardID;
}

/** 充值卡密码 */
- (UITextField *)PrepaidCardPassword {
    if (!_PrepaidCardPassword) {
        _PrepaidCardPassword = [[UITextField alloc] init];
        
        _PrepaidCardPassword.bounds = CGRectMake(0, 0, [self getInterestDifference], 36);
        _PrepaidCardPassword.center = CGPointMake(view_width / 2 , CGRectGetMaxY(self.PrepaidCardID.frame) + 25);
        _PrepaidCardPassword.placeholder = @"  充值卡密码 :";
        _PrepaidCardPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _PrepaidCardPassword.borderStyle = UITextBorderStyleNone;
        _PrepaidCardPassword.layer.borderWidth = 1;
        _PrepaidCardPassword.layer.borderColor = RGBCOLOR(223, 202, 211).CGColor;
        _PrepaidCardPassword.layer.cornerRadius = 5;
        _PrepaidCardPassword.layer.masksToBounds = YES;
        
        [_PrepaidCardPassword setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    }
    return _PrepaidCardPassword;
}

/** 充值按钮 */
- (UIButton *)rechargeBtn {
    if (!_rechargeBtn) {
        _rechargeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _rechargeBtn.bounds = CGRectMake(0, 0, [self getInterestDifference], 36);
        _rechargeBtn.center = CGPointMake(view_width / 2, CGRectGetMaxY(self.PrepaidCardPassword.frame) + 30);
        [_rechargeBtn setTitle:@"立即充值" forState:(UIControlStateNormal)];
        [_rechargeBtn setBackgroundColor:BUTTON_GREEN_COLOR];
        _rechargeBtn.layer.cornerRadius = 8;
        _rechargeBtn.layer.masksToBounds = YES;
        [_rechargeBtn addTarget:self action:@selector(respondsToRechargeButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rechargeBtn;
}

- (CGFloat)getInterestDifference {
    UIButton *selBtn = [self.selectOperatorView viewWithTag:SELECTBTNTAG];
    UIButton *selbtn2 = [self.selectOperatorView viewWithTag:SELECTBTNTAG + 2];
    return CGRectGetMaxX(selbtn2.frame) - CGRectGetMinX(selBtn.frame);
//    syLog(@"btn1 === %@",selBtn);
}

- (CGFloat)getInterestOriginX {
    UIButton *selBtn = [self.selectOperatorView viewWithTag:SELECTBTNTAG];
    return selBtn.frame.origin.x;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
