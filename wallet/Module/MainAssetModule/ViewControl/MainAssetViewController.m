//
//  MainAssetViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/16.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "MainAssetViewController.h"
#import "CreateWalletViewController.h"
#import "ImportAccountViewController.h"
#import "WalletManagerViewController.h"
#import "NavigationViewController.h"
#import "TransactionViewController.h"
#import "MainHeaderView.h"
#import "MainAssetCell.h"
#import "MainNoDataView.h"
#import "UIImage+Color.h"
#import "AccountInfo.h"
#import "Account.h"
#import "AccountManager.h"
#import "WalletManager.h"

static CGFloat header_height = 200.0;

@interface MainAssetViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,MainNoDataPushDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UIImageView *barImageView;  // nav背景图
@property (nonatomic, strong) MainHeaderView *headerView; // 头视图
@property (nonatomic, strong) Account *info;
@property (nonatomic, strong) AccountInfo *accountInfo;

@end

@implementation MainAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpHeaderView];
    [self setUpNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadWallet];
}


- (void)setUpHeaderView {
    self.headerView = [[MainHeaderView alloc]initHeaderViewWithFrame:CGRectMake(0, -header_height, SCREEN_WIDTH, header_height)];
    [self.tableView addSubview:self.headerView];
}


- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 100;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.backgroundColor = kBar_Backgroud_Color;
    [self.view addSubview:self.tableView];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    self.tableView.contentInset = UIEdgeInsetsMake(header_height, insets.left, insets.bottom, insets.right);
    if (@available(iOS 11.0, *)) {
        wLog(@"adjustedContentInset == %@",NSStringFromUIEdgeInsets(self.tableView.adjustedContentInset));
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(header_height - 64, insets.left, insets.bottom, insets.right);
    }
    
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:[MainAssetCell cellIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MainAssetCell cellIdentifier]];
}

- (void)setUpNav {
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Wallet.bundle/main/main_add_wallet"] style:0 target:self action:@selector(addItemOnClick:)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    UIBarButtonItem *exchangeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Wallet.bundle/main/wallet_exchange"] style:0 target:self action:@selector(exchangeWallet:)];
    self.navigationItem.leftBarButtonItem = exchangeItem;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    _barImageView = self.navigationController.navigationBar.subviews.firstObject;
    _barImageView.alpha = 0;
}

- (void)reloadWallet {
    
    // 判断是否有钱包
//    if (!isNoWallet && !isNoAccount) {
//        [self.dataList removeAllObjects];
//        self.tableView.emptyDataSetSource = self;
//        self.tableView.emptyDataSetDelegate = self;
//        [self.tableView reloadEmptyDataSet];
//    }else{
//        [self loadData];
//    }
    if ([self isNotAssetValidate]) {
        [self.dataList removeAllObjects];
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        [self.tableView reloadEmptyDataSet];
    }else{
        [self loadData];
    }
}

- (BOOL)isNotAssetValidate {
    BOOL isNoWallet = YES;
    BOOL isNoAccount = YES;
    
    if (kCurrentWallet) {
        isNoWallet = NO;
        NSArray *accArr = [[AccountManager shareManager] selectAccountsFromWalletID:kCurrentWallet_UUID];
        if (accArr.count > 0) {
            isNoAccount = NO;
        }
    }
    return isNoAccount || isNoWallet;
}


#pragma mark - loadData

- (void)loadData {
    
    // 目前只支持EOS
    NSArray *accArr = [[AccountManager shareManager] selectAccountsFromWalletID:kCurrentWallet_UUID];
    Account *account;
    if (accArr.count != 0) {
        account = accArr.firstObject;
    }
    
    if (account) {
        self.info = account;
        [self.tableView reloadData];
    }
    
    
    NSString *accountName;
    NSArray <Account*> *walletArr = [[AccountManager shareManager] selectAccountsFromWalletID:kCurrentWallet_UUID];
    
    if (walletArr.count > 0) {
        accountName = walletArr.firstObject.accountName;
    }
    
    NSDictionary *dic = @{@"account_name":VALIDATE_STRING(accountName)};
    [[HTTPRequestManager shareManager] post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
        if (isSuccess) {
            AccountInfo *info = [AccountInfo yy_modelWithJSON:responseObject];
//            [self.dataList removeAllObjects];
//            [self.dataList addObject:info];
//            [self.tableView reloadData];
            self.accountInfo = info;
            self.accountInfo.localAccout = self.info;
            [self.tableView reloadData];
        }
    } failure:nil superView:nil showFaliureDescription:YES];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning 目前只支持EOS
//    if (kCurrentWallet) {
//        return 1;
//    }
//    return 0;
    if ([self isNotAssetValidate]) {
        return 0;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainAssetCell *cell = [tableView dequeueReusableCellWithIdentifier:[MainAssetCell cellIdentifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.info = self.accountInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TransactionViewController *VC = [[TransactionViewController alloc] initWithAccount:self.info];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    wLog(@"contentInset == %@",NSStringFromUIEdgeInsets(self.tableView.contentInset));
//    wLog(@"contentOffset == %@",NSStringFromCGPoint(self.tableView.contentOffset));
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat height = -header_height;
    
    if (offsetY <= height) {
        self.headerView.frame = CGRectMake(0, offsetY, SCREEN_WIDTH, header_height);
    }
}

#pragma mark - DZNEmptyDataSetSource

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    
    BOOL isNoWallet = YES;
    BOOL isNoAccount = YES;
    
    if (kCurrentWallet) {
        isNoWallet = NO;
        NSArray *accArr = [[AccountManager shareManager] selectAccountsFromWalletID:kCurrentWallet_UUID];
        if (accArr.count > 0) {
            isNoAccount = NO;
        }
    }
    
    MainNoDataView *noDataView = [[MainNoDataView alloc] initHeaderViewWithFrame:CGRectZero noWallet:isNoWallet noAccount:isNoAccount];
    noDataView.delegate = self;
    return noDataView;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - MainNoDataPushDelegate

- (void)needCreateWallet {
    CreateWalletViewController *createVC = [[CreateWalletViewController alloc]init];
    NavigationViewController *navVC = [[NavigationViewController alloc]initWithRootViewController:createVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)needInsertAccount {
    ImportAccountViewController *importVC = [[ImportAccountViewController alloc] init];
    NavigationViewController *navVC = [[NavigationViewController alloc]initWithRootViewController:importVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - BtnOnClick

- (void)addItemOnClick:(UIBarButtonItem *)item {
    CreateWalletViewController *createVC = [[CreateWalletViewController alloc]init];
    NavigationViewController *navVC = [[NavigationViewController alloc]initWithRootViewController:createVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)exchangeWallet:(UIBarButtonItem *)item {
    WalletManagerViewController *walletVC = [[WalletManagerViewController alloc]init];
    NavigationViewController *navVC = [[NavigationViewController alloc]initWithRootViewController:walletVC];
    [self presentViewController:navVC animated:YES completion:nil];
}


#pragma mark - getter

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = @[].mutableCopy;
    }
    return _dataList;
}

- (Account *)info {
    if (!_info) {
        _info = [[Account alloc] init];
    }
    return _info;
}

@end
