//
//  SY_AccountListView.m
//  SY_185SDK
//
//  Created by 燚 on 2018/7/6.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "SY_AccountListView.h"
#import "UserModel.h"

#define CELL_IDE @"SY_accountCell"


@protocol SY_AccountCellDelegate <NSObject>

- (void)didLoginGame:(NSString *)index;

- (void)didNickName:(NSString *)index;



@end



@interface SY_accountCell : UITableViewCell


@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) NSString *index;

@property (nonatomic, weak) id<SY_AccountCellDelegate> delegate;

@end



@interface SY_AccountListView () <UITableViewDelegate, UITableViewDataSource, SY_AccountCellDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) UIView *inputBackGround;
@property (nonatomic, strong) UITextField *inputTextfiled;
@property (nonatomic, strong) UIButton *inputSureButton;


@property (nonatomic, strong) NSDictionary *currentData;
@property (nonatomic, assign) NSInteger currentIdx;


@end

@implementation SY_AccountListView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backView];
}


#pragma mark - responds
- (void)respondsToCloseButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SY_AccountListView:clickCloseButton:)]) {
        [self.delegate SY_AccountListView:self clickCloseButton:nil];
    }
}

- (void)respondsToInputeSureButton {
    SDK_START_ANIMATION;
    [UserModel editBindUserNickNameWith:self.inputTextfiled.text UserName:self.currentData[@"sdk_username"] completion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;
        if (success) {
            NSMutableDictionary *muDict = [self.currentData mutableCopy];
            [muDict setObject:self.inputTextfiled.text forKey:@"nick_name"];
            [self.showArray replaceObjectAtIndex:(self.currentIdx) withObject:muDict];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.currentIdx) inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
        } else {
            [InfomationTool showAlertMessage:content[@"msg"] dismissTime:1 dismiss:nil];
        }
        [self.inputBackGround removeFromSuperview];
    }];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SY_accountCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.index = [NSString stringWithFormat:@"%ld",(indexPath.row + 1)];
    cell.dict = self.showArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - cell delegate
- (void)didLoginGame:(NSString *)index {
    syLog(@"进入游戏");

    NSDictionary *dict = self.showArray[index.intValue - 1];
    SDK_START_ANIMATION;
    [UserModel checkSwitchUserWithPhoneNumber:self.phoneNumber Username:[NSString stringWithFormat:@"%@",dict[@"sdk_username"]] Token:self.token completion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;
        if (success) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(SY_AccountListView:Login:)]) {
                [self.delegate SY_AccountListView:self Login:content];
            }
        } else {
            [InfomationTool showAlertMessage:content[@"msg"] dismissTime:1 dismiss:nil];
        }
    }];
}

- (void)didNickName:(NSString *)index {
    syLog(@"修改昵称");
    self.currentIdx = index.integerValue - 1;
    self.currentData = self.showArray[self.currentIdx];
    [self.backView addSubview:self.inputBackGround];
}

//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.inputTextfiled) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.inputTextfiled.text.length >= 6) {
            self.inputTextfiled.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
}


#pragma mark - setter
- (void)setShowArray:(NSArray *)showArray {
    _showArray = [showArray mutableCopy];
    [self.tableView reloadData];
}


#pragma mark - getter
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.bounds = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT);
        _backView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
        _backView.backgroundColor = LOGIN_BACKGROUNDCOLOR;

        _backView.layer.cornerRadius = 8;
        _backView.layer.borderColor = [UIColor grayColor].CGColor;
        _backView.layer.borderWidth = 1.f;
        _backView.layer.masksToBounds = YES;

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT / 7);
        titleLabel.text = @"账号列表";
        titleLabel.textColor = BUTTON_GREEN_COLOR;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:22];
        [_backView addSubview:titleLabel];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, FLOAT_MENU_HEIGHT / 7 + 1, FLOAT_MENU_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
        [_backView addSubview:line];

        [self.backView addSubview:self.closeButton];
        [self.backView addSubview:self.tableView];
    }
    return _backView;
}



- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _closeButton.frame = CGRectMake(FLOAT_MENU_WIDTH - 40, 10, 30, 30);
        [_closeButton setImage:SDK_IMAGE(@"SYSDK_closeButton") forState:(UIControlStateNormal)];
        [_closeButton addTarget:self action:@selector(respondsToCloseButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, FLOAT_MENU_HEIGHT / 7 + 2, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT / 7 * 6 - 2) style:(UITableViewStylePlain)];

        _tableView.delegate = self;
        _tableView.dataSource = self;

        [_tableView registerClass:[SY_accountCell class] forCellReuseIdentifier:CELL_IDE];

        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIView *)inputBackGround {
    if (!_inputBackGround) {
        _inputBackGround = [[UIView alloc] initWithFrame:CGRectMake(0, FLOAT_MENU_HEIGHT / 7 + 2, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT / 7 * 6 - 2)];
        _inputBackGround.backgroundColor = [UIColor whiteColor];
        [_inputBackGround addSubview:self.inputTextfiled];
    }
    return _inputBackGround;
}

- (UITextField *)inputTextfiled {
    if (!_inputTextfiled) {
        _inputTextfiled = [[UITextField alloc] initWithFrame:CGRectMake(8, 8, FLOAT_MENU_WIDTH - 16, 44)];
        _inputTextfiled.rightView = self.inputSureButton;
        _inputTextfiled.rightViewMode = UITextFieldViewModeAlways;
        _inputTextfiled.borderStyle = UITextBorderStyleRoundedRect;
        _inputTextfiled.delegate = self;
    }
    return _inputTextfiled;
}

- (UIButton *)inputSureButton {
    if (!_inputSureButton) {
        _inputSureButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _inputSureButton.bounds = CGRectMake(0, 0, 60, 44);
        [_inputSureButton setTitle:@"完成" forState:(UIControlStateNormal)];
        [_inputSureButton setTitleColor:BLUE_DARK forState:(UIControlStateNormal)];
        [_inputSureButton addTarget:self action:@selector(respondsToInputeSureButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _inputSureButton;
}






@end




@interface SY_accountCell ()

@property (nonatomic, strong) UILabel *AccountLabel;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIButton *nickNameButton;


@end


@implementation SY_accountCell


#pragma mark - responds
- (void)respondsToLoginButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLoginGame:)]) {
        [self.delegate didLoginGame:self.index];
    }
}

- (void)respondsToNickNameButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didNickName:)]) {
        [self.delegate didNickName:self.index];
    }
}

#pragma mark - setter
- (void)setIndex:(NSString *)index {
    _index = index;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.accessoryView = self.loginButton;

    [self setAccount:dict[@"sdk_username"]];
    [self setNickName:dict[@"nick_name"]];
}

- (void)setAccount:(NSString *)account {
    self.AccountLabel.text = [NSString stringWithFormat:@"账号%@: %@",self.index,account];
    [self.AccountLabel sizeToFit];
    self.AccountLabel.center = CGPointMake(self.AccountLabel.bounds.size.width / 2 + 16, self.bounds.size.height / 2);
}

- (void)setNickName:(NSString *)nickName {
    if (nickName && nickName.length > 0) {
    } else {
        nickName = @"点击输入备注";
    }
    [self.nickNameButton setTitle:[NSString stringWithFormat:@"(%@)",nickName] forState:(UIControlStateNormal)];
    [self.nickNameButton sizeToFit];
    self.nickNameButton.center = CGPointMake(CGRectGetMaxX(self.AccountLabel.frame) + self.nickNameButton.bounds.size.width / 2, self.bounds.size.height / 2);
//    CGRectMake(CGRectGetMaxX(self.AccountLabel.frame), 0, FLOAT_MENU_WIDTH - CGRectGetMaxX(self.AccountLabel.frame) - self.loginButton.frame.size.width, self.bounds.size.height);
}

#pragma mark - getter
- (UILabel *)AccountLabel {
    if (!_AccountLabel) {
        _AccountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _AccountLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_AccountLabel];
    }
    return _AccountLabel;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_loginButton setTitle:@"进入游戏>" forState:(UIControlStateNormal)];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_loginButton setTitleColor:BLUE_DARK forState:(UIControlStateNormal)];
        [_loginButton sizeToFit];
        [_loginButton addTarget:self action:@selector(respondsToLoginButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _loginButton;
}

- (UIButton *)nickNameButton {
    if (!_nickNameButton) {
        _nickNameButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_nickNameButton setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:(UIControlStateNormal)];
        _nickNameButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_nickNameButton addTarget:self action:@selector(respondsToNickNameButton) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:self.nickNameButton];
    }
    return _nickNameButton;
}



@end












