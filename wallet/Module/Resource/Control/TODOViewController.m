//
//  TODOViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/9/10.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "TODOViewController.h"

@interface TODOViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation TODOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lab.text = kLocalizable(@"开发中，敬请期待");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
