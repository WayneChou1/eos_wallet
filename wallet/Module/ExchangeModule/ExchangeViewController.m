//
//  ExchangeViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/16.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "ExchangeViewController.h"
#import "AccountManager.h"

@interface ExchangeViewController ()

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Exchange";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - loadData

- (void)loadData {
    
    NSArray <Account *> *account = [[AccountManager shareManager] selectAllAccounts];
    
    for (Account *a in account) {
        NSString *url = eosmonitor(a.accountName, eos_get_transfer, @"1", @"20");
        wLog(@"eos_get_transfer == %@",url);
        [[HTTPRequestManager shareMonitorManager] get:url paramters:nil success:^(BOOL isSuccess, id responseObject) {
            
        } failure:^(NSError *failure) {
            
        }];
    }
}


#pragma mark - setUpSubViews

- (void)setUpSubViews {
    self.tableView.tableFooterView = [UIView new];
}

@end
