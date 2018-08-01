//
//  GM_DetailView.h
//  SY_GMSDK
//
//  Created by 燚 on 2017/10/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GM_DetailView;


@protocol GM_DetailViewDelegate <NSObject>

- (void)detailView:(GM_DetailView *)view closeView:(id)info;

/** 发送道具 */
- (void)detailView:(GM_DetailView *)view sendPropsWithProp_id:(NSString *)prop_id
          Prop_num:(NSString *)prop_num;

/** 选择物品 */
- (void)detailView:(GM_DetailView *)view didSelectProposViewWithGearID:(NSString *)gear_id;

/** 选择物品数量 */
- (void)detailView:(GM_DetailView *)view didSelectPropsNumViewWithInfo:(id)info;

/** 开通 GM 权限 */
- (void)detailView:(GM_DetailView *)view openGmPermissionsWithDict:(NSDictionary *)dict;


@end


@interface GM_DetailView : UIView

@property (nonatomic, weak) id<GM_DetailViewDelegate> delegate;


@property (nonatomic, strong) NSArray *dataArray;

//views
/** 关闭视图按钮 */
@property (nonatomic, strong) UIButton *closeButton;
/** 表头视图 */
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) UILabel *roleNameTitle;
@property (nonatomic, strong) UILabel *roleNameLabel;
@property (nonatomic, strong) UILabel *serveridTitle;

/** GM 权限列表 */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *sectionLabel;
/** 选择道具视图 */
@property (nonatomic, strong) UIView *selectPropsView;
@property (nonatomic, strong) UIImageView *selectPropsimageView;
@property (nonatomic, strong) UILabel *selectPropsTitle;
@property (nonatomic, strong) UILabel *selectPropsName;
@property (nonatomic, strong) UIImageView *selectPropsFooter;

/** 分割线 */
@property (nonatomic, strong) UIView *separaLine;

/** 选择数量视图 */
@property (nonatomic, strong) UIView *selectPropsNumView;
@property (nonatomic, strong) UILabel *selectPropsNumTitle;
@property (nonatomic, strong) UILabel *selectPropsNumLabel;
/** 发送按钮 */
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) NSString *prop_id;
@property (nonatomic, strong) NSString *prop_name;
@property (nonatomic, strong) NSString *prop_num;
@property (nonatomic, strong) NSString *gear_id;


@end












