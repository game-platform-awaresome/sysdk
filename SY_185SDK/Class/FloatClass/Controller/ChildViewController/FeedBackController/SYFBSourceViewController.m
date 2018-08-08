//
//  SYFBSourceViewController.m
//  SY_185SDK
//
//  Created by 燚 on 2018/8/6.
//  Copyright © 2018年 185sy.com. All rights reserved.
//

#import "SYFBSourceViewController.h"
#import "Masonry.h"

#define Button_tag 10086

@interface SYFBSourceViewController ()

@property (nonatomic, strong) NSArray<UIButton *>   *stars;

@property (nonatomic, assign) NSUInteger    source;
@property (nonatomic, strong) UIButton      *submitButton;

@property (nonatomic, strong) UIView        *reasonBackView;
@property (nonatomic, strong) UIView        *reasonInputeBack;
@property (nonatomic, strong) UITextView    *reasonTextView;
@property (nonatomic, strong) UIButton      *reasonSubmitButton;


@end



@implementation SYFBSourceViewController

+ (SYFBSourceViewController *)showSourceCongrollerWith:(NSString *)questionID CallBackBlock:(SourceSuccessBlock)block {
    SYFBSourceViewController *controller = [[SYFBSourceViewController alloc] init];
    controller.questionID = questionID;
    controller.block = block;
    return controller;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _source = 0;
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<<返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToBackButton)];
    self.navigationItem.title = @"客服评价";

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    CGSize size = CGSizeMake(30, 30);
    CGRect bouds = CGRectMake(0, 0, size.width, size.height);
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.bounds = bouds;
        button.center = CGPointMake(kSCREEN_WIDTH / 2 - 80 + 40 * i, 100);
        button.tag = Button_tag + i;
        [button setImage:SDK_IMAGE(@"star_empty") forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(respondsToStarButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:button];
        [array addObject:button];
    }

    self.stars = array;

    [self.view addSubview:self.submitButton];


    NSArray *titleArray = @[@"1星评价 : 服务极差(客服长时间未处理问题,态度恶劣)",
                            @"2星评价 : 服务较差(客服处理问题不及时,答非所问)",
                            @"3星评价 : 服务一般(客服处理问题速度一般,勉强知道问题结果)",
                            @"4星评价 : 服务良好(客服处理问题速度较快,认真跟进,能良好的解决问题)",
                            @"5星评价 : 服务极好(客服处理问题速度很快,详细解释原因,用语规范)"];

    UILabel *lastLabel;
    for (int i = 0; i < 5; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, kSCREEN_WIDTH - 20, 20)];
        if (lastLabel) {
            label.frame = CGRectMake(10, CGRectGetMaxY(lastLabel.frame) + 5, kSCREEN_WIDTH - 20, 20);
        }
        label.numberOfLines = 0;
        label.text = titleArray[i];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:label];
        [label sizeToFit];
        lastLabel = label;
    }

}

#pragma mark - responds
- (void)respondsToBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)respondsToStarButton:(UIButton *)sender {
    NSInteger i = sender.tag - Button_tag;
    _source = i + 1;
    int j = 0;
    if (self.questionID == nil) {
        [self showAlertMessage:@"工单 ID 出错" dismissTime:0.7 dismiss:^{
            [self respondsToBackButton];
        }];
        return;
    }
    for (; j <= i; j++) {
        [self.stars[j] setImage:SDK_IMAGE(@"star_full") forState:(UIControlStateNormal)];
    }

    for (; j < self.stars.count; j++) {
        [self.stars[j] setImage:SDK_IMAGE(@"star_empty") forState:UIControlStateNormal];
    }
}

- (void)respondsToSubmitButton {
    syLog(@"提交工单");
    if (_source == 0) {
        [self showAlertMessage:@"请评分." dismissTime:0.7 dismiss:nil];
        return;
    }

    if (_source < 3) {
        [self showReasonView];
    } else {
        [self sendRate];
    }
}

- (void)sendRate {
    [self.reasonTextView resignFirstResponder];
    [self startAnimation];
    [UserModel CustomerServiceEvaluationWithQuestionID:self.questionID Rate:[NSString stringWithFormat:@"%lu",(unsigned long)self.source] Reason:self.reasonTextView.text ?: nil  Completion:^(NSDictionary *content, BOOL success) {
        [self stopAnimation];
        if (success) {
            [self.reasonBackView removeFromSuperview];
            if (self.block) {
                self.block();
            }
            [self showAlertMessage:@"评价成功" dismissTime:0.7 dismiss:^{
                [self respondsToBackButton];
            }];
        } else{
            [self showAlertMessage:content[@"msg"] dismissTime:0.7 dismiss:^{

            }];
        }
    }];
}

- (void)showReasonView {
    [self.view addSubview:self.reasonBackView];

    [self.reasonBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.view.bounds.size);
        make.center.mas_equalTo(CGPointZero);
    }];
}


#pragma mark - getter
- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_submitButton addTarget:self action:@selector(respondsToSubmitButton) forControlEvents:(UIControlEventTouchUpInside)];
        _submitButton.layer.cornerRadius = 22;
        _submitButton.layer.masksToBounds = YES;
        [_submitButton setBackgroundColor:BUTTON_GREEN_COLOR];
        [_submitButton setTitle:@"提交评价" forState:(UIControlStateNormal)];
        _submitButton.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.6, 44);
        _submitButton.center = CGPointMake(kSCREEN_WIDTH / 2, 160);
    }
    return _submitButton;
}

- (UIView *)reasonBackView {
    if (!_reasonBackView) {
        _reasonBackView = [[UIView alloc] init];
        _reasonBackView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];

        [_reasonBackView addSubview:self.reasonInputeBack];
        [self.reasonInputeBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_reasonBackView).offset(100);
            make.left.mas_equalTo(_reasonBackView).offset(10);
            make.right.mas_equalTo(_reasonBackView).offset(-10);
            make.height.mas_equalTo(260);
        }];
    }
    return _reasonBackView;
}

- (UIView *)reasonInputeBack {
    if (!_reasonInputeBack) {

        _reasonInputeBack = [[UIView alloc] init];
        _reasonInputeBack.backgroundColor = [UIColor whiteColor];
        _reasonInputeBack.layer.cornerRadius = 8;
        _reasonInputeBack.layer.masksToBounds = YES;

        UILabel *reasonLabel = [UILabel new];
        reasonLabel.text = @"因为您对客服本次服务评级较低,为了以后能给您提供更好的服务,希望您能说明本次服务差评原因.";
        reasonLabel.textColor = BUTTON_GREEN_COLOR;
        reasonLabel.numberOfLines = 0;
        reasonLabel.font = [UIFont boldSystemFontOfSize:14];

        [_reasonInputeBack addSubview:reasonLabel];
        [reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_reasonInputeBack).offset(10);
            make.left.mas_equalTo(_reasonInputeBack).offset(10);
            make.right.mas_equalTo(_reasonInputeBack).offset(-10);
        }];

        [reasonLabel sizeToFit];

        [_reasonInputeBack addSubview:self.reasonTextView];
        [self.reasonTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(reasonLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(_reasonInputeBack).offset(10);
            make.right.mas_equalTo(_reasonInputeBack).offset(-10);
            make.bottom.mas_equalTo(_reasonInputeBack).offset(-64);
        }];

        [_reasonInputeBack addSubview:self.reasonSubmitButton];
        [self.reasonSubmitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.reasonTextView.mas_bottom).offset(5);
            make.left.mas_equalTo(_reasonInputeBack).offset(10);
            make.right.mas_equalTo(_reasonInputeBack).offset(-10);
            make.bottom.mas_equalTo(_reasonInputeBack).offset(-10);
        }];
    }
    return _reasonInputeBack;
}

- (UITextView *)reasonTextView {
    if (!_reasonTextView) {
        _reasonTextView = [[UITextView alloc] init];
        _reasonTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _reasonTextView.layer.borderWidth = 1;
        _reasonTextView.layer.cornerRadius = 8;
        _reasonTextView.layer.masksToBounds = YES;
        _reasonTextView.font = [UIFont systemFontOfSize:17];
    }
    return _reasonTextView;
}

- (UIButton *)reasonSubmitButton {
    if (!_reasonSubmitButton) {
        _reasonSubmitButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_reasonSubmitButton addTarget:self action:@selector(sendRate) forControlEvents:(UIControlEventTouchUpInside)];
        [_reasonSubmitButton setTitle:@"提交评价" forState:(UIControlStateNormal)];
        [_reasonSubmitButton setBackgroundColor:BUTTON_GREEN_COLOR];
        _reasonSubmitButton.layer.cornerRadius = 8;
        _reasonSubmitButton.layer.masksToBounds = YES;
    }
    return _reasonSubmitButton;
}



@end








