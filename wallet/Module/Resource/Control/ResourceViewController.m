//
//  ResourceViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/9/9.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "ResourceViewController.h"
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
    [self setUpTableView];
    
    if (self.accountInfo) {
        
    }else if (self.accountName) {
        
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
    } failure:nil superView:nil showFaliureDescription:YES];
}

- (void)insertDataWithAccountInfo:(AccountInfo *)accountInfo {
    
//    @property (copy, nonatomic) NSString *resourceName;
//    @property (copy, nonatomic) NSString *max;
//    @property (copy, nonatomic) NSString *used;
//    @property (copy, nonatomic) NSString *weight;
//    @property (copy, nonatomic) NSString *unit;
//    @property (copy, nonatomic) NSString *description;
    
    Resource *ramResource = [[Resource alloc] init];
    ramResource.resourceName = kLocalizable(@"RAM");
    ramResource.max = [NSString stringWithFormat:@"%ld",accountInfo.ram_quota];
    ramResource.used = [NSString stringWithFormat:@"%ld",accountInfo.ram_usage];
    ramResource.weight = [NSString stringWithFormat:@"%ld KB",accountInfo.ram_quota/1024];
    ramResource.unit = @"KB";
    ramResource.description = kLocalizable(@"");
    
    Resource *cpuResource = [[Resource alloc] init];
    cpuResource.resourceName = kLocalizable(@"CPU");
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResourceCell *cell = [tableView dequeueReusableCellWithIdentifier:[ResourceCell cellIdentifier] forIndexPath:indexPath];
    return cell;
}

#pragma mark - getter

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}


@end
