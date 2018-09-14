//
//  WalletExportViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/9/13.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "WalletExportViewController.h"
#import "WalletExportCell.h"
#import "AccountManager.h"

@interface WalletExportViewController ()<RefreshPrivateDelegate>

@property (copy, nonatomic) NSArray *dataArr;
@property (strong, nonatomic) Account *account;

@end

@implementation WalletExportViewController

- (instancetype)initWithAccount:(Account *)account {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.account = account;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"导出");
    [self setupTableView];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    Export *active = [[Export alloc] init];
    active.permission = @"active";
    active.publicKey = self.account.activePublickKey;
    active.privateKey = self.account.activePrivatekKey;
    active.showQR = NO;
    
    Export *owner = [[Export alloc] init];
    owner.permission = @"owner";
    owner.publicKey = self.account.ownerPublickKey;
    owner.privateKey = self.account.ownerPrivatekKey;
    owner.showQR = NO;
    
    self.dataArr = @[active,owner];
    [self.tableView reloadData];
}

- (void)setupTableView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = kBar_Backgroud_Color;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 150.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:[WalletExportCell cellIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[WalletExportCell cellIdentifier]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletExportCell *cell = [tableView dequeueReusableCellWithIdentifier:[WalletExportCell cellIdentifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.exp = self.dataArr[indexPath.section];
    cell.delegate = self;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

#pragma mark - RefreshPrivateDelegate

- (void)refreshCell:(UITableViewCell *)cell {
    [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:0];
}

@end
