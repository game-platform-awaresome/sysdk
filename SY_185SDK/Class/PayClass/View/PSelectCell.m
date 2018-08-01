//
//  PSelectCell.m
//  SDK185SY
//
//  Created by 石燚 on 2017/6/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "PSelectCell.h"

#define CELL_HEIGHT self.frame.size.height
#define CELL_WIDTH PAYVIEW_HEIGHT / 3

@interface PSelectCell ()

/** 下划线 */
@property (nonatomic, strong) UIView *lineView;

/** 支付logo */
@property (nonatomic, strong) UIImageView *logoImageView;

/** 支付 title */
@property (nonatomic, strong) UILabel *logoLabel;

@end

@implementation PSelectCell

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self initUserInterface:frame];
//    }
//    return self;
//}
//
//- (void)initUserInterface:(CGRect)frame {
//    self.frame = CGRectMake(0, 0, frame.size.height, frame.size.height);
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }

}

#pragma mark - setter
- (void)setLogoImage:(UIImage *)logoImage {
    if (logoImage) {
        self.logoImageView.image = logoImage;
    } else {
        self.logoImageView.image = nil;
    }
}

- (void)setLogoTitle:(NSString *)logoTitle {
    if (logoTitle) {
        self.logoLabel.text = logoTitle;
    } else {
        self.logoLabel.text = @"";
    }
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;

    //添加分割线
    [self.contentView addSubview:self.lineView];

    //添加 logo
    [self.contentView addSubview:self.logoImageView];

    //添加 title
    [self.contentView addSubview:self.logoLabel];
}

#pragma mark - getter
/** 分割线 */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.frame = CGRectMake(0, CELL_HEIGHT, CELL_WIDTH, 1);
        _lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    }
    return _lineView;
}

/** logoImage */
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.bounds = CGRectMake(0, 0, CELL_HEIGHT / 2, CELL_HEIGHT / 2);
        _logoImageView.center = CGPointMake(CELL_WIDTH / 2, CELL_HEIGHT / 7 * 3);
        //        _logoImageView.backgroundColor = [UIColor orangeColor];
    }
    return _logoImageView;
}

/** 标题 */
- (UILabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = [[UILabel alloc] init];
        _logoLabel.bounds = CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT / 4);
        _logoLabel.center = CGPointMake(CELL_WIDTH / 2, self.logoImageView.center.y + CELL_HEIGHT / 12 * 5);
        //        _logoLabel.backgroundColor = BLUE_DARK;
        _logoLabel.textAlignment = NSTextAlignmentCenter;
        _logoLabel.font = [UIFont systemFontOfSize:15];
    }
    return _logoLabel;
}

@end










