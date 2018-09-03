//
//  LanguageViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/9/3.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "LanguageViewController.h"
#import "TabBarViewController.h"
#import "BaseTableViewCell.h"
#import "AppDelegate.h"

@interface LanguageViewController (){
    NSInteger _current;
}

@property (copy, nonatomic) NSArray *dataArr;

@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"多语言");
    [self loadData];
    [self setUpTableView];
    [self setNav];
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
                             @"titleName":kLocalizable(@"中文"),
                             @"language":kZh_Hans
                             },
                         @{
                             @"titleName":kLocalizable(@"英文"),
                             @"language":kEn
                             }
                         ]
                     ];
    [self.tableView reloadData];
}

- (void)setUpTableView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 50;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    self.tableView.separatorColor = kLine_Color;
    [self.tableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:[BaseTableViewCell cellIdentifier]];
}

- (void)setNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocalizable(@"保存") style:UIBarButtonItemStylePlain target:self action:@selector(saveItemOnClick:)];
}


#pragma mark - 重新设置keyWindow

-(void)resetRootViewController {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *window = appDelegate.window;
    window.rootViewController = [[TabBarViewController alloc] init];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BaseTableViewCell cellIdentifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = kSys_font(13);
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text = [dic objectForKey:@"titleName"];
    cell.indentationWidth = 12.0;
    
    if ([[dic objectForKey:@"language"] isEqualToString:[[LocalizedHelper standardHelper] currentLanguage]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _current = indexPath.row;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
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
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == _current)return;
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];

    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.textLabel.textColor = kMain_Color;
    }
    
    NSIndexPath*oldIndexPath = [NSIndexPath indexPathForRow:_current inSection:0];
    
    UITableViewCell*oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if(oldCell.accessoryType == UITableViewCellAccessoryCheckmark){
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        oldCell.textLabel.textColor = kDark_Text_Color;
    }
    _current = indexPath.row;
}


#pragma mark - btnOnClick

- (void)saveItemOnClick:(UIBarButtonItem *)item {
    
    NSDictionary *dic = self.dataArr[self.tableView.indexPathForSelectedRow.section][self.tableView.indexPathForSelectedRow.row];
    
    // 选中的语言
    NSString *selLanguage = [dic objectForKey:@"language"];
    // 本地语言
    NSString *language = [[LocalizedHelper standardHelper] currentLanguage];
    
    if ([language isEqualToString:selLanguage])  return;
    
    [[LocalizedHelper standardHelper] setUserLanguage:selLanguage];
    
    [self resetRootViewController];
}

@end
