//
//  BaseViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/16.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackGroudColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setBackGroudColor {
    // 提供默认背景颜色
    self.view.backgroundColor = kBackgroud_Color;
}

- (CGFloat)getNavBarHeight {
    return kHeight_Statusbar + kHeight_Navigationbar;
}

@end
