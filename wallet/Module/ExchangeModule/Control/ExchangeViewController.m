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
#import <MJRefresh.h>

@interface ExchangeViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger pageSize;

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"交易");
    [self setUpTableView];
    
    self.pageSize = 20;
    self.page = 1;
    [self loadData:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNav];
}

- (void)setNav {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.subviews.firstObject.alpha = 1;
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                 kLight_Text_Color, NSForegroundColorAttributeName, [UIFont systemFontOfSize:17], NSFontAttributeName, nil]];
}


#pragma mark - refreshControl Action

- (void)handleRefresh:(id)sender{
    self.page = 1;
    [self loadData:NO];
    [self.refreshControl endRefreshing];
}


#pragma mark - loadData

- (void)loadData:(BOOL)more {
    
    NSString *pageStr = [NSString stringWithFormat:@"%lu",(unsigned long)self.page];
    NSString *countStr = [NSString stringWithFormat:@"%lu",(unsigned long)self.pageSize];
    
    
    NSArray <Account *> *account = [[AccountManager shareManager] selectAllAccounts];
    
    if (account.count == 0) {
        [self.tableView.mj_footer endRefreshing];
        [self.refreshControl endRefreshing];
    }
    
    for (Account *a in account) {
        NSString *url = eosmonitor(a.accountName, eos_get_transfer, pageStr, countStr);
        wLog(@"eos_get_transfer == %@",url);
        [[HTTPRequestManager shareMonitorManager] get:url paramters:nil success:^(BOOL isSuccess, id responseObject) {
            if (isSuccess) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    if ([[[responseObject objectForKey:@"data"] objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                        
                        // 如果是下拉，先清除数据
                        if (!more) {
                            [self.dataArr removeAllObjects];
                            [self.tableView.mj_header endRefreshing];
                        }else{
                            [self.tableView.mj_footer endRefreshing];
                        }
                        
                        // 如果返回数据个数小于设定的个数，认为没有更多数据
                        if ([[[responseObject objectForKey:@"data"] objectForKey:@"data"] count] < self.pageSize) {
                            [self.tableView.mj_footer endRefreshingWithNoMoreData];
                        }
                        
                        for (NSDictionary *dic in [[responseObject objectForKey:@"data"] objectForKey:@"data"]) {
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
    
    // 手动添加下拉刷新
    WEAK_SELF(weakSelf);
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadData:NO];
//    }];
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self
                            action:@selector(handleRefresh:)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageSize++;
        [weakSelf loadData:YES];
    }];
    
    
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.mj_footer;
    footer.stateLabel.font = kSys_font(13);
    footer.stateLabel.textColor = [UIColor darkGrayColor];
    
    [footer setTitle:[NSBundle mj_localizedStringForKey:MJRefreshAutoFooterIdleText] forState:MJRefreshStateIdle];
    [footer setTitle:[NSBundle mj_localizedStringForKey:MJRefreshAutoFooterRefreshingText] forState:MJRefreshStateRefreshing];
    [footer setTitle:[NSBundle mj_localizedStringForKey:MJRefreshAutoFooterNoMoreDataText] forState:MJRefreshStateNoMoreData];
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
    
//    Exchange *m = self.dataArr[indexPath.row];
//    ExchangeDetailViewController *VC = [[ExchangeDetailViewController alloc] initWithTransactionId:m.trx_id];
//    VC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - getter

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}
@end
