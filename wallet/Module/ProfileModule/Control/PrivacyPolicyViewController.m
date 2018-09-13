//
//  PrivacyPolicyViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/9/4.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "PrivacyPolicyViewController.h"
#import <WebKit/WebKit.h>

@interface PrivacyPolicyViewController ()

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"隐私条款");
    [self setUpSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpSubView {
    self.webView = [[WKWebView alloc] init];
    [self.view addSubview:self.webView];
    
    // 配置路径
    NSString *path;
    
    // 本地语言
    NSString *language = [[LocalizedHelper standardHelper] currentLanguage];
    if ([language isEqualToString:kZh_Hans]) {
        path = [[NSBundle mainBundle] pathForResource:@"PrivacyPolicyChinese.html" ofType:nil];
    }else if ([language isEqualToString:kEn]){
        path = [[NSBundle mainBundle] pathForResource:@"PrivacyPolicyEnglish.html" ofType:nil];
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}


@end
