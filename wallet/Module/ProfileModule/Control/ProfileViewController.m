//
//  ProfileViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/16.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "ProfileViewController.h"
#import "SettingViewController.h"
#import "AboutUsViewController.h"
#import "ProfileCell.h"
#import <StoreKit/SKStoreReviewController.h>

@interface ProfileViewController ()

@property (copy, nonatomic) NSArray *dataArr;

@end

@implementation ProfileViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"我的");
    [self setUpTableView];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    self.dataArr = @[@[
                        @{@"imgName":@"Wallet.bundle/profile/profile_setting_icon",
                         @"titleName":kLocalizable(@"设置"),
                         }
                       ]
                     ,@[
                         @{@"imgName":@"Wallet.bundle/profile/profile_faq_icon",
                           @"titleName":kLocalizable(@"帮助"),
                           },
                         @{@"imgName":@"Wallet.bundle/profile/profile_about_icon",
                           @"titleName":kLocalizable(@"关于我们"),
                           },
                         @{@"imgName":@"Wallet.bundle/profile/profile_favor_icon",
                           @"titleName":kLocalizable(@"给我们点赞"),
                           },
                         ]];
    [self.tableView reloadData];
}

- (void)setUpTableView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 50;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    self.tableView.separatorColor = kLine_Color;
    [self.tableView registerNib:[UINib nibWithNibName:[ProfileCell cellIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[ProfileCell cellIdentifier]];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:[ProfileCell cellIdentifier] forIndexPath:indexPath];
    
    NSDictionary *dic = self.dataArr[indexPath.section][indexPath.row];
    cell.iconImgV.image = [UIImage imageNamed:[dic objectForKey:@"imgName"]];
    cell.titleLab.text = [dic objectForKey:@"titleName"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *VC;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            VC = [[SettingViewController alloc] init];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1) {
            VC = [[AboutUsViewController alloc] init];
        }else if (indexPath.row == 2) {
            [self showAppStoreReView];
            return;
        }
    }
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - Private
- (void)showAppStoreReView{
    Class SKSRC = NSClassFromString(@"SKStoreReviewController");
    if (SKSRC) {
        [SKSRC performSelector:@selector(requestReview)];
    }else {
        NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",APPID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}


@end
