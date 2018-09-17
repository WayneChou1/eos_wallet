//
//  WalletDetailViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/8/20.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "WalletDetailViewController.h"
#import "WalletExportViewController.h"
#import "WalletChangePSWViewController.h"
#import "InputPwdView.h"
#import "WalletNameCell.h"
#import "WalletPswHintCell.h"
#import "WalletCommonCell.h"
#import "WalletManager.h"
#import "AccountManager.h"

static CGFloat footer_height = 40.0;

@interface WalletDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Wallet *wallet;

@end

@implementation WalletDetailViewController

- (instancetype)initWithWallet:(Wallet *)wallet {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.wallet = wallet;
        self.title = wallet.walletName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setNav];
    [self setUpFooterView];
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
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, self.tableView.contentInset.left, footer_height, self.tableView.contentInset.bottom);
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

- (void)setUpFooterView {
    if ([kCurrentWallet_UUID isEqualToString:self.wallet.walletUUID]) {
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        deleteBtn.backgroundColor = kMain_Color;
        deleteBtn.titleLabel.font = kSys_font(13);
        [deleteBtn setTitle:kLocalizable(@"删除") forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deleteBtn];
        
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(footer_height);
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
        }];
    }else{
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        deleteBtn.backgroundColor = kMain_Color;
        deleteBtn.titleLabel.font = kSys_font(13);
        [deleteBtn setTitle:kLocalizable(@"删除") forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deleteBtn];
        
        UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        setBtn.backgroundColor = [UIColor colorWithHex:0x88A1CC];
        setBtn.titleLabel.font = kSys_font(13);
        [setBtn setTitle:kLocalizable(@"设为主钱包") forState:UIControlStateNormal];
        [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [setBtn addTarget:self action:@selector(setBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:setBtn];
        
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(footer_height);
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(setBtn.mas_left);
        }];
        
        [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(footer_height);
            make.bottom.equalTo(self.view);
            make.right.equalTo(self.view);
            make.width.equalTo(deleteBtn.mas_width);
        }];
        
    }
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
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        WalletChangePSWViewController *VC = [[WalletChangePSWViewController alloc] initWithWallet:self.wallet];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSArray <Account *> *accArr = [[AccountManager shareManager] selectAccountsFromWalletID:self.wallet.walletUUID];
        if (accArr.count >= 1) {
            WEAK_SELF(weakSelf)
            InputPwdView *inputView = [[InputPwdView alloc]initWithFrame:CGRectMake(0, 0, inputViewWidth, inputViewHeight)];
            [inputView showInView:self.view handler:^(BOOL pwdValied, BOOL isCanceled, NSString *psw) {
                if (!isCanceled) {
                    if (pwdValied) {
                        WalletExportViewController *VC = [[WalletExportViewController alloc] initWithAccount:accArr.firstObject];
                        [weakSelf.navigationController pushViewController:VC animated:YES];
                    }
                }
            }];
        }else{
            [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"没有相关资产！") afterSecond:1.5];
        }
    }
}


#pragma mark - btnOnClicl

- (void)saveItemOnClick:(UIBarButtonItem *)item {
    
    WalletNameCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    WalletPswHintCell *pswHintCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    self.wallet.walletName = nameCell.walletNameTF.text;
    self.wallet.pswHint = pswHintCell.pswHintTF.text;
    
    if ([[WalletManager shareManager] updateWallet:self.wallet]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{}
}

- (void)deleteBtnOnClick:(UIButton *)btn {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kLocalizable(@"是否删除此钱包") message:nil preferredStyle:1];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:kLocalizable(@"确定") style:0 handler:^(UIAlertAction * _Nonnull action) {
        [[WalletManager shareManager] deleteWalletsWithUUID:self.wallet.walletUUID];
        
        NSArray <Wallet *> *walletArr = [[WalletManager shareManager] selectAllWallets];
        if (walletArr.count > 0) {
            // 选择第一个作为主钱包
            [kUserDefault setObject:walletArr.firstObject.walletUUID forKey:kCurrent_wallet];
            [kUserDefault synchronize];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocalizable(@"取消") style:0 handler:nil];
    
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setBtnOnClick:(UIButton *)btn {
    // 保存uuid，作为最新钱包
    [kUserDefault setObject:self.wallet.walletUUID forKey:kCurrent_wallet];
    [kUserDefault synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
