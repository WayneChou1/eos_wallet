//
//  ExchangeViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/16.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "ExchangeViewController.h"
#import "ExchangeDetailViewController.h"
#import "ExchangeCell.h"
#import "AccountManager.h"
#import "Exchange.h"
#import "Exchange_2.h"

@interface ExchangeViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"交易");
    [self setUpTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    [self setNav];
}

- (void)setNav {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.subviews.firstObject.alpha = 1;
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                 kLight_Text_Color, NSForegroundColorAttributeName, [UIFont systemFontOfSize:17], NSFontAttributeName, nil]];
}

#pragma mark - loadData

- (void)loadData {
    
    NSArray <Account *> *account = [[AccountManager shareManager] selectAllAccounts];
    
    for (Account *a in account) {
        NSString *url = eosmonitor(a.accountName, eos_get_transfer, @"1", @"20");
        wLog(@"eos_get_transfer == %@",url);
        [[HTTPRequestManager shareMonitorManager] get:url paramters:nil success:^(BOOL isSuccess, id responseObject) {
            if (isSuccess) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                            if ([dic isKindOfClass:[NSDictionary class]]) {
                                Exchange *exchange = [Exchange yy_modelWithDictionary:dic];
                                [self.dataArr addObject:exchange];
                            }
                        }
                    }
                }
                [self.tableView reloadData];
            }
        } failure:nil];
        
//        [[HTTPRequestManager shareManager] post:eos_get_actions paramters:@{@"account_name":a.accountName} success:^(BOOL isSuccess, id responseObject) {
//            if (isSuccess) {
//                if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                    if ([[responseObject objectForKey:@"actions"] isKindOfClass:[NSArray class]]) {
//                        for (NSDictionary *dic in [responseObject objectForKey:@"actions"]) {
//                            if ([dic isKindOfClass:[NSDictionary class]]) {
//                                Exchange *exchange = [Exchange yy_modelWithDictionary:dic];
//                                [self.dataArr addObject:exchange];
//                            }
//                        }
//                        [self.tableView reloadData];
//                    }
//                }
//            }
//        } failure:^(NSError *error) {
//
//        }];
    }
}


#pragma mark - setUpSubViews

- (void)setUpTableView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:[ExchangeCell cellIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[ExchangeCell cellIdentifier]];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:[ExchangeCell cellIdentifier] forIndexPath:indexPath];
    cell.exchange = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ExchangeDetailViewController *VC = [[ExchangeDetailViewController alloc] initWithExchange:self.dataArr[indexPath.row]];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - getter

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}
@end
