//
//  FBServerCell.m
//  SY_185SDK
//
//  Created by 燚 on 2017/12/12.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FBServerCell.h"

@interface FBServerCell ()


@property (nonatomic, strong) UILabel *serverLabel;
@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UILabel *detailText;

@end

@implementation FBServerCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.contentView addSubview:self.serverLabel];
    [self.contentView addSubview:self.backImage];
}

- (void)setTextString:(NSString *)textString {
    CGSize size = [textString boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;


    self.backImage.frame = CGRectMake(60, 18, size.width + 27, size.height + 20);
    self.detailText.text = textString;
    [self.detailText sizeToFit];
    self.detailText.frame = CGRectMake(17, 10, size.width, size.height);

}

#pragma mark - getter
- (UILabel *)serverLabel {
    if (!_serverLabel) {
        _serverLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 50, 36)];
        _serverLabel.textAlignment = NSTextAlignmentCenter;
        _serverLabel.text = @"客服 : ";
        _serverLabel.font = [UIFont systemFontOfSize:16];
    }
    return _serverLabel;
}

- (UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [[UIImageView alloc] init];
        _backImage.image = [SDK_IMAGE(@"SDK_Receiver_Chat") resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{18,25,17,25}") resizingMode:UIImageResizingModeStretch];
        [_backImage addSubview:self.detailText];
    }
    return _backImage;
}

- (UILabel *)detailText {
    if (!_detailText) {
        _detailText = [[UILabel alloc] init];
        _detailText.textAlignment = NSTextAlignmentLeft;
        _detailText.font = [UIFont systemFontOfSize:16];
        _detailText.numberOfLines = 0;
        _detailText.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _detailText;
}







@end
