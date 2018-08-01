//
//  FeedbackViewController.m
//  SY_185SDK
//
//  Created by 燚 on 2017/12/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FBSubmitViewController.h"
#import "FeedbackCell.h"
#import "UserModel.h"
#import "FBAlertController.h"
#import "FBDetailViewController.h"
#import "FFRefreshTableView.h"

#define RefreshHeaderKeyPathContentOffset @"RefreshHeaderKeyPathContentOffset"

@interface FeedbackViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIBarButtonItem *rightButton;
@property (nonatomic, strong) UIBarButtonItem *leftButton;

@property (nonatomic, strong) NSMutableArray *showArray;
@property (nonatomic, strong) UIRefreshControl *refresh;

@property (nonatomic, strong) FFRefreshTableView *tableView;

@property (nonatomic, assign) BOOL isLoadMore;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _currentPage = 1;
    [self.tableView.LLRefreshHeader LL_BeginRefresh];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"问题反馈";
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, kNAVGATION_HEIGHT, WIDTH, HEIGHT - kNAVGATION_HEIGHT);
    self.navigationItem.leftBarButtonItem = self.leftButton;
    self.navigationItem.rightBarButtonItem = self.rightButton;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - responds
- (void)respondsToLeftButton {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)respondsToRightButton {
    [self startWaitAnimation];
    [UserModel FeedBackQuestionTypeWithCompletion:^(NSDictionary *content, BOOL success) {
        [self stopWaitAnimation];
        syLog(@"question type === %@",content);
        if (success) {
            NSDictionary *dict = content[@"data"];
            [self.navigationController presentViewController:[FBSubmitViewController showSubmit] animated:YES completion:nil];
            [FBSubmitViewController setLimitNumber:dict[@"question_limit"]];
            [FBSubmitViewController setSelectType:dict[@"type"]];
        }
    }];
}


- (void)refreshData {
    _currentPage = 1;
    [UserModel FeedbackListWithPage:[NSString stringWithFormat:@"%ld",(long)_currentPage] Completion:^(NSDictionary *content, BOOL success) {
        [self.refresh endRefreshing];
        [self.tableView.LLRefreshHeader LL_EndRefresh];
        syLog(@"============================%@",content);
        NSString *string = content[@"data"][@"count"];
        if (success) {
            if (string.integerValue > 1) {
                self.isLoadMore = YES;
            } else {
                self.isLoadMore = NO;
            }
            self.showArray = [content[@"data"][@"list"] mutableCopy];
        } else {
            self.isLoadMore = NO;
            self.showArray = nil;
            [self showAlertMessage:content[@"msg"] dismissTime:0.7 dismiss:nil];
        }
        [self.tableView reloadData];
    }];
}

- (void)loadMore {

    if (self.isLoadMore == NO) {
        [self.tableView.LLRefreshFooter LL_EndRefresh];
        return;
    }
    self.currentPage++;


    self.isLoading = YES;
    [UserModel FeedbackListWithPage:[NSString stringWithFormat:@"%ld",(long)self.currentPage] Completion:^(NSDictionary *content, BOOL success) {
        [self.tableView.LLRefreshFooter LL_EndRefresh];
        if (success) {
            NSArray *array = SDK_CONTENT_DATA[@"list"];
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
            } else {
                self.isLoadMore = NO;
            }
        }
        self.isLoading = NO;
        [self.tableView reloadData];
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     FeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedbackCell" forIndexPath:indexPath];

     cell.dict = self.showArray[indexPath.row];

     return cell;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *status = self.showArray[indexPath.row][@"status"];
    if (status.integerValue == 3) {
        [FBDetailViewController setCaneEdit:NO];
    } else {
        [FBDetailViewController setCaneEdit:YES];
    }
    [FBDetailViewController setDict:self.showArray[indexPath.row]];
    [self.navigationController presentViewController:[FBDetailViewController showDetail] animated:YES completion:^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    view.backgroundColor = [UIColor whiteColor];
    CALayer *line1 = [[CALayer alloc] init];
    line1.backgroundColor = [UIColor lightGrayColor].CGColor;
    line1.frame = CGRectMake(0, 0, WIDTH, 1);
    [view.layer addSublayer:line1];

    CALayer *line2 = [[CALayer alloc] init];
    line2.backgroundColor = [UIColor lightGrayColor].CGColor;
    line2.frame = CGRectMake(0, 29, WIDTH, 1);
    [view.layer addSublayer:line2];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH / 2, 30)];
    label1.text = @"标题";
    label1.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label1];

    CALayer *line3 = [[CALayer alloc] init];
    line3.backgroundColor = [UIColor lightGrayColor].CGColor;
    line3.frame = CGRectMake(WIDTH / 2, 0, 1, 30);
    [view.layer addSublayer:line3];

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 2, 0, WIDTH / 3, 30)];
    label2.text = @"时间";
    label2.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label2];

    CALayer *line4 = [[CALayer alloc] init];
    line4.backgroundColor = [UIColor lightGrayColor].CGColor;
    line4.frame = CGRectMake(WIDTH / 6 * 5, 0, 1, 30);
    [view.layer addSublayer:line4];

    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 6 * 5, 0, WIDTH / 6, 30)];
    label3.text = @"状态";
    label3.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label3];

    return view;
}

#pragma mark - getter
- (UIBarButtonItem *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIBarButtonItem alloc] initWithTitle:@"<<返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
    }
    return _leftButton;
}

- (UIBarButtonItem *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(respondsToRightButton)];
    }
    return _rightButton;
}

- (FFRefreshTableView *)tableView {
    if (!_tableView) {
        _tableView = [[FFRefreshTableView alloc] initWithFrame:CGRectMake(0, kNAVGATION_HEIGHT, WIDTH, HEIGHT - kNAVGATION_HEIGHT) style:(UITableViewStylePlain)];


        [_tableView registerClass:[FeedbackCell class] forCellReuseIdentifier:@"FeedbackCell"];

        _tableView.tableFooterView = [UIView new];

        _tableView.delegate = self;
        _tableView.dataSource = self;


        _tableView.LLRefreshHeader = [LLRefreshHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        _tableView.LLRefreshFooter = [LLRefreshFooterView footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];

        _tableView.tableFooterView = [UIView new];

    }
    return _tableView;
}


- (void)showAlertMessage:(NSString *)message dismissTime:(float)second dismiss:(void (^)(void))dismiss  {

    FBAlertController *alertController = [FBAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];

    [self presentViewController:alertController animated:YES completion:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:^{
            if (dismiss) {
                dismiss();
            }
        }];
    });
}


/** 开始等待动画 */
- (void)startWaitAnimation {
    [InfomationTool animationBack].frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [InfomationTool animationView].center = CGPointMake(WIDTH / 2, HEIGHT / 2);
    [self.view addSubview:[InfomationTool animationBack]];
    [[InfomationTool animationView] startAnimating];
}

/** 结束等待动画 */
- (void)stopWaitAnimation {
    [[InfomationTool animationBack] removeFromSuperview];
    [[InfomationTool animationView] stopAnimating];
}



@end
