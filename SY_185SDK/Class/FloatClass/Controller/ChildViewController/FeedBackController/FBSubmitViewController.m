//
//  FBSubmitViewController.m
//  SY_185SDK
//
//  Created by 燚 on 2017/12/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FBSubmitViewController.h"
#import "FeedbackNavigationController.h"
#import "UserModel.h"
#import "FBAlertController.h"
#import "LLRefresh.h"


@interface FBSubmitViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>


@property (nonatomic, strong) UIBarButtonItem *leftButton;

@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UILabel *textTitle;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UILabel *textTitle2;
@property (nonatomic, strong) UITextField *textField2;


@property (nonatomic, strong) UILabel *remindLabel2;
@property (nonatomic, strong) UITableView *selectView;
@property (nonatomic, strong) NSArray *showArray;
@property (nonatomic, assign) NSInteger selectIndex;


@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger pickerIndex;

@property (nonatomic, strong) UILabel *remindLabel3;

@property (nonatomic, strong) UITextView *inputeTextView;
@property (nonatomic, strong) UIBarButtonItem *cancelInpute;

@property (nonatomic, strong) UIButton *submitButton;

@end




static FeedbackNavigationController *controller = nil;
static FBSubmitViewController *submint = nil;

@implementation FBSubmitViewController

+ (FeedbackNavigationController *)showSubmit {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        submint = [[FBSubmitViewController alloc] init];
        controller = [[FeedbackNavigationController alloc] initWithRootViewController:submint];
    });
    return controller;
}

- (instancetype)init
{
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
    if (self.inputeTextView.isFirstResponder) {
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.inputeTextView.frame = CGRectMake(10, kNAVGATION_HEIGHT + 10, WIDTH - 20, HEIGHT - kNAVGATION_HEIGHT - keyboardSize.height - 20);
        } completion:^(BOOL finished) {

        }];
    }
}

- (void)keyboardWillHideWithNotification:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSNumber * duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat time = [duration floatValue];

    if (self.inputeTextView.isFirstResponder) {
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.inputeTextView.frame = CGRectMake(10, HEIGHT / 2 + 40, WIDTH - 20, HEIGHT / 2 - 110);
        } completion:^(BOOL finished) {

        }];
    }

    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _pickerIndex = 1;
    [self.pickerView selectRow:0 inComponent:1 animated:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.navigationItem.title = @"提交反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.leftButton;

    [self.view addSubview:self.remindLabel];
    [self.view addSubview:self.textTitle];
    [self.view addSubview:self.textField];

    [self.view addSubview:self.textTitle2];
    [self.view addSubview:self.textField2];

//    [self.view addSubview:self.remindLabel2];
//    [self.view addSubview:self.selectView];
    [self.view addSubview:self.pickerView];

    [self.view addSubview:self.remindLabel3];
    [self.view addSubview:self.inputeTextView];

    [self.view addSubview:self.submitButton];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.remindLabel.frame = CGRectMake(0, kNAVGATION_HEIGHT + 10, WIDTH, 20);
    self.textTitle.center = CGPointMake(10 + _textTitle.bounds.size.width / 2, CGRectGetMaxY(self.remindLabel.frame) + 30);
    self.textField.frame = CGRectMake(CGRectGetMaxX(self.textTitle.frame) + 8, CGRectGetMaxY(self.remindLabel.frame) + 8, WIDTH - CGRectGetMaxX(self.textTitle.frame) - 18, 44);

//    BOOL showTextField2 = YES;
    BOOL showTextField2 = [UserModel currentUser].question_contract_enabled.boolValue;
    if (showTextField2) {
        [self.textTitle2 sizeToFit];
        self.textField2.frame = CGRectMake(CGRectGetMaxX(self.textTitle2.frame) + 8, CGRectGetMaxY(self.textField.frame) + 8, WIDTH - CGRectGetMaxX(self.textTitle2.frame) - 18, 44);
        self.textTitle2.center = CGPointMake(10 + self.textTitle2.bounds.size.width / 2, CGRectGetMaxY(self.textField.frame) + 30);
        self.pickerView.frame = CGRectMake(10, CGRectGetMaxY(self.textField2.frame) + 8, WIDTH - 20, HEIGHT / 2 - CGRectGetMaxY(self.textField2.frame) - 10);
        self.textField2.hidden = NO;
    } else {
        self.pickerView.frame = CGRectMake(10, CGRectGetMaxY(self.textField.frame) + 8, WIDTH - 20, HEIGHT / 2 - CGRectGetMaxY(self.textField.frame) - 10);
        self.textTitle2.frame = CGRectZero;
        self.textField2.frame = CGRectMake(0, 0, 0, 0);
        self.textField2.hidden = YES;
    }

}


#pragma makr - responds
- (void)respondsToLeftButton {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)respondsToCancelInputeButton {
    [self.inputeTextView resignFirstResponder];
    [self.textField resignFirstResponder];
    [self.textField2 resignFirstResponder];
}

- (void)respondsToSubmitButton {

    if (self.textField.text.length == 0) {
        [self showAlertMessage:@"标题不能为空" dismissTime:0.7 dismiss:nil];
        return;
    }

//    if (self.textField2.text.length == 0) {
//        [self showAlertMessage:@"联系方式不能为空" dismissTime:0.7 dismiss:nil];
//        return;
//    }

    if (self.inputeTextView.text.length == 0) {
        [self showAlertMessage:@"问题描述不能为空" dismissTime:0.7 dismiss:nil];
        return;
    }


    syLog(@"select index === %ld",(long)_pickerIndex);
    [self startWaitAnimation];
    [UserModel FeedBackSubmitWithTitle:self.textField.text Type:[NSString stringWithFormat:@"%ld",(long)_pickerIndex] Description:self.inputeTextView.text Contract:self.textField2.text Completion:^(NSDictionary *content, BOOL success) {
        [self stopWaitAnimation];
        if (success) {
            [self showAlertMessage:@"提交成功" dismissTime:0.7 dismiss:^{
                self.textField.text = @"";
                self.textField2.text = @"";
                self.inputeTextView.text = @"";
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            [self showAlertMessage:content[@"msg"] dismissTime:0.7 dismiss:nil];
        }
    }];
}

#pragma mark - textfield delegate
//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.textField) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.textField.text.length >= 15) {
            self.textField.text = [textField.text substringToIndex:15];
            return NO;
        }
    } else if (textField == self.textField2) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.textField2.text.length >= 11) {
            self.textField2.text = [textField.text substringToIndex:11];
            return NO;
        }
    }

    return YES;
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"submitCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"submitCell"];
    }

    cell.textLabel.text = self.showArray[indexPath.row];

    if (indexPath.row == _selectIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectIndex = indexPath.row;
    [tableView reloadData];
    self.remindLabel2.text = [NSString stringWithFormat:@"选择问题:%@",self.showArray[indexPath.row]];
}

#pragma mark - picker view data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0 ) {
        return 1;
    } else {
        return self.showArray.count;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 1) {
        _pickerIndex = row + 1;
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {

    NSString *titleString = nil;
    if (component == 0) {
        titleString = @"选择问题:";
    } else {
        titleString = self.showArray[row];
    }

    if (self.showArray) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:titleString];
        NSRange range = [titleString rangeOfString:titleString];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];

        return attributedString;
    } else {
        return nil;
    }

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return nil;
}

#pragma mark - setter
+ (void)setLimitNumber:(NSString *)limitNumber {
    submint.remindLabel.text = [NSString stringWithFormat:@"      每个玩家每天最多提交%@次工单",limitNumber];
}

+ (void)setSelectType:(NSArray *)selectType {
    NSMutableArray *addArray = [NSMutableArray arrayWithCapacity:selectType.count];
    [selectType enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [addArray addObject:obj[@"name"]];
    }];
    submint.showArray = [addArray copy];
    [submint.pickerView reloadAllComponents];
}


#pragma mark - getter
- (UIBarButtonItem *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIBarButtonItem alloc] initWithTitle:@"<<返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
    }
    return _leftButton;
}

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kNAVGATION_HEIGHT, WIDTH, 20)];
        _remindLabel.textColor = [UIColor redColor];
        _remindLabel.font = [UIFont systemFontOfSize:14];
        _remindLabel.text = @"      每个玩家每天最多提交3次工单";
    }
    return _remindLabel;
}

- (UILabel *)textTitle {
    if (!_textTitle) {
        _textTitle = [[UILabel alloc] init];
        _textTitle.text = @"标题:";
        _textTitle.font = [UIFont systemFontOfSize:20];
        _textTitle.textAlignment = NSTextAlignmentCenter;
        [_textTitle sizeToFit];
        _textTitle.center = CGPointMake(10 + _textTitle.bounds.size.width / 2, CGRectGetMaxY(self.remindLabel.frame) + 30);
    }
    return _textTitle;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.textTitle.frame) + 8, CGRectGetMaxY(self.remindLabel.frame) + 8, WIDTH - CGRectGetMaxX(self.textTitle.frame) - 18, 44)];
        _textField.placeholder = @"在这里输入标题, 最多15个字";
        _textField.delegate = self;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _textField;
}

- (UILabel *)textTitle2 {
    if (!_textTitle2) {
        _textTitle2 = [[UILabel alloc] init];
        _textTitle2.text = @"联系方式:";
        _textTitle2.font = [UIFont systemFontOfSize:20];
        _textTitle2.textAlignment = NSTextAlignmentCenter;
        [_textTitle2 sizeToFit];
        _textTitle2.center = CGPointMake(10 + _textTitle2.bounds.size.width / 2, CGRectGetMaxY(self.textField.frame) + 30);
    }
    return _textTitle2;
}

- (UITextField *)textField2 {
    if (!_textField2) {
        _textField2 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.textTitle2.frame) + 8, CGRectGetMaxY(self.textField.frame) + 8, WIDTH - CGRectGetMaxX(self.textTitle2.frame) - 18, 44)];
        _textField2.placeholder = @"QQ或电话";
        _textField2.delegate = self;
        _textField2.borderStyle = UITextBorderStyleRoundedRect;
        _textField2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return _textField2;
}


//- (UITableView *)selectView {
//    if (!_selectView) {
//        _selectView = [[UITableView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.textField2.frame) + 8, WIDTH - 20, HEIGHT / 2 - CGRectGetMaxY(self.textField2.frame)) style:(UITableViewStylePlain)];
//
//        _selectView.layer.cornerRadius = 8;
//        _selectView.layer.masksToBounds = YES;
//        _selectView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _selectView.layer.borderWidth = 2;
//
//        _selectView.delegate = self;
//        _selectView.dataSource = self;
//
//    }
//    return _selectView;
//}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];

        _pickerView.delegate = self;
        _pickerView.dataSource = self;

        _pickerView.layer.cornerRadius = 4;
        _pickerView.layer.masksToBounds = YES;
        _pickerView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        _pickerView.layer.borderWidth = 1;
    }
    return _pickerView;
}

- (UILabel *)remindLabel3 {
    if (!_remindLabel3) {
        _remindLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, HEIGHT / 2, WIDTH - 20, 30)];
        _remindLabel3.text = @"问题描述 :";
        _remindLabel3.textColor = [UIColor lightGrayColor];
    }
    return _remindLabel3;
}

- (UITextView *)inputeTextView {
    if (!_inputeTextView) {
        _inputeTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, HEIGHT / 2 + 40, WIDTH - 20, HEIGHT / 2 - 110)];
        _inputeTextView.layer.cornerRadius = 4;
        _inputeTextView.layer.masksToBounds = YES;
        _inputeTextView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        _inputeTextView.layer.borderWidth = 1;
        _inputeTextView.font = [UIFont systemFontOfSize:16];
    }
    return _inputeTextView;
}

- (UIBarButtonItem *)cancelInpute {
    if (!_cancelInpute) {
        _cancelInpute = [[UIBarButtonItem alloc] initWithTitle:@"收起键盘" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToCancelInputeButton)];
    }
    return _cancelInpute;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _submitButton.bounds = CGRectMake(0, 0, WIDTH * 0.8, 44);
        _submitButton.center = CGPointMake(WIDTH / 2, HEIGHT - 35);
        [_submitButton setTitle:@"提交" forState:(UIControlStateNormal)];
        [_submitButton setBackgroundColor:BUTTON_GREEN_COLOR];
        _submitButton.layer.cornerRadius = 8;
        _submitButton.layer.masksToBounds = YES;
        [_submitButton addTarget:self action:@selector(respondsToSubmitButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _submitButton;
}

- (NSArray *)showArray {
    if (!_showArray) {
        _showArray = @[@"不能支付",@"游戏闪退",@"游戏回档",@"支付不到账",@"角色数据丢失",@"游戏登录问题",@"其他问题"];
    }
    return _showArray;
}


- (void)showAlertMessage:(NSString *)message dismissTime:(float)second dismiss:(void (^)(void))dismiss  {

    FBAlertController *alertController = [FBAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];

    [self presentViewController:alertController animated:NO completion:nil];

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





















