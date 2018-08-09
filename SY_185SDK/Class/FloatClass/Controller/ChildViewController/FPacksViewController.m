//
//  FPacksViewController.m
//  SDK185SY
//
//  Created by 石燚 on 2017/6/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FPacksViewController.h"
#import "BTWFloatModel.h"
#import "FPacksCell.h"
#import "SDKModel.h"

#define CELLIDE @"FPACKSCELL"

@interface FPacksViewController ()<UITableViewDelegate,UITableViewDataSource>

/** tableview */
@property (nonatomic, strong) UITableView *tableview;

/** dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;

/** showArray */
@property (nonatomic, strong) NSArray *showArray;

/** 是否已经加载礼包 */
@property (nonatomic, assign) BOOL isLoadPacks;

/** 列表背景视图 */
@property (nonatomic, strong) UIView *tableViewBackground;
@property (nonatomic, strong) UIImageView *tableBacgroundImageView;




@end

@implementation FPacksViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //请求数据
    if (!_isLoadPacks) {
        [self getDataSource];
    }
}

- (void)getDataSource {
    SDK_START_ANIMATION;
    [BTWFloatModel giftListWithCompletion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;
        if (success) {
            self.showArray = SDK_CONTENT_DATA[@"list"];
            self.isLoadPacks = YES;
        } else {
            self.showArray = nil;
        }

        if (self.showArray.count == 0) {
            self.tableBacgroundImageView.image = SDK_IMAGE(@"SDK_NoGift");
        } else {
            self.tableBacgroundImageView.image = SDK_IMAGE(@"");
        }

        [self.tableview reloadData];

    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.frame = CGRectMake(0, 0, FLOAT_MENU_WIDTH, FLOAT_MENU_HEIGHT - (FLOAT_MENU_WIDTH / 4));
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableview];
}

#pragma mark - tableview delegate ande dataSource 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([SDKModel sharedModel].box_url) {
        return self.showArray.count + 1;
    } else {
        return self.showArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:CELLIDE];
    }

    if ([SDKModel sharedModel].box_url) {
        if (indexPath.row == 0) {
            cell.imageView.image = SDK_IMAGE(@"SDK_gift_light");
            cell.textLabel.text = @"测试礼包";
            cell.detailTextLabel.text = @"";
        } else {
            cell.imageView.image = SDK_IMAGE(@"SDK_gift_light");
            cell.textLabel.text = [NSString stringWithFormat:@"%@",self.showArray[indexPath.row - 1][@"pack_name"]];
            NSString *giftcode = [NSString stringWithFormat:@"%@",self.showArray[indexPath.row - 1][@"pack_counts"]];
            if (giftcode.length > 0) {
                cell.detailTextLabel.text = @"已领取";
                cell.detailTextLabel.textColor = BUTTON_GREEN_COLOR;
            } else {
                cell.detailTextLabel.text = @"未领取";
                cell.detailTextLabel.textColor = BUTTON_YELLOW_COLOR;
            }
        }
    } else {
        cell.imageView.image = SDK_IMAGE(@"SDK_gift_light");
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.showArray[indexPath.row][@"pack_name"]];
        NSString *giftcode = [NSString stringWithFormat:@"%@",self.showArray[indexPath.row][@"pack_counts"]];
        if (giftcode.length > 0) {
            cell.detailTextLabel.text = @"已领取";
            cell.detailTextLabel.textColor = BUTTON_GREEN_COLOR;
        } else {
            cell.detailTextLabel.text = @"未领取";
            cell.detailTextLabel.textColor = BUTTON_YELLOW_COLOR;
        }
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([SDKModel sharedModel].box_url) {
        if (indexPath.row == 0 ) {

            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"185game://"]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"185game://"]];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[SDKModel sharedModel].box_url]];
            }

            return;
        }
        NSString *giftcode = [NSString stringWithFormat:@"%@",self.showArray[indexPath.row - 1][@"giftcode"]];
        if (giftcode.length > 0) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:giftcode];
            SDK_MESSAGE(@"已经复制到剪贴板");
        } else {

            [BTWFloatModel getGiftWithGiftID:self.showArray[indexPath.row - 1][@"id"] Completion:^(NSDictionary *content, BOOL success) {

                if (success) {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    [pasteboard setString:[NSString stringWithFormat:@"%@",content[@"giftcode"]]];
                    SDK_MESSAGE(@"已经复制到剪贴板");
                } else {
                    NSString *message = [NSString stringWithFormat:@"%@",content[@"msg"]];
                    SDK_MESSAGE(message);
                }
                [self getDataSource];
            }];

        }
    } else {
        NSString *giftcode = [NSString stringWithFormat:@"%@",self.showArray[indexPath.row][@"giftcode"]];
        if (giftcode.length > 0) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:giftcode];
            SDK_MESSAGE(@"已经复制到剪贴板");
        } else {
            [BTWFloatModel getGiftWithGiftID:self.showArray[indexPath.row][@"id"] Completion:^(NSDictionary *content, BOOL success) {
                if (success) {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    [pasteboard setString:[NSString stringWithFormat:@"%@",content[@"giftcode"]]];
                    SDK_MESSAGE(@"已经复制到剪贴板");
                    [self getDataSource];
                } else {
                    NSString *message = [NSString stringWithFormat:@"%@",content[@"msg"]];
                    SDK_MESSAGE(message);
                }
                [self getDataSource];
            }];
        }

    }


}

#pragma makr - getter
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.showsHorizontalScrollIndicator = NO;
        _tableview.tableFooterView = [UIView new];
        _tableview.backgroundView = self.tableViewBackground;
//        [_tableview registerClass:[FPacksCell class] forCellReuseIdentifier:CELLIDE];
    }
    return _tableview;
}

- (UIView *)tableViewBackground {
    if (!_tableViewBackground) {
        _tableViewBackground = [[UIView alloc] init];
        _tableViewBackground.backgroundColor = [UIColor whiteColor];
        _tableViewBackground.frame = CGRectMake(0, 0, view_width, view_height);
        [_tableViewBackground addSubview:self.tableBacgroundImageView];
    }
    return _tableViewBackground;
}

- (UIImageView *)tableBacgroundImageView {
    if (!_tableBacgroundImageView) {
        _tableBacgroundImageView = [[UIImageView alloc] init];
        _tableBacgroundImageView.center = CGPointMake(self.tableViewBackground.center.x, self.tableViewBackground.center.y);
        _tableBacgroundImageView.bounds = CGRectMake(0, 0, 70.5, 93.5);
//        _tableBacgroundImageView.backgroundColor = [UIColor orangeColor];
    }
    return _tableBacgroundImageView;
}

#pragma mark - setter -> view frame
- (void)setViewFrame:(CGRect)viewFrame {
    self.view.frame = viewFrame;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
