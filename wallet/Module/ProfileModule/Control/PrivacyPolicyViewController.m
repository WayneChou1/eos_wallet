//
//  PrivacyPolicyViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/9/4.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()

@property (strong, nonatomic) UITextView *tv;

@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpSubView {
    self.tv = [[UITextView alloc] init];
    self.tv.font = kSys_font(13);
    self.tv.textColor = kDark_Text_Color;
    self.tv.editable = NO;
    [self.view addSubview:self.tv];
    
    [self.tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    self.tv.text = kLocalizable(@"");
}


@end
