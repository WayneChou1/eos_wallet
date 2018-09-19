//
//  TelegramContactViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/9/19.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "TelegramContactViewController.h"
#import <WebKit/WebKit.h>

static NSString * const telegramPath = @"https://t.me/joinchat/J2Q_rxI1kDeTyPu9MUn3gQ";

@interface TelegramContactViewController () <WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation TelegramContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"电报群");
    [self setUpSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpSubView {
    self.webView = [[WKWebView alloc] init];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telegramPath]]];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, [self getNavBarHeight], SCREEN_WIDTH, 2)];
    self.progressView.backgroundColor = [UIColor whiteColor];
    self.progressView.trackTintColor = [UIColor whiteColor];
    self.progressView.progressTintColor = kMain_Color;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
}

#pragma mark - navigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    wLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    wLog(@"加载完成");
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    wLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        wLog(@"progress ======== %f",self.webView.estimatedProgress);
        if (self.progressView.progress == 1) {
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                self.progressView.hidden = YES;
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
