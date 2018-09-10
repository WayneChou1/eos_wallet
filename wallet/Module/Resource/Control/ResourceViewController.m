//
//  ResourceViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/9/9.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "ResourceViewController.h"
#import "TODOViewController.h"
#import "ResourceCell.h"
#import "AccountInfo.h"

@interface ResourceViewController ()

@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) AccountInfo *accountInfo;
@property (copy, nonatomic) NSString *accountName;

@end

@implementation ResourceViewController

- (instancetype)initWithAccountName:(NSString *)accountName {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.accountName = accountName;
    }
    return self;
}

- (instancetype)initWithAccountInfo:(AccountInfo *)accountInfo {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.accountInfo = accountInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"资源");
    [self setUpTableView];
    
    if (self.accountInfo) {
        [self insertDataWithAccountInfo:self.accountInfo];
    }else if (self.accountName) {
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpTableView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 70;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.separatorColor = kLine_Color;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tableView registerNib:[UINib nibWithNibName:[ResourceCell cellIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[ResourceCell cellIdentifier]];
}


- (void)loadData {
    NSDictionary *dic = @{@"account_name":VALIDATE_STRING(self.accountName)};
    [[HTTPRequestManager shareManager] post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
        if (isSuccess) {
            AccountInfo *info = [AccountInfo yy_modelWithJSON:responseObject];
            self.accountInfo = info;
            [self insertDataWithAccountInfo:info];
        }
    } failure:nil superView:self.view showFaliureDescription:YES];
}

- (void)insertDataWithAccountInfo:(AccountInfo *)accountInfo {
    
    Resource *ramResource = [[Resource alloc] init];
    ramResource.resourceName = kLocalizable(@"RAM");
    ramResource.max = [NSString stringWithFormat:@"%.2f",accountInfo.ram_quota/1024.0];
    ramResource.used = [NSString stringWithFormat:@"%.2f",accountInfo.ram_usage/1024.0];
    ramResource.weight = [NSString stringWithFormat:@"%.2f KB",accountInfo.ram_quota/1024.0];
    ramResource.unit = @"KB";
    ramResource.dec = kLocalizable(@"可用 RAM");
    
    Resource *cpuResource = [[Resource alloc] init];
    cpuResource.resourceName = kLocalizable(@"CPU");
    cpuResource.max = [NSString stringWithFormat:@"%ld",accountInfo.cpu_limit.max];
    cpuResource.used = [NSString stringWithFormat:@"%ld",accountInfo.cpu_limit.used];
    cpuResource.weight = [NSString stringWithFormat:@"%@",accountInfo.total_resources.cpu_weight];
    cpuResource.unit = @"ms";
    cpuResource.dec = kLocalizable(@"可用 CPU");
    
    Resource *netResource = [[Resource alloc] init];
    netResource.resourceName = kLocalizable(@"NET");
    netResource.max = [NSString stringWithFormat:@"%.2f",accountInfo.net_limit.max/1024.0];
    netResource.used = [NSString stringWithFormat:@"%.2f",accountInfo.net_limit.used/1024.0];
    netResource.weight = [NSString stringWithFormat:@"%@",accountInfo.total_resources.net_weight];
    netResource.unit = @"KB";
    netResource.dec = kLocalizable(@"可用 NET");
    
    [self.dataArr addObject:ramResource];
    [self.dataArr addObject:cpuResource];
    [self.dataArr addObject:netResource];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResourceCell *cell = [tableView dequeueReusableCellWithIdentifier:[ResourceCell cellIdentifier] forIndexPath:indexPath];
    cell.resource = self.dataArr[indexPath.section];
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
    
    TODOViewController *VC = [[TODOViewController alloc] init];
    
    if (indexPath.section == 0) VC.title = @"RAM";
    else if (indexPath.section == 1) VC.title = @"CPU";
    else if (indexPath.section == 2) VC.title = @"NET";
    
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
