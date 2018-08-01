//
//  GMDetailCell.m
//  SY_GMSDK
//
//  Created by 燚 on 2017/10/17.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "GMDetailCell.h"
#import "GM_ViewModel.h"

#define CELL_HEIGHT k_WIDTH / 8


@interface GMDetailCell ()

@property (nonatomic, strong) UIImageView *selectImageView;

@property (nonatomic, strong) UILabel *gmAuthorityLabel;

@property (nonatomic, strong) UILabel *isUsedLabel;

@property (nonatomic, strong) NSString *isUsed;

@end

@implementation GMDetailCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.selectImageView.image = SDK_IMAGE(@"GM_selectCell");
    } else {
        self.selectImageView.image = SDK_IMAGE(@"GM_unSelectCell");
    }

    [self.contentView addSubview:self.selectImageView];
    [self.contentView addSubview:self.selectButton];
    [self.contentView addSubview:self.gmAuthorityLabel];
    [self.contentView addSubview:self.isUsedLabel];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.selectButton.center = CGPointMake(self.bounds.size.width / 9 * 8, CELL_HEIGHT / 2);
    self.selectImageView.center = CGPointMake(self.bounds.size.width / 10, CELL_HEIGHT / 2);
    self.gmAuthorityLabel.center = CGPointMake(self.bounds.size.width / 10 * 3.5, CELL_HEIGHT / 2);
    self.isUsedLabel.center = CGPointMake(self.bounds.size.width / 10 * 6.5, CELL_HEIGHT / 2);
}


#pragma mark - setter
- (void)setDataDict:(NSDictionary *)dataDict {
    if (dataDict) {
        _dataDict = dataDict;

        _isUsed = [NSString stringWithFormat:@"%@",dataDict[@"exsits_pri"]];
        _isUsed.boolValue ? ([self setIsUsedAuthority]) : ([self setUnUsedAuthority]);

        NSString *gearName = dataDict[@"gear_name"];
        self.gmAuthorityLabel.text = gearName;

    }
}

- (void)setIsUsedAuthority {
    self.isUsedLabel.text = @"可使用";
    [self.selectButton setTitle:@"" forState:(UIControlStateNormal)];
    self.selectButton.backgroundColor = [UIColor clearColor];
    [self.selectButton setImage:SDK_IMAGE(@"GM_selectUsed") forState:(UIControlStateNormal)];
    [self.selectButton removeTarget:self action:@selector(respondsToSelectButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUnUsedAuthority {
    self.isUsedLabel.text = @"未开通";
    [self.selectButton setTitle:@"开通" forState:(UIControlStateNormal)];
    self.selectButton.backgroundColor = RGBCOLOR(199, 176, 41);

    [self.selectButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.selectButton setTitleColor:[UIColor blueColor] forState:(UIControlStateHighlighted)];

    [self.selectButton setImage:nil forState:(UIControlStateNormal)];
    [self.selectButton addTarget:self action:@selector(respondsToSelectButton) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - responds
- (void)respondsToSelectButton  {
    if (self.delegate && [self.delegate respondsToSelector:@selector(GMDetailCell:didSelectButtonWithDict:)]) {
        [self.delegate GMDetailCell:self didSelectButtonWithDict:self.dataDict];
    }
}


#pragma mark - getter
- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] initWithImage:SDK_IMAGE(@"GM_selectCell")];
        _selectImageView.bounds = CGRectMake(0, 0, CELL_HEIGHT / 2, CELL_HEIGHT / 2);
    }
    return _selectImageView;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _selectButton.bounds = CGRectMake(0, 0, CELL_HEIGHT / 3 * 4, CELL_HEIGHT / 3 * 2);
        _selectButton.layer.cornerRadius = 3;
        _selectButton.layer.masksToBounds = YES;
    }
    return _selectButton;
}

- (UILabel *)gmAuthorityLabel {
    if (!_gmAuthorityLabel) {
        _gmAuthorityLabel = [[UILabel alloc] init];
        _gmAuthorityLabel.bounds = CGRectMake(0, 0, k_WIDTH / 3, CELL_HEIGHT);
        _gmAuthorityLabel.textAlignment = NSTextAlignmentCenter;
        _gmAuthorityLabel.font = [UIFont systemFontOfSize:15];
        _gmAuthorityLabel.text = @"GM 权限";
    }
    return _gmAuthorityLabel;
}

- (UILabel *)isUsedLabel {
    if (!_isUsedLabel) {
        _isUsedLabel = [[UILabel alloc] init];
        _isUsedLabel.bounds = CGRectMake(0, 0, k_WIDTH / 4, CELL_HEIGHT);
        _isUsedLabel.textAlignment = NSTextAlignmentCenter;
        _isUsedLabel.font = [UIFont systemFontOfSize:16];
        _isUsedLabel.text = @"可使用";
    }
    return _isUsedLabel;
}










@end












