//
//  AboutUsViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/9/4.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "AboutUsViewController.h"
#import "BaseTableViewCell.h"
#import "AboutUsHeaderView.h"
#import "PrivacyPolicyViewController.h"

@interface AboutUsViewController ()

@property (copy, nonatomic) NSArray *dataArr;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"关于我们");
    [self setUpTableView];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

- (void)setUpTableView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 50;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    self.tableView.separatorColor = kLine_Color;
    [self.tableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:[BaseTableViewCell cellIdentifier]];
    
    // 设置头视图
    self.tableView.tableHeaderView = [[AboutUsHeaderView alloc] initHeaderViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
}

- (void)checkUpdate {
    NSString * url = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/lookup?id=%@",APPID];
    // 获取本地版本号
    NSString * currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    // 网络请求获取最新版本
    [[HTTPRequestManager shareNormalManager] get:url paramters:nil success:^(BOOL isSuccess, id responseObject) {
        NSArray * results = responseObject[@"results"];
        if (results && results.count>0)
        {
            NSDictionary * dic = results.firstObject;
            NSString * lineVersion = dic[@"version"];//版本号
            NSString * releaseNotes = dic[@"releaseNotes"];//更新说明
            //NSString * trackViewUrl = dic[@"trackViewUrl"];//链接
            //把版本号转换成数值
            NSArray * array1 = [currentVersion componentsSeparatedByString:@"."];
            NSInteger currentVersionInt = 0;
            if (array1.count == 3)//默认版本号1.0.0类型
            {
                currentVersionInt = [array1[0] integerValue]*100 + [array1[1] integerValue]*10 + [array1[2] integerValue];
            }
            NSArray * array2 = [lineVersion componentsSeparatedByString:@"."];
            NSInteger lineVersionInt = 0;
            if (array2.count == 3)
            {
                lineVersionInt = [array2[0] integerValue]*100 + [array2[1] integerValue]*10 + [array2[2] integerValue];
            }
            if (lineVersionInt > currentVersionInt)//线上版本大于本地版本
            {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"发现新版本%@",lineVersion] message:releaseNotes preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * ok = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                UIAlertAction * update = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //跳转到App Store
                    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",APPID];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }];
                [alert addAction:ok];
                [alert addAction:update];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    } failure:^(NSError *failure) {
        wLog(@"版本更新出错，%@",failure.description);
    }];
}


- (void)loadData {
    self.dataArr = @[kLocalizable(@"隐私条款"),kLocalizable(@"检测更新")];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BaseTableViewCell cellIdentifier] forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = kSys_font(13);
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.indentationWidth = 12.0;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        PrivacyPolicyViewController *VC = [[PrivacyPolicyViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 1) {
        [self checkUpdate];
    }
}

@end
