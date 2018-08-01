//
//  FAnnouncementView.m
//  BTWan
//
//  Created by 石燚 on 2017/7/24.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FAnnouncementView.h"
#import "BTWFloatModel.h"

@interface FAnnouncementView () <UITableViewDelegate,UITableViewDataSource>

/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 分割线 */
@property (nonatomic, strong) UIView *lineView;

/** tableview */
@property (nonatomic, strong) UITableView *tableview;

/** dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;

/** showArray */
@property (nonatomic, strong) NSArray *showArray;

/** 是否加载了公告 */
@property (nonatomic, assign) BOOL isLoadAnnounceMent;

/** 公告详情 */
@property (nonatomic, strong) UIView *detailAnnouncementView;
/** 分割线 */
@property (nonatomic, strong) UIView *line;
/** title */
@property (nonatomic, strong) UILabel *detailTitleLabel;
/** 关闭按钮 */
@property (nonatomic, strong) UIButton *detailCloseButton;
/** 公告详情 */
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, assign) CGRect origRect;
@property (nonatomic, assign) CGRect cellTitleRect;

/** 列表背景视图 */
@property (nonatomic, strong) UIView *tableViewBackground;
@property (nonatomic, strong) UIImageView *tableBacgroundImageView;

/**  */
@property (nonatomic, assign) BOOL isOpenDetail;

@end

@implementation FAnnouncementView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
        [self refreshData];
    }
    return self;
}



- (void)initUserInterface {
    self.frame = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT);

    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor grayColor].CGColor;

    _isOpenDetail = NO;

    [self addSubview:self.titleLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.tableview];

}

- (void)refreshData {
    SDK_START_ANIMATION;
    [BTWFloatModel announcementListWithPage:@"1" Size:nil Completion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;
        if (success) {
            self.showArray = SDK_CONTENT_DATA[@"list"];
            self.isLoadAnnounceMent = YES;
        } else {
            self.showArray = nil;
        }

        if (self.showArray.count == 0) {
            self.tableBacgroundImageView.image = SDK_IMAGE(@"SDK_NoAnnouncement");
        } else {
            self.tableBacgroundImageView.image = SDK_IMAGE(@"");
        }

        [self.tableview reloadData];
    }];

}

#pragma mark - tableview delegate ande dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PacksCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"PacksCell"];
    }

    cell.textLabel.text = self.showArray[indexPath.row][@"title"];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:SDK_IMAGE(@"SDK_AnnouncementAccess")];

    cell.accessoryView = imageView;



    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FLOAT_MENU_HEIGHT / 7;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    [self addDetailAnnouncementViewWithIndepath:indexPath];


}

/** 添加详细页面 */
- (void)addDetailAnnouncementViewWithIndepath:(NSIndexPath *)indexPath {
    self.userInteractionEnabled = NO;

    if (!self.showArray[indexPath.row][@"id"]) {
        return;
    }
    NSString *announce = [NSString stringWithFormat:@"%@",self.showArray[indexPath.row][@"id"]];

    self.detailLabel.text = @"加载中...";

    [BTWFloatModel detailAnnouncementWithID:announce Completion:^(NSDictionary *content, BOOL success) {

        NSString *state = content[@"state"];
        if (success && state.integerValue == 1) {
            self.detailLabel.text = content[@"content"];
        } else {
            self.detailLabel.text = @"暂无详情";
        }

        if (kSCREEN_WIDTH > 375) {
            self.detailLabel.font = [UIFont systemFontOfSize:16];
        } else {
            self.detailLabel.font = [UIFont systemFontOfSize:14];
        }

    }];

    UITableViewCell *cell =[self.tableview cellForRowAtIndexPath:indexPath];

    _origRect = [self.tableview convertRect:[self.tableview rectForRowAtIndexPath:indexPath] toView:[self.tableview superview]];

    _cellTitleRect = cell.textLabel.frame;

    self.detailTitleLabel.frame = _cellTitleRect;
    self.detailTitleLabel.text = cell.textLabel.text;
    self.detailTitleLabel.font = cell.textLabel.font;

    self.detailAnnouncementView.frame = _origRect;
    [self addSubview:self.detailAnnouncementView];

    self.line.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT / 7);

    [UIView animateWithDuration:0.3 animations:^{
        self.detailAnnouncementView.frame = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT);
        self.line.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_WIDTH / 15 + FLOAT_MENU_WIDTH / 8);
        self.detailTitleLabel.frame = CGRectMake(_cellTitleRect.origin.x, 0, FLOAT_MENU_WIDTH * 0.85 - _cellTitleRect.origin.x, FLOAT_MENU_WIDTH / 15 + FLOAT_MENU_WIDTH / 8 - 1);
 

    } completion:^(BOOL finished) {

        self.userInteractionEnabled = YES;

    }];
}

/** 关闭详细页面 */
- (void)respondsToDCloserButton {

    self.userInteractionEnabled = NO;

    [UIView animateWithDuration:0.3 animations:^{

        self.detailAnnouncementView.frame = _origRect;
        self.line.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT / 7);

        self.detailTitleLabel.frame = _cellTitleRect;
        self.detailTitleLabel.textAlignment = NSTextAlignmentLeft;

    } completion:^(BOOL finished) {

        [self.detailAnnouncementView removeFromSuperview];
        self.userInteractionEnabled = YES;

    }];

}

#pragma makr - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"公告";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = BUTTON_GREEN_COLOR;
        _titleLabel.frame = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_WIDTH / 15 + FLOAT_MENU_WIDTH / 8);
        _titleLabel.font = [UIFont systemFontOfSize:22];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.frame = CGRectMake(0, FLOAT_MENU_HEIGHT / 7, FLOAT_MENU_WIDTH, 1);
        _lineView.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_WIDTH / 15 + FLOAT_MENU_WIDTH / 8);
        _lineView.backgroundColor = LINECOLOR;
    }
    return _lineView;
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), FLOAT_MENU_WIDTH, self.bounds.size.height - FLOAT_MENU_HEIGHT / 7  - 1) style:(UITableViewStylePlain)];

        _tableview.delegate = self;
        _tableview.dataSource = self;

        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.showsHorizontalScrollIndicator = NO;


        _tableview.tableFooterView = [UIView new];

        _tableview.backgroundView = self.tableViewBackground;
    }
    return _tableview;
}


- (UIView *)detailAnnouncementView {
    if (!_detailAnnouncementView) {
        _detailAnnouncementView = [[UIView alloc] init];
        _detailAnnouncementView.backgroundColor = [UIColor whiteColor];

        [_detailAnnouncementView addSubview:self.line];

        _detailAnnouncementView.layer.cornerRadius = 8;
        _detailAnnouncementView.layer.masksToBounds = YES;
        [_detailAnnouncementView addSubview:self.detailCloseButton];
        [_detailAnnouncementView addSubview:self.detailTitleLabel];
        [_detailAnnouncementView addSubview:self.detailLabel];
        _detailAnnouncementView.layer.borderColor = [UIColor grayColor].CGColor;
        _detailAnnouncementView.layer.borderWidth = 1.f;
        _detailAnnouncementView.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToDCloserButton)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;

        [_detailAnnouncementView addGestureRecognizer:tap];

    }
    return _detailAnnouncementView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor lightGrayColor];
        _line.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH, 1);
        _line.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_WIDTH / 15 + FLOAT_MENU_WIDTH / 8);
    }
    return _line;
}

- (UIButton *)detailCloseButton {
    if (!_detailCloseButton) {
//        _detailCloseButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//
//        _detailCloseButton.frame = CGRectMake(FLOAT_MENU_WIDTH * 0.85, FLOAT_MENU_WIDTH / 30, FLOAT_MENU_WIDTH / 8, FLOAT_MENU_WIDTH / 8);
//        [_detailCloseButton setImage:[UIImage imageNamed:IMAGE_GET_BUNDLE_PATH(@"SYSDK_closeButton")] forState:(UIControlStateNormal)];
//
//        [_detailCloseButton addTarget:self action:@selector(respondsToDCloserButton) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _detailCloseButton;
}

- (UILabel *)detailTitleLabel {
    if (!_detailTitleLabel) {
        _detailTitleLabel = [[UILabel alloc] init];
        _detailTitleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _detailTitleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.frame = CGRectMake(0, FLOAT_MENU_WIDTH / 15 + FLOAT_MENU_WIDTH / 8, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT - FLOAT_MENU_WIDTH / 15 + FLOAT_MENU_WIDTH / 8);
        _detailLabel.backgroundColor = [UIColor whiteColor];
        _detailLabel.numberOfLines = 0;
        _detailLabel.textColor = TEXTCOLOR;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}

- (UIView *)tableViewBackground {
    if (!_tableViewBackground) {
        _tableViewBackground = [[UIView alloc] init];
        _tableViewBackground.backgroundColor = [UIColor whiteColor];
        _tableViewBackground.frame = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT);
        [_tableViewBackground addSubview:self.tableBacgroundImageView];
    }
    return _tableViewBackground;
}

- (UIImageView *)tableBacgroundImageView {
    if (!_tableBacgroundImageView) {
        _tableBacgroundImageView = [[UIImageView alloc] init];
        _tableBacgroundImageView.center = CGPointMake(self.tableViewBackground.center.x, self.tableViewBackground.center.y / 3 * 2);
        _tableBacgroundImageView.bounds = CGRectMake(0, 0, 70.5, 93.5);
    }
    return _tableBacgroundImageView;
}


@end











