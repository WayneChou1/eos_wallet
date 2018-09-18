//
//  FaqViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/9/17.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "FaqViewController.h"

@interface FaqViewController ()

@property (weak, nonatomic) IBOutlet UILabel *helpLab;

@end

@implementation FaqViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"Faq");
    self.helpLab.text = kLocalizable(@"如果你在使用过程中遇到了任何问题，请通过以下方式联系方式联系我们");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
