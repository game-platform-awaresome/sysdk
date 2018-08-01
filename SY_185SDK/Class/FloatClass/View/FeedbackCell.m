//
//  FeedbackCell.m
//  SY_185SDK
//
//  Created by 燚 on 2017/12/11.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FeedbackCell.h"

@interface FeedbackCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *typeLabel;

@end

@implementation FeedbackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.typeLabel];
    CALayer *line = [[CALayer alloc] init];
    line.frame = CGRectMake(WIDTH / 2, 0, 1, self.bounds.size.height);
    line.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.contentView.layer addSublayer:line];

    CALayer *line1 = [[CALayer alloc] init];
    line1.backgroundColor = [UIColor lightGrayColor].CGColor;
    line1.frame = CGRectMake(WIDTH / 6 * 5, 0, 1, self.bounds.size.height);
    [self.contentView.layer addSublayer:line1];
}

- (void)setDict:(NSDictionary *)dict {
    if (dict) {
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@",dict[@"title"]];
    NSString *time = dict[@"modify_time"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    self.timeLabel.text = [formatter stringFromDate:date];

//    syLog(@"?????  =%@",dict);
    NSString *string = [NSString stringWithFormat:@"%@",dict[@"status"]];
    switch (string.integerValue) {
        case 1: {
            self.typeLabel.text = @"处理中";
            self.typeLabel.textColor = [UIColor redColor];
        }
            break;
        case 2: {
            self.typeLabel.text = @"已处理";
            self.typeLabel.textColor = [UIColor greenColor];
        }
            break;
        case 3: {
            self.typeLabel.text = @"已关闭";
            self.typeLabel.textColor = [UIColor grayColor];
        }
            break;

        default:
            break;
    }
    /**    id = 13;
     "modify_time" = 1513049967;
     "order_id" = 5a2f4f6f86ae9;
     status = 1;
     title = "\U6d4b\U8bd53"; */
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH / 2 - 20, self.bounds.size.height)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"埃里克森刚搭建案例集";
        _titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 2, 0, WIDTH / 3, self.bounds.size.height)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"2017-11-02 22:12";
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 6 * 5, 0, WIDTH / 6, self.bounds.size.height)];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _typeLabel;
}







@end
