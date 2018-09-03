//
//  SettingViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/9/3.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "SettingViewController.h"
#import "LanguageViewController.h"
#import "SettingTouchIdCell.h"
#import "EvaluatePolicy.h"

@interface SettingViewController ()

@property (copy, nonatomic) NSArray *dataArr;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"设置");
    [self loadData];
    [self setUpTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)loadData {
    self.dataArr = @[@[
                         @{
                           @"titleName":kLocalizable(@"多语言"),
                           },
                         @{
                             @"titleName":kLocalizable(@"Web3 设置"),
                           }
                         ]
                     ,@[
                         @{
                             @"titleName":kLocalizable(@"指纹登录"),
                           }
                         ]];
    [self.tableView reloadData];
}

- (void)setUpTableView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 50;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    self.tableView.separatorColor = kLine_Color;
    [self.tableView registerNib:[UINib nibWithNibName:[SettingTouchIdCell cellIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[SettingTouchIdCell cellIdentifier]];
    [self.tableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:[BaseTableViewCell cellIdentifier]];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataArr[indexPath.section][indexPath.row];
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:[BaseTableViewCell cellIdentifier] forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:[SettingTouchIdCell cellIdentifier] forIndexPath:indexPath];
        SettingTouchIdCell *setCell = (SettingTouchIdCell *)cell;
        [setCell.touchIdSwitch setOn:kIs_TouchId_on];
        [setCell.touchIdSwitch addTarget:self action:@selector(touchIdSwtichOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.textLabel.font = kSys_font(13);
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text = [dic objectForKey:@"titleName"];
    cell.indentationWidth = 12.0;
    
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
            VC = [[LanguageViewController alloc] init];
        }else if (indexPath.row == 1) {
            
        }
    }
    
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - btnOnClick

- (void)touchIdSwtichOnClick:(UISwitch *)swt {
    [EvaluatePolicy EvaluatePolicy:^(BOOL success, NSString *message) {
        if (!success) {
            swt.on = !swt.on;
        }
        [kUserDefault setBool:swt.on forKey:kTouchId_on];
        [kUserDefault synchronize];
    }];
}

@end
