//
//  TransactionViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/8/1.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "TransactionViewController.h"
#import "WalletQRViewController.h"
#import "WalletSendViewController.h"
#import "ScanQRViewController.h"
#import "NavigationViewController.h"
#import "ExchangeCell.h"
#import "Exchange.h"
#import "Account.h"
#import "AccountManager.h"
#import <MJRefresh.h>

@interface TransactionViewController () <UIViewControllerTransitioningDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) Account *account;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) UIRefreshControl * refreshControl;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger pageSize;

@end

@implementation TransactionViewController

- (instancetype)initWithAccount:(Account *)account {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.account = account;
        self.title = @"EOS";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
    [self setUpTableView];
    [self setNavItem];
    
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
    }
}

- (void)setUpSubViews {
    [self.sendBtn setTitle:kLocalizable(@"转账") forState:UIControlStateNormal];
    [self.receiveBtn setTitle:kLocalizable(@"收款") forState:UIControlStateNormal];
}

- (void)setUpTableView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:[ExchangeCell cellIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[ExchangeCell cellIdentifier]];
    
    // 手动添加下拉刷新
    WEAK_SELF(weakSelf);
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    
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

- (void)setNavItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Wallet.bundle/transation/transation_setting_icon"] style:0 target:self action:@selector(QRItemOnClick:)];
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
    
//    ExchangeDetailViewController *VC = [[ExchangeDetailViewController alloc] initWithExchange:self.dataArr[indexPath.row]];
//    VC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:VC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = kBackgroud_Color;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 20, 40)];
    titleLab.font = kSys_font(12);
    titleLab.textColor = kLight_Text_Color;
    titleLab.text = kLocalizable(@"交易记录");
    
    [headerView addSubview:titleLab];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


#pragma mark - btnOnClick

- (IBAction)receiveBtnOnClick:(UIButton *)sender {
    NSString *account = self.account.accountName;
    WalletQRViewController *VC = [[WalletQRViewController alloc] initWithAccount:account];
    [self presentViewController:VC animated:YES completion:nil];
}

- (IBAction)transferBtnOnClick:(UIButton *)sender {
    WalletSendViewController *VC = [[WalletSendViewController alloc] initWithAccount:self.account];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)QRItemOnClick:(UIBarButtonItem *)item {
    WEAK_SELF(weakSelf)
    ScanQRViewController *VC = [[ScanQRViewController alloc] initWithHandler:^(BOOL success, NSString *codeString) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
        if (success) {
            WalletSendViewController *VC = [[WalletSendViewController alloc] initWithAccount:weakSelf.account receiverAccount:codeString];
            [weakSelf.navigationController pushViewController:VC animated:YES];
        }
    }];
    NavigationViewController *naVC = [[NavigationViewController alloc] initWithRootViewController:VC];
    [self.navigationController presentViewController:naVC animated:YES completion:nil];
}


#pragma mark -

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

@end
