//
//  FaqViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/9/17.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "FaqViewController.h"

@interface FaqViewController ()

@end

@implementation FaqViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [super initWithNibName:NSStringFromClass([TODOViewController class]) bundle:[NSBundle mainBundle]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"Faq");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
