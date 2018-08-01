//
//  GM_PropsListView.m
//  SY_GMSDK
//
//  Created by 燚 on 2017/10/18.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "GM_PropsListView.h"
#import "GM_ViewModel.h"

#define CELLIDE @"PropsListCell"
#define SECTION_HEIGHT (k_WIDTH / 6)
#define CELL_HEIGHT (k_WIDTH / 8)
#define LIGHTGRAYCOLOR RGBCOLOR(245, 245, 245)

@interface GM_PropsListView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *listView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIImageView *selectImageView;

@end


@implementation GM_PropsListView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    _selectIndex = -1;
    self.backgroundColor = RGBACOLOR(55, 55, 55, 88);
    [self addSubview:self.listView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self.listView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
}

#pragma mark - responds
- (void)propsListViewCloseButton {
    _selectIndex = -1;
    [self.selectImageView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - tableview data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.propsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELLIDE];
    }

    if (indexPath.row == _selectIndex) {
        [cell.contentView addSubview:self.selectImageView];
    }

    cell.textLabel.text = self.propsList[indexPath.row][@"name"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT - 1, k_WIDTH * 0.8, 1)];
    line.backgroundColor = LIGHTGRAYCOLOR;

    [cell.contentView addSubview:line];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SECTION_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] init];
    sectionView.frame = CGRectMake(0, 0, k_WIDTH * 0.8, SECTION_HEIGHT);
    sectionView.backgroundColor = LIGHTGRAYCOLOR;

    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, k_WIDTH * 0.8, SECTION_HEIGHT - 2);
    title.backgroundColor = [UIColor whiteColor];
    title.text = @"     选择物品 :";
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:20];
    [sectionView addSubview:title];

    [sectionView addSubview:self.closeButton];

    return sectionView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectIndex = indexPath.row;

    [self.selectImageView removeFromSuperview];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.contentView addSubview:self.selectImageView];

    if (self.propsList[_selectIndex] != nil && self.delegate && [self.delegate respondsToSelector:@selector(GMPropsListView:didSelectPropsWithDict:)]) {
        [self.delegate GMPropsListView:self didSelectPropsWithDict:self.propsList[_selectIndex]];
    
        [self propsListViewCloseButton];
    }
}


#pragma mark - setter
- (void)setPropsList:(NSArray *)propsList {
    _propsList = propsList;

    [self.listView reloadData];
}

#pragma mark - getter
- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, k_WIDTH * 0.8, k_WIDTH * 0.8) style:(UITableViewStylePlain)];

        _listView.delegate = self;
        _listView.dataSource = self;

        _listView.backgroundColor = [UIColor whiteColor];
        _listView.bounces = YES;

        _listView.layer.cornerRadius = 8;
        _listView.layer.masksToBounds = YES;
        _listView.showsVerticalScrollIndicator = NO;
        _listView.showsHorizontalScrollIndicator = NO;

        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _listView;
}


- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _closeButton.bounds = CGRectMake(0, 0, k_WIDTH / 14,  k_WIDTH / 14);
        _closeButton.center = CGPointMake(k_WIDTH * 0.8 - (k_WIDTH / 14), SECTION_HEIGHT / 2 - 1);
        [_closeButton setImage:SDK_IMAGE(@"GM_closeButton") forState:(UIControlStateNormal)];
        [_closeButton addTarget:self action:@selector(propsListViewCloseButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.bounds = CGRectMake(0, 0, k_WIDTH / 20, k_WIDTH / 20);
        _selectImageView.center = CGPointMake(k_WIDTH * 0.8 - k_WIDTH / 15, CELL_HEIGHT / 2);
        _selectImageView.image = SDK_IMAGE(@"GM_selectUsed");
    }
    return _selectImageView;
}


@end









