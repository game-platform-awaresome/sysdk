//
//  FloatSelectView.m
//  SDK185SY
//
//  Created by 石燚 on 2017/6/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FloatSelectView.h"


#define BTNTAG 1400

@interface FloatSelectView ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;

@property (nonatomic, strong) UIButton *lastBtn;

@property (nonatomic, strong) UIView *line;

@end


@implementation FloatSelectView


- (instancetype)initWithFrame:(CGRect)frame WithBtnArray:(NSArray *)btnNameArray {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.btnNameArray = btnNameArray;
    }
    return self;
}


- (void)setBtnNameArray:(NSArray *)btnNameArray {

    NSArray<UIView *> *viewArray = [self subviews];
    [viewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];

    _btnNameArray = btnNameArray;

    NSArray *imageNames = nil;
    NSArray *selectImageNames = nil;
    if (btnNameArray.count == 3) {
        imageNames = @[@"SDK_Maccount_dark",@"SDK_gift_dark",@"SDK_logout_dark"];
        selectImageNames = @[@"SDK_Maccount_light",@"SDK_gift_light",@"SDK_logout_light"];
    } else if (btnNameArray.count == 4) {
        imageNames = @[@"SDK_Maccount_dark",@"SDK_gift_dark",@"SDK_Speed_dark",@"SDK_logout_dark"];
        selectImageNames = @[@"SDK_Maccount_light",@"SDK_gift_light",@"SDK_Speed_light",@"SDK_logout_light"];
    }



    _buttons = [NSMutableArray arrayWithCapacity:btnNameArray.count];
    
    [_btnNameArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(idx * FLOAT_MENU_HEIGHT / _btnNameArray.count, 0, FLOAT_MENU_WIDTH / _btnNameArray.count, FLOAT_MENU_HEIGHT / 3);
        
        [button setTitle:obj forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        button.tag = BTNTAG + idx;
        
        
        [button setImage:SDK_IMAGE(imageNames[idx]) forState:(UIControlStateNormal)];
        [button setImage:SDK_IMAGE(selectImageNames[idx]) forState:(UIControlStateSelected)];
        
        if (idx == 3) {
            [button setImage:SDK_IMAGE(selectImageNames[idx]) forState:(UIControlStateHighlighted)];
        }
        
        [button addTarget:self action:@selector(respondstoBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [button layoutIfNeeded];
        CGRect titleFrame = button.titleLabel.frame;
        CGRect imageFrame = button.imageView.frame;
        CGFloat space = titleFrame.origin.x - imageFrame.origin.x - imageFrame.size.width;
        
        [button setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleFrame.size.height + space + 30, -(titleFrame.size.width))];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(imageFrame.size.height + space, -(imageFrame.size.width), 15, 0)];
        
        [button setTitleColor:TEXTCOLOR forState:(UIControlStateNormal)];
        [button setTitleColor:BUTTON_GREEN_COLOR forState:(UIControlStateSelected)];
        
        if (idx == 0) {
            _lastBtn = button;
            _lastBtn.selected = YES;
        }
        
        if (idx == 3) {
            [button setTitleColor:BUTTON_GREEN_COLOR forState:(UIControlStateHighlighted)];
        }
        
        [_buttons addObject:button];
        
        [self addSubview:button];
    }];

    [self addSubview:self.line];
    
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    
    if (_lastBtn) {
        _lastBtn.selected = NO;
    }
    
    _buttons[index].selected = YES;
    
    _lastBtn = _buttons[_index];
//    _lastBtn.selected = YES;
}


#pragma mark - respondstoBtn
- (void)respondstoBtn:(UIButton *)sender {
    NSInteger index = sender.tag - BTNTAG;
    
    if (index != 3) {
        self.index = sender.tag - BTNTAG;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBtnAtIndexPath:)]) {
        [self.delegate didSelectBtnAtIndexPath:index];
    }
    
}


- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLOAT_MENU_WIDTH, 1)];
        _line.backgroundColor = [UIColor grayColor];
    }
    return _line;
}

@end



