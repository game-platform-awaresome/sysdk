//
//  GM_DetailView.m
//  SY_GMSDK
//
//  Created by 燚 on 2017/10/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "GM_DetailView.h"
#import "GM_ViewModel.h"
#import "GMDetailCell.h"

#define LIGHTGRAYCOLOR RGBCOLOR(245, 245, 245);
#define CELLIDE @"GMDetailCell"

@interface GM_DetailView ()<UITableViewDataSource, UITableViewDelegate, GMDetailCellDelegate>

@property (nonatomic, strong) NSDictionary *GearDict;
@property (nonatomic, strong) NSString *isUsedGear;

@end

@implementation GM_DetailView 

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.backgroundColor = LIGHTGRAYCOLOR;
    self.layer.cornerRadius = 12;
    self.layer.masksToBounds = YES;

    [self addSubview:self.titleView];
    [self addSubview:self.tableView];
    [self addSubview:self.selectPropsView];
    [self addSubview:self.selectPropsNumView];
    [self addSubview:self.sendButton];
}

#pragma mark - responds
- (void)respondsToCloserButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailView:closeView:)]) {
        [self.delegate detailView:self closeView:nil];
    }
}

- (void)respondsTosendButton {

    if (self.gear_id == nil || [self.gear_id isEqualToString:@""]) {
        SDK_MESSAGE(@"请选择 GM 权限档位");
        return;
    }

    if (self.isUsedGear.integerValue != 1) {
        SDK_MESSAGE(@"未开通 GM 档位权限");
        return;
    }

    if (self.prop_id == nil || [self.prop_id isEqualToString:@""]) {
        SDK_MESSAGE(@"请选择物品");
        return;
    }

    if (self.prop_num == nil || [self.prop_num isEqualToString:@""]) {
        SDK_MESSAGE(@"请选择数量");
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(detailView:sendPropsWithProp_id:Prop_num:)]) {
        [self.delegate detailView:self sendPropsWithProp_id:self.prop_id Prop_num:self.prop_num];
    }

}

- (void)respondsToSelectPropsView {
    if (self.gear_id == nil || [self.gear_id isEqualToString:@""]) {
        SDK_MESSAGE(@"请选择 GM 权限档位");
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(detailView:didSelectProposViewWithGearID:)]) {
        [self.delegate detailView:self didSelectProposViewWithGearID:self.gear_id];
    }
}

- (void)respondsToSelectPropsNumView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailView:didSelectPropsNumViewWithInfo:)]) {
        [self.delegate detailView:self didSelectPropsNumViewWithInfo:nil];
    }
}

#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GMDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (self.dataArray.count < indexPath.row) {
        SDKLOG(@"GM function list error");
    } else {

        NSDictionary *dict = self.dataArray[indexPath.row];

        if (dict) {
            cell.dataDict = dict;
            cell.delegate = self;
        }
    }


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return k_WIDTH / 8;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return k_WIDTH / 8 + 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, k_WIDTH / 8 + 3)];
    sectionView.backgroundColor = LIGHTGRAYCOLOR;
    [sectionView addSubview:self.sectionLabel];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row > self.dataArray.count) {
        return;
    }

    NSDictionary *dict = self.dataArray[indexPath.row];
    self.isUsedGear = [NSString stringWithFormat:@"%@",dict[@"exsits_pri"]];
//    if (isUsed && isUsed.integerValue == 1) {
        self.gear_id = [NSString stringWithFormat:@"%@",dict[@"gear_id"]];
    self.GearDict = dict;
//    } else {
//        self.gear_id = nil;
//    }
}


#pragma mark - cell delegate
- (void)GMDetailCell:(GMDetailCell *)cell didSelectButtonWithDict:(NSDictionary *)dict {
    if (dict == nil) {
        SDK_MESSAGE(@"开通数据出错");
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailView:openGmPermissionsWithDict:)]) {
        [self.delegate detailView:self openGmPermissionsWithDict:dict];
    }
}



#pragma mark - setter
- (void)setDataArray:(NSArray *)dataArray {
    if (dataArray) {
        _dataArray = dataArray;
        [self.tableView reloadData];
    }
}

- (void)setProp_id:(NSString *)prop_id {
    _prop_id = [NSString stringWithFormat:@"%@",prop_id];
}

- (void)setProp_name:(NSString *)prop_name {
    _prop_name = [NSString stringWithFormat:@"%@",prop_name];
    self.selectPropsName.text = [NSString stringWithFormat:@" %@  ",prop_name];
}

- (void)setProp_num:(NSString *)prop_num {
    _prop_num = [NSString stringWithFormat:@"%@",prop_num];
    self.selectPropsNumLabel.text = [NSString stringWithFormat:@" %@  ",_prop_num];
}

#pragma mark - getter
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _closeButton.bounds = CGRectMake(0, 0, k_HEIGHT / 16, k_HEIGHT / 16);
        [_closeButton setImage:SDK_IMAGE(@"GM_closeButton") forState:(UIControlStateNormal)];
        [_closeButton addTarget:self action:@selector(respondsToCloserButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor whiteColor];
        [_titleView addSubview:self.titleImage];
        [_titleView addSubview:self.closeButton];
        [_titleView addSubview:self.roleNameTitle];
        [_titleView addSubview:self.roleNameLabel];
        [_titleView addSubview:self.serveridTitle];
    }
    return _titleView;
}

- (UIImageView *)titleImage {
    if (!_titleImage) {
        _titleImage = [[UIImageView alloc] init];
        _titleImage.bounds = CGRectMake(0, 0, k_WIDTH / 20, k_WIDTH / 20);
        _titleImage.image = SDK_IMAGE(@"GM_juese");
    }
    return _titleImage;
}

- (UILabel *)roleNameTitle {
    if (!_roleNameTitle) {
        _roleNameTitle = [[UILabel alloc] init];
        _roleNameTitle.textAlignment = NSTextAlignmentLeft;
        _roleNameTitle.textColor = [UIColor blackColor];
        _roleNameTitle.text = @"  角色信息 :";
        [_roleNameTitle sizeToFit];
    }
    return _roleNameTitle;
}

- (UILabel *)roleNameLabel {
    if (!_roleNameLabel) {
        _roleNameLabel = [[UILabel alloc] init];
        _roleNameLabel.textAlignment = NSTextAlignmentCenter;
        _roleNameLabel.textColor = [UIColor blackColor];
        _roleNameLabel.text = @"1";
    }
    return _roleNameLabel;
}

- (UILabel *)serveridTitle {
    if (!_serveridTitle) {
        _serveridTitle = [[UILabel alloc] init];
        _serveridTitle.textAlignment = NSTextAlignmentCenter;
        _serveridTitle.textColor = [UIColor blackColor];
    }
    return _serveridTitle;
}

/** --------------------------------------- */
/** 选择道具视图 */
- (UIView *)selectPropsView {
    if (!_selectPropsView) {
        _selectPropsView = [[UIView alloc] init];
        _selectPropsView.backgroundColor = [UIColor whiteColor];

        [_selectPropsView addSubview:self.selectPropsimageView];
        [_selectPropsView addSubview:self.selectPropsTitle];
        [_selectPropsView addSubview:self.selectPropsName];
        [_selectPropsView addSubview:self.selectPropsFooter];
        [_selectPropsView addSubview:self.separaLine];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSelectPropsView)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;

        [_selectPropsView addGestureRecognizer:tap];
        }
    return _selectPropsView;
}

- (UIImageView *)selectPropsimageView {
    if (!_selectPropsimageView) {
        _selectPropsimageView = [[UIImageView alloc] initWithImage:SDK_IMAGE(@"GM_selectProps")];
        _selectPropsimageView.bounds = CGRectMake(0, 0, k_WIDTH / 20, k_WIDTH / 20);
    }
    return _selectPropsimageView;
}

- (UILabel *)selectPropsTitle {
    if (!_selectPropsTitle) {
        _selectPropsTitle = [[UILabel alloc] init];
        _selectPropsTitle.textAlignment = NSTextAlignmentLeft;
        _selectPropsTitle.text = @"  选择物品 : ";
        _selectPropsTitle.font = [UIFont systemFontOfSize:16];
    }
    return _selectPropsTitle;
}

- (UILabel *)selectPropsName {
    if (!_selectPropsName) {
        _selectPropsName = [[UILabel alloc] init];
        _selectPropsName.textAlignment = NSTextAlignmentRight;
        _selectPropsName.text = @" 请选择  ";
        _selectPropsName.font = [UIFont systemFontOfSize:16];
    }
    return _selectPropsName;
}

- (UIImageView *)selectPropsFooter {
    if (!_selectPropsFooter) {
        _selectPropsFooter = [[UIImageView alloc] initWithImage:SDK_IMAGE(@"GM_selectFooter")];
        _selectPropsFooter.bounds = CGRectMake(0, 0, k_WIDTH / 40, k_WIDTH / 20);
    }
    return _selectPropsFooter;
}


- (UIView *)separaLine {
    if (!_separaLine) {
        _separaLine = [[UIView alloc] init];
        _separaLine.backgroundColor = LIGHTGRAYCOLOR;
        _separaLine.bounds = CGRectMake(0, 0, 2, k_WIDTH / 15);
        _separaLine.layer.cornerRadius = 1;
        _separaLine.layer.masksToBounds = YES;
    }
    return _separaLine;
}

/** --------------------------------------- */
/** 选择道具数量视图 */
- (UIView *)selectPropsNumView {
    if (!_selectPropsNumView) {
        _selectPropsNumView = [[UIView alloc] init];
        _selectPropsNumView.backgroundColor = [UIColor whiteColor];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSelectPropsNumView)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;

        [_selectPropsNumView addGestureRecognizer:tap];


        [_selectPropsNumView addSubview:self.selectPropsNumTitle];
        [_selectPropsNumView addSubview:self.selectPropsNumLabel];
    }
    return _selectPropsNumView;
}

- (UILabel *)selectPropsNumTitle {
    if (!_selectPropsNumTitle) {
        _selectPropsNumTitle = [[UILabel alloc] init];
        _selectPropsNumTitle.text = @"  数量 :  ";
        _selectPropsNumTitle.font = [UIFont systemFontOfSize:16];
        _selectPropsNumTitle.textAlignment = NSTextAlignmentCenter;
        _selectPropsNumTitle.bounds = CGRectMake(0, 0, k_WIDTH / 3, k_WIDTH / 10);
    }
    return _selectPropsNumTitle;
}

- (UILabel *)selectPropsNumLabel {
    if (!_selectPropsNumLabel) {
        _selectPropsNumLabel = [[UILabel alloc] init];
        _selectPropsNumLabel.text = @" 1 ";
        _selectPropsNumLabel.font = [UIFont systemFontOfSize:16];
        _selectPropsNumLabel.textAlignment = NSTextAlignmentCenter;
        _selectPropsNumLabel.bounds = CGRectMake(0, 0, k_WIDTH / 4, k_WIDTH / 10);
    }
    return _selectPropsNumLabel;
}

/** --------------------------------------- */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:(UITableViewStylePlain)];

        _tableView.backgroundColor = LIGHTGRAYCOLOR;

        [_tableView registerClass:[GMDetailCell class] forCellReuseIdentifier:CELLIDE];
        _tableView.tableFooterView = [UIView new];

        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UILabel *)sectionLabel {
    if (!_sectionLabel) {
        _sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, k_WIDTH, k_WIDTH / 8)];
        _sectionLabel.backgroundColor = [UIColor whiteColor];
        _sectionLabel.textAlignment = NSTextAlignmentCenter;
        _sectionLabel.text = @"GM 权限选择";
        _sectionLabel.font = [UIFont systemFontOfSize:22];
    }
    return _sectionLabel;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sendButton.backgroundColor = RGBCOLOR(96, 186, 75);
        [_sendButton setTitle:@"立即发放" forState:(UIControlStateNormal)];
        _sendButton.layer.cornerRadius = 8;
        _sendButton.layer.masksToBounds = YES;
        _sendButton.bounds = CGRectMake(0, 0, k_WIDTH / 2, k_WIDTH / 10);
        [_sendButton addTarget:self action:@selector(respondsTosendButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sendButton;
}




@end












