//
//  WalletDetailViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/8/20.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "WalletDetailViewController.h"
#import "WalletNameCell.h"
#import "WalletPswHintCell.h"
#import "WalletCommonCell.h"
#import "Wallet.h"
#import "WalletManager.h"

@interface WalletDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Wallet *wallet;

@end

@implementation WalletDetailViewController

- (instancetype)initWithWallet:(Wallet *)wallet {
    self = [super initWithNibName:nil bundle:nil];
    self.wallet = wallet;
    self.title = wallet.walletName;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:0];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = kBar_Backgroud_Color;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:[WalletNameCell cellIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[WalletNameCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[WalletPswHintCell cellIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[WalletPswHintCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[WalletCommonCell cellIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[WalletCommonCell cellIdentifier]];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

- (void)setNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocalizable(@"保存") style:0 target:self action:@selector(saveItemOnClick:)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1) {
        return 1;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        return view;
    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            WalletNameCell *cell = [tableView dequeueReusableCellWithIdentifier:[WalletNameCell cellIdentifier] forIndexPath:indexPath];
            cell.walletNameTF.text = self.wallet.walletName;
            return cell;
        }else if (indexPath.row == 1) {
            WalletPswHintCell *cell = [tableView dequeueReusableCellWithIdentifier:[WalletPswHintCell cellIdentifier] forIndexPath:indexPath];
            cell.pswHintTF.text = self.wallet.pswHint;
            return cell;
        }else if (indexPath.row == 2) {
            WalletCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:[WalletCommonCell cellIdentifier] forIndexPath:indexPath];
            cell.titleLab.text = kLocalizable(@"修改密码");
            return cell;
        }
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        WalletCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:[WalletCommonCell cellIdentifier] forIndexPath:indexPath];
        cell.titleLab.text = kLocalizable(@"导出私钥");
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - btnOnClicl

- (void)saveItemOnClick:(UIBarButtonItem *)item {
    
    WalletNameCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    WalletPswHintCell *pswHintCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    self.wallet.walletName = nameCell.walletNameTF.text;
    self.wallet.pswHint = pswHintCell.pswHintTF.text;
    
    if ([[WalletManager shareManager] updateWalletNameAndPswHintWithWallet:self.wallet]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{}
}

@end
