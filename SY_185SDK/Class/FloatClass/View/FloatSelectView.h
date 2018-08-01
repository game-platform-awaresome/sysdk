//
//  FloatSelectView.h
//  SDK185SY
//
//  Created by 石燚 on 2017/6/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectViewDelegate <NSObject>

- (void)didSelectBtnAtIndexPath:(NSInteger)idx;

@end

@interface FloatSelectView : UIView

- (instancetype)initWithFrame:(CGRect)frame WithBtnArray:(NSArray *)btnNameArray;

@property (nonatomic, strong) NSArray *btnNameArray;

@property (nonatomic, weak) id<SelectViewDelegate> delegate;


/**移动主视图时下标的位置*/
@property (nonatomic, assign) NSInteger index;


@end
