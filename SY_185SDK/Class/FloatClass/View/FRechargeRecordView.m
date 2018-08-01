//
//  FRechargeRecordView.m
//  SDK185SY
//
//  Created by 石燚 on 2017/7/12.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FRechargeRecordView.h"
#import "BTWFloatModel.h"
#import "SY_RRViewCell.h"

#define CELL_IDE @"SY_RRCELL"

@interface FRechargeRecordView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

/** tableview */
@property (nonatomic, strong) UITableView *tableView;
/** table view data source */
@property (nonatomic, strong) NSMutableArray *showArray;

/** title */
@property (nonatomic, strong) UILabel *title;
/** 分割线 */
@property (nonatomic, strong) UIView *line;

/** 当前页数 */
@property (nonatomic, assign) NSInteger currentPage;
/** 总共记录 */
@property (nonatomic, assign) NSInteger totalRecord;
/** 是否加载更多 */
@property (nonatomic, assign) BOOL isLoadMore;
@property (nonatomic, assign) BOOL isLoading;

/** 上拉刷新 */
@property (nonatomic, strong) UIRefreshControl *refreshControl;

/** 列表背景视图 */
@property (nonatomic, strong) UIView *tableViewBackground;
@property (nonatomic, strong) UIImageView *tableBacgroundImageView;


@end

@implementation FRechargeRecordView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUserInterface];
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
    
    [self addSubview:self.title];
    [self addSubview:self.line];
    [self addSubview:self.tableView];
}

- (void)reFresh {
    SDKLOG(@"Recharge record");
    SDK_START_ANIMATION;
    [BTWFloatModel payNotesListWithPage:@"1" Size:nil Completion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;
        if (success) {
            self.showArray = [SDK_CONTENT_DATA[@"list"] mutableCopy];
            NSString *count = SDK_CONTENT_DATA[@"count"];
            if (count.integerValue != 1) {
                self.currentPage = 1;
                self.isLoadMore = YES;
            } else {
                self.isLoadMore = NO;
            }
        } else {
            self.showArray = nil;
        }

        if (self.showArray.count == 0) {
            self.tableBacgroundImageView.image = SDK_IMAGE(@"SDK_NoRecord");
        } else {
            self.tableBacgroundImageView.image = SDK_IMAGE(@"");
        }

        self.tableView.tableFooterView.hidden = YES;
        [self.tableView reloadData];
    }];
}

- (void)loadMore {
    
    if (self.isLoadMore == NO) {
        return;
    }
    self.currentPage++;

    SDK_START_ANIMATION;
    self.isLoading = YES;
    [BTWFloatModel payNotesListWithPage:[NSString stringWithFormat:@"%ld",(long)self.currentPage] Size:nil Completion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;

        if (success) {
            NSArray *array = SDK_CONTENT_DATA[@"list"];
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
            } else {
                self.isLoadMore = NO;
            }
        }

        self.tableView.tableFooterView.hidden = YES;
        self.isLoading = NO;
        [self.tableView reloadData];
    }];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.showArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SY_RRViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    
    cell.dict = self.showArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FLOAT_MENU_HEIGHT / 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.showArray.count == 0) {
        return 0;
    }
    return FLOAT_MENU_HEIGHT / 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {


    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT / 10)];
    view.backgroundColor = self.line.backgroundColor;

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLOAT_MENU_WIDTH, 1)];
    line.backgroundColor = RGBCOLOR(200, 200, 200);
    [view addSubview:line];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, FLOAT_MENU_WIDTH / 3, FLOAT_MENU_HEIGHT / 10 - 1)];
    label1.text = @"充值时间";
    label1.backgroundColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(FLOAT_MENU_WIDTH / 3 + 1, 0, FLOAT_MENU_WIDTH / 3 - 2, FLOAT_MENU_HEIGHT / 10 - 1)];
    label2.text = @"充值金额";
    label2.backgroundColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(FLOAT_MENU_WIDTH / 3 * 2, 0, FLOAT_MENU_WIDTH / 3, FLOAT_MENU_HEIGHT / 10 - 1)];
    label3.text = @"充值结果";
    label3.backgroundColor = [UIColor whiteColor];
    label3.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label3];
    
    return view;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isLoadMore == NO) {
        return;
    }
    
    // 获取当前contentView滑动的位置(对应contentSize)
    CGFloat contenOffsetY = scrollView.contentOffset.y;
    
    // 如果tableView还没有数据或footerView在显示时, 直接返回
    if (self.showArray.count == 0 || self.tableView.tableFooterView.hidden == NO) {
        return;
    }
    
    if (self.isLoading) {
        return;
    }
    
    // 最后一个Cell显示时contentOffSetY应该在的最小位置(内容高度 + 边框 - 显示窗口高度 - footrerView高度)
    CGFloat targetContentOffsetY = scrollView.contentSize.height +scrollView.contentInset.bottom - scrollView.bounds.size.height - self.tableView.tableFooterView.bounds.size.height;
    
    // 若滑动位置在目标位置下(显示到最后一个Cell)时
    if (contenOffsetY >= targetContentOffsetY) {
        // 显示footerView
        self.tableView.tableFooterView.hidden = NO;
        self.isLoading = YES;
        // 加载更多数据
        [self loadMore];
    }
}



#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, CGRectGetMaxY(self.line.frame), FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT - CGRectGetMaxY(self.line.frame));
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[SY_RRViewCell class] forCellReuseIdentifier:CELL_IDE];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _tableView.backgroundView = self.tableViewBackground;
    }
    return _tableView;
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

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.frame = CGRectMake(FLOAT_MENU_WIDTH / 4, FLOAT_MENU_WIDTH / 30, FLOAT_MENU_WIDTH / 2, FLOAT_MENU_WIDTH / 8);
        _title.text = @"充值记录";
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = BUTTON_GREEN_COLOR;
        _title.font = [UIFont systemFontOfSize:22];
        _title.tag = 10086;
    }
    return _title;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
    }
    return _refreshControl;
}

- (UIView *)tableViewBackground {
    if (!_tableViewBackground) {
        _tableViewBackground = [[UIView alloc] init];
        _tableViewBackground.backgroundColor = [UIColor whiteColor];
        _tableViewBackground.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, self.bounds.size.height);
        [_tableViewBackground addSubview:self.tableBacgroundImageView];
    }
    return _tableViewBackground;
}

- (UIImageView *)tableBacgroundImageView {
    if (!_tableBacgroundImageView) {
        _tableBacgroundImageView = [[UIImageView alloc] init];
        _tableBacgroundImageView.bounds = CGRectMake(0, 0, 70.5, 93.5);
        _tableBacgroundImageView.center = CGPointMake(FLOAT_MENU_WIDTH / 2, FLOAT_MENU_HEIGHT / 3);
    }
    return _tableBacgroundImageView;
}


@end












