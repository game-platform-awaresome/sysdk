//
//  SY_RRViewCell.m
//  SDK185SY
//
//  Created by 石燚 on 2017/7/12.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SY_RRViewCell.h"


#define cell_Width self.bounds.size.width
#define cell_Height FLOAT_MENU_HEIGHT / 7

@interface SY_RRViewCell ()

/** 充值时间 */
@property (nonatomic, strong) UILabel *rechargeTimeLabel;
/** 充值类型 */
@property (nonatomic, strong) UILabel *rechargeTypeLabel;
/** 充值结果 */
@property (nonatomic, strong) UILabel *rechargeResultLabel;

@end

@implementation SY_RRViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT / 7);
    self.backgroundColor = LINECOLOR;
    
    [self.contentView addSubview:self.rechargeTimeLabel];
    [self.contentView addSubview:self.rechargeTypeLabel];
    [self.contentView addSubview:self.rechargeResultLabel];
}

- (void)setDict:(NSDictionary *)dict {
    /** 充值时间 */
//    NSString *timeString = [NSString stringWithFormat:@"%@",dict[@"create_time"]];
//    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:timeString.integerValue];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"HH:mm:ss\nYYYY-MM-dd";
//    timeString = [formatter stringFromDate:timeDate];
    self.rechargeTimeLabel.text = [NSString stringWithFormat:@"%@",dict[@"create_time"]];
    
    /** 充值金额 */
    NSString *amountString = [NSString stringWithFormat:@"%@元",dict[@"money"]];
    self.rechargeTypeLabel.text = amountString;
    
    /** 充值结果 */
    NSString *resultString = [NSString stringWithFormat:@"%@",dict[@"status"]];
    switch (resultString.integerValue) {
        case 0: {
            self.rechargeResultLabel.text = @"失败";
            self.rechargeResultLabel.textColor = [UIColor redColor];
            }
            break;
        case 1: {
            self.rechargeResultLabel.text = @"成功";
            self.rechargeResultLabel.textColor = BUTTON_GREEN_COLOR;
        }
            break;
        case 2: {
            self.rechargeResultLabel.text = @"发货中";
            self.rechargeResultLabel.textColor = BLUE_LIGHT;
        }
            break;
        case 3: {
            self.rechargeResultLabel.text = @"未支付";
            self.rechargeResultLabel.textColor = BUTTON_YELLOW_COLOR;

        }
            break;
        default:
            break;
    }

}

#pragma mark - getter
- (UILabel *)rechargeTimeLabel {
    if (!_rechargeTimeLabel) {
        _rechargeTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, FLOAT_MENU_WIDTH / 3, cell_Height - 1)];
        _rechargeTimeLabel.textAlignment = NSTextAlignmentCenter;
        _rechargeTimeLabel.text = @"10:10:15\n2017-07-07";
        _rechargeTimeLabel.numberOfLines = 0;
        _rechargeTimeLabel.backgroundColor = [UIColor whiteColor];
        if (kSCREEN_WIDTH > 375) {
            _rechargeTimeLabel.font = [UIFont systemFontOfSize:16];
        } else {
            _rechargeTimeLabel.font = [UIFont systemFontOfSize:14];
        }
        _rechargeTimeLabel.textColor = TEXTCOLOR;
    }
    return _rechargeTimeLabel;
}

- (UILabel *)rechargeTypeLabel {
    if (!_rechargeTypeLabel) {
        _rechargeTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(FLOAT_MENU_WIDTH / 3 + 1, 0, FLOAT_MENU_WIDTH / 3 - 2, cell_Height - 1)];
        _rechargeTypeLabel.textAlignment = NSTextAlignmentCenter;
        _rechargeTypeLabel.text= @"30元";
        _rechargeTypeLabel.numberOfLines = 1;
        _rechargeTypeLabel.backgroundColor = [UIColor whiteColor];
        _rechargeTypeLabel.textColor = TEXTCOLOR;
    }
    return _rechargeTypeLabel;
}

- (UILabel *)rechargeResultLabel {
    if (!_rechargeResultLabel) {
        _rechargeResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(FLOAT_MENU_WIDTH / 3 * 2, 0, FLOAT_MENU_WIDTH / 3, cell_Height - 1)];
        _rechargeResultLabel.textAlignment = NSTextAlignmentCenter;
        _rechargeResultLabel.text= @"失败";
        _rechargeResultLabel.numberOfLines = 1;
        _rechargeResultLabel.backgroundColor = [UIColor whiteColor];
        _rechargeResultLabel.textColor = TEXTCOLOR;
    }
    return _rechargeResultLabel;
}









@end
