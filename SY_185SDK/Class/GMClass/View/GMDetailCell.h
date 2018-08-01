//
//  GMDetailCell.h
//  SY_GMSDK
//
//  Created by 燚 on 2017/10/17.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GMDetailCell;

@protocol GMDetailCellDelegate <NSObject>

/** 开通权限 */
- (void)GMDetailCell:(GMDetailCell *)cell didSelectButtonWithDict:(NSDictionary *)dict;


@end


@interface GMDetailCell : UITableViewCell

@property (nonatomic, weak) id<GMDetailCellDelegate> delegate;

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) NSDictionary *dataDict;



@end
