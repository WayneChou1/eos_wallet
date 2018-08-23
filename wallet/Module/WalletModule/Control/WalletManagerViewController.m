//
//  WalletManagerViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/8/1.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "WalletManagerViewController.h"
#import "WalletDetailViewController.h"
#import "WalletCell.h"
#import "WalletRequest.h"
#import "WalletManager.h"

@interface WalletManagerViewController ()

@property (nonatomic, strong) NSMutableArray <WalletRequest *> *dataList;

@end

@implementation WalletManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"钱包管理");
    [self setUpNav];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}


- (void)setupTableView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = kBar_Backgroud_Color;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:[WalletCell cellIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[WalletCell cellIdentifier]];
}

- (void)setUpNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Wallet.bundle/wallet/wallet_close"] style:0 target:self action:@selector(closeItemOnClick:)];
}

- (void)loadData {
    
    [self.dataList removeAllObjects];
    
    for (Wallet *wallet in [[WalletManager shareManager] selectAllWallets]) {
        WalletRequest *w = [[WalletRequest alloc] init];
        w.wallet = wallet;
        [self.dataList insertObject:w atIndex:0];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletCell *cell = [tableView dequeueReusableCellWithIdentifier:[WalletCell cellIdentifier] forIndexPath:indexPath];
    cell.wallet = self.dataList[indexPath.section];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WalletDetailViewController *VC = [[WalletDetailViewController alloc] initWithWallet:self.dataList[indexPath.row].wallet];
    [self.navigationController pushViewController:VC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kLocalizable(@"删除");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletRequest *w = self.dataList[indexPath.section];
    BOOL success = [[WalletManager shareManager] deleteWalletsWithUUID:w.wallet.walletUUID];
    if (success) {
        [self.dataList removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - btnOnClick

- (void)closeItemOnClick:(UIBarButtonItem *)item {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - setter

- (NSMutableArray<WalletRequest *> *)dataList {
    if (!_dataList) {
        _dataList = @[].mutableCopy;
    }
    return _dataList;
}

@end
