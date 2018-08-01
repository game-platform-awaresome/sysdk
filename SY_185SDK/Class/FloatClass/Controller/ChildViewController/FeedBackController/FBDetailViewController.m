//
//  FBDetailViewController.m
//  SY_185SDK
//
//  Created by 燚 on 2017/12/12.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FBDetailViewController.h"
#import "FeedbackNavigationController.h"
#import "FBAlertController.h"
#import "UserModel.h"
#import "FBServerCell.h"
#import "FBMineCell.h"
//#import "LLRefresh.h"
#import "FFRefreshTableView.h"
//#import "MJRefresh.h"


@interface FBDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIBarButtonItem *leftButton;

@property (nonatomic, strong) NSDictionary *questionDict;
@property (nonatomic, strong) NSMutableArray *questionArray;

@property (nonatomic, strong) FFRefreshTableView *tableView;
@property (nonatomic, strong) UIView *inputeTextView;
@property (nonatomic, strong) UITextField *inputeTextField;

@property (nonatomic, strong) UILabel *tableViewBackGroundLabel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UITextView *descriptionView;

@property (nonatomic, strong) UIBarButtonItem *cancelInpute;


/** 工单 id */
@property (nonatomic, strong) NSString *questionID;
/** 是否加载更多   默认 NO 可以加载更多 */
@property (nonatomic, assign) BOOL isLoadMore;
/** 当前页数 */
@property (nonatomic, assign) NSInteger currentPage;
/** 总共页数 */
@property (nonatomic, strong) NSString *totalPage;




//@property (nonatomic, strong) UIBarButtonItem *rightBUtton;




@end


static FeedbackNavigationController *nav = nil;
static FBDetailViewController *controller = nil;
@implementation FBDetailViewController

+ (FeedbackNavigationController *)showDetail {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (controller == nil) {
            controller = [FBDetailViewController new];
        }
        nav = [[FeedbackNavigationController alloc] initWithRootViewController:controller];
    });
    return nav;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShowWithNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHideWithNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyboardWillShowWithNotification:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSNumber * duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat time = [duration floatValue];

    self.navigationItem.rightBarButtonItem = self.cancelInpute;
    if (self.inputeTextField.isFirstResponder) {
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.tableView.frame = CGRectMake(10, CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10, WIDTH - 20, HEIGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame) - 54 - keyboardSize.height);
            self.inputeTextView.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), WIDTH, 44);
            [self setTableViweContentSet];
        } completion:^(BOOL finished) {

        }];
    }
}

- (void)keyboardWillHideWithNotification:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSNumber * duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat time = [duration floatValue];

    if (self.inputeTextField.isFirstResponder) {
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.tableView.frame = CGRectMake(10, HEIGHT / 2, WIDTH - 20, HEIGHT / 2 - 44);
            self.inputeTextView.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), WIDTH, 44);
        } completion:^(BOOL finished) {

        }];
    }

    self.navigationItem.rightBarButtonItem = nil;
}


+ (void)setDict:(NSDictionary *)dict {
    if (controller == nil) {
        controller = [FBDetailViewController new];
    }
    controller.dict = dict;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
//    self.view.backgroundColor = FBBackGroundColor;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"问题详情";
    self.navigationItem.leftBarButtonItem = self.leftButton;
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.typeLabel];
    [self.view addSubview:self.descriptionLabel];
    [self.view addSubview:self.descriptionView];
    [self.view addSubview:self.tableView];
//    self.navigationItem.rightBarButtonItem = self.rightBUtton;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
#pragma mark - frame

    self.titleLabel.frame = CGRectMake(10, kNAVGATION_HEIGHT + 10, WIDTH - 20, 30);
    self.typeLabel.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 3, WIDTH - 20, 30);
    self.descriptionLabel.frame = CGRectMake(10, CGRectGetMaxY(self.typeLabel.frame) + 3, WIDTH - 20, 30);
    self.descriptionView.frame = CGRectMake(10, CGRectGetMaxY(self.descriptionLabel.frame) + 5, WIDTH - 20, HEIGHT / 2 - CGRectGetMaxY(self.descriptionLabel.frame) - 10);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputeTextField resignFirstResponder];
}

#pragma mark - responds
- (void)respondsToLeftButton {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)respondsToRepateButton {
    [UserModel FeedBackAddCommentWith:self.inputeTextField.text QuestionID:self.dict[@"id"] Completion:^(NSDictionary *content, BOOL success) {
        syLog(@"评论==== %@",content);
        if (success) {
//            [self.inputeTextField resignFirstResponder];
            self.inputeTextField.text = @"";
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [self refresData];
        } else {
            [self showAlertMessage:content[@"msg"] dismissTime:0.5 dismiss:nil];
        }
    }];
}

- (void)respondsToCancelInputeButton {
    [self.inputeTextField resignFirstResponder];
}

- (void)respondsToRightButton {
    [self loadMoreData];
}

- (void)refresData {
    _currentPage = 1;
    [self startWaitAnimation];

    [UserModel FeedBackDetailWithQuestionID:self.questionID Page:[NSString stringWithFormat:@"%ld",(long)_currentPage] Completion:^(NSDictionary *content, BOOL success) {

        [self stopWaitAnimation];
        self.totalPage = SDK_CONTENT_DATA[@"question_list"][@"count"];
        if (self.totalPage.integerValue <= _currentPage) {
            self.isLoadMore = YES;
        } else {
            self.isLoadMore = NO;
        }


        if (success) {
            self.questionDict = SDK_CONTENT_DATA[@"question"];
            self.questionArray = [SDK_CONTENT_DATA[@"question_list"][@"list"] mutableCopy];
        } else {
            self.isLoadMore = YES;
            self.questionArray = nil;
        }

        if (self.questionArray.count < 1) {
            if (_canEdit) {
                self.tableViewBackGroundLabel.text = @"点击下方按钮,可以补充问题\n或者给客服留言";
            } else {
                self.tableViewBackGroundLabel.text = @"留言已关闭";
            }
            self.tableView.backgroundView = self.tableViewBackGroundLabel;
        } else {
            self.tableView.backgroundView = nil;
        }
        [self.tableView reloadData];
        [self setTableViweContentSet];
        syLog(@"contetnt === %@",content);
    }];
}

- (void)loadMoreData {
    if (self.isLoadMore) {
//        [self.tableView.mj_header endRefreshing];
        [self.tableView.LLRefreshHeader LL_EndRefresh];
        return;
    }

    _currentPage++;

    [UserModel FeedBackDetailWithQuestionID:self.questionID Page:[NSString stringWithFormat:@"%ld",(long)_currentPage] Completion:^(NSDictionary *content, BOOL success) {
        [self stopWaitAnimation];

        self.totalPage = SDK_CONTENT_DATA[@"question_list"][@"count"];
        if (success) {
            NSArray *array = SDK_CONTENT_DATA[@"question_list"][@"list"];
            NSInteger count = array.count;
            if (array.count > 0) {
                [self.questionArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count  inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            } else {
                self.isLoadMore = YES;
            }

            if (self.totalPage.integerValue <= _currentPage) {
                self.isLoadMore = YES;
            } else {
                self.isLoadMore = NO;
            }
        } else {
            self.isLoadMore = YES;
        }

//        [self.tableView.mj_header endRefreshing];
        [self.tableView.LLRefreshHeader LL_EndRefresh];
        syLog(@"contetnt === %@",content);
    }];
}

#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    syLog(@"dict ====== %@",dict);
    [self setTitleLabelText:dict[@"title"]];
    self.questionID = dict[@"id"];
    self.questionArray = nil;
    [self refresData];
}

- (void)setTitleLabelText:(NSString *)string {
    self.titleLabel.text = [NSString stringWithFormat:@"  标题 : %@",string];
}

- (void)setTypeLabelText:(NSString *)string {
    self.typeLabel.text = [NSString stringWithFormat:@"  类型 : %@",string];
}

- (void)setDescriptionText:(NSString *)string {
    self.descriptionView.text = [NSString stringWithFormat:@"%@",string];
}

- (void)setQuestionDict:(NSDictionary *)questionDict {
    _questionDict = questionDict;
    [self setTitleLabelText:questionDict[@"title"]];
    [self setTypeLabelText:questionDict[@"type"]];
    [self setDescriptionText:questionDict[@"desc"]];
}

- (void)setTableViweContentSet {
    if (self.questionArray.count > 1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.questionArray.count - 1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

+ (void)setCaneEdit:(BOOL)canEdit {
    if (controller == nil) {
        controller = [FBDetailViewController new];
    }
    controller.canEdit = canEdit;
}

- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;
    if (_canEdit) {
        [self.view addSubview:self.inputeTextView];
    } else {
        [self.inputeTextView removeFromSuperview];
    }
}

#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.questionArray.count < 1) {
        return nil;
    }
    NSDictionary *dict = self.questionArray[self.questionArray.count - indexPath.row - 1];

    UITableViewCell *cell = nil;
    if ([dict[@"type"] isEqualToString:@"1"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FBMineCell"];
        [(FBMineCell *)cell setTextString:dict[@"comment"]];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FBServerCell"];
        [(FBServerCell *)cell setTextString:dict[@"comment"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.questionArray[self.questionArray.count - indexPath.row - 1];
    NSString *textString = dict[@"comment"];
    CGSize size = [textString boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;

    return (size.height + 50);
}

#pragma mark - getter
- (UIBarButtonItem *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIBarButtonItem alloc] initWithTitle:@"<<返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
    }
    return _leftButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kNAVGATION_HEIGHT, WIDTH - 20, 30)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.layer.cornerRadius = 8;
        _titleLabel.layer.masksToBounds = YES;
//        _titleLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _titleLabel.layer.borderWidth = 1;
        
    }
    return _titleLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 3, WIDTH - 20, 30)];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.backgroundColor = [UIColor whiteColor];
        _typeLabel.layer.cornerRadius = 8;
        _typeLabel.layer.masksToBounds = YES;
//        _typeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _typeLabel.layer.borderWidth = 1;
    }
    return _typeLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.typeLabel.frame) + 3, WIDTH - 20, 30)];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLabel.backgroundColor = [UIColor whiteColor];
        _descriptionLabel.layer.cornerRadius = 8;
        _descriptionLabel.layer.masksToBounds = YES;
        _descriptionLabel.text = @"  详情 : ";
    }
    return _descriptionLabel;
}

- (UITextView *)descriptionView {
    if (!_descriptionView) {
        _descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.descriptionLabel.frame) + 5, WIDTH - 20, HEIGHT / 2 - CGRectGetMaxY(self.descriptionLabel.frame) - 10)];
//        _descriptionView.userInteractionEnabled = NO;
        _descriptionView.layer.cornerRadius = 4;
        _descriptionView.layer.masksToBounds = YES;
        _descriptionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _descriptionView.layer.borderWidth = 1;
        _descriptionView.font = [UIFont systemFontOfSize:16];
        _descriptionView.editable = NO;
    }
    return _descriptionView;
}

- (FFRefreshTableView *)tableView {
    if (!_tableView) {
        _tableView = [[FFRefreshTableView alloc] initWithFrame:CGRectMake(10, HEIGHT / 2, WIDTH - 20, HEIGHT / 2 - 44) style:(UITableViewStylePlain)];

        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToCancelInputeButton)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_tableView addGestureRecognizer:tap];

        _tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _tableView.layer.borderWidth = 1;
        _tableView.layer.cornerRadius = 4;
        _tableView.layer.masksToBounds = YES;

        [_tableView registerClass:[FBMineCell class] forCellReuseIdentifier:@"FBMineCell"];
        [_tableView registerClass:[FBServerCell class] forCellReuseIdentifier:@"FBServerCell"];

        _tableView.estimatedRowHeight = 80;
        _tableView.rowHeight = UITableViewAutomaticDimension;

        _tableView.LLRefreshHeader = [LLRefreshHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UILabel *)tableViewBackGroundLabel {
    if (!_tableViewBackGroundLabel) {
        _tableViewBackGroundLabel = [[UILabel alloc] initWithFrame:self.tableView.bounds];
        _tableViewBackGroundLabel.textAlignment = NSTextAlignmentCenter;
        _tableViewBackGroundLabel.text = @"点击下方按钮,可以补充问题\n或者给客服留言";
        _tableViewBackGroundLabel.textColor = [UIColor redColor];
        _tableViewBackGroundLabel.numberOfLines = 0;
    }
    return _tableViewBackGroundLabel;
}

- (NSMutableArray *)questionArray {
    if (!_questionArray) {
        _questionArray = [NSMutableArray array];
    }
    return _questionArray;
}

- (UIView *)inputeTextView {
    if (!_inputeTextView) {
        _inputeTextView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), WIDTH, 44)];
        _inputeTextField.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
        [_inputeTextView addSubview:self.inputeTextField];

        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(WIDTH * 0.82, 0, WIDTH * 0.18, 44);
        [button setTitle:@"提交" forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(respondsToRepateButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_inputeTextView addSubview:button];
    }
    return _inputeTextView;
}

- (UITextField *)inputeTextField {
    if (!_inputeTextField) {
        _inputeTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, WIDTH * 0.8, 30)];
        _inputeTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _inputeTextField;
}

- (UIBarButtonItem *)cancelInpute {
    if (!_cancelInpute) {
        _cancelInpute = [[UIBarButtonItem alloc] initWithTitle:@"收起键盘" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToCancelInputeButton)];
    }
    return _cancelInpute;
}

//- (UIBarButtonItem *)rightBUtton {
//    if (!_rightBUtton) {
//        _rightBUtton = [[UIBarButtonItem alloc] initWithTitle:@"加载更多" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightButton)];
//    }
//    return _rightBUtton;
//}

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
