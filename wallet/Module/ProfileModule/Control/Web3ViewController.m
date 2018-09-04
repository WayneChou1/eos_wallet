//
//  Web3ViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/9/4.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "Web3ViewController.h"
#import "Web3Cell.h"
#import "Web3UrlHelper.h"

@interface Web3ViewController (){
    NSInteger _current;
}

@property (copy, nonatomic) NSArray *dataArr;

@end

@implementation Web3ViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"节点设置");
    [self loadData];
    [self setUpTableView];
    [self setNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"WebList" ofType:@"plist"];
    self.dataArr = [NSArray arrayWithContentsOfFile:path];
    [self.tableView reloadData];
}

- (void)setUpTableView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 60;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    self.tableView.separatorColor = kLine_Color;
    [self.tableView registerNib:[UINib nibWithNibName:[Web3Cell cellIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[Web3Cell cellIdentifier]];
}

- (void)setNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocalizable(@"保存") style:UIBarButtonItemStylePlain target:self action:@selector(saveItemOnClick:)];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Web3Cell *cell = [tableView dequeueReusableCellWithIdentifier:[Web3Cell cellIdentifier] forIndexPath:indexPath];
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.operatedLab.text = [dic objectForKey:@"operated"];
    cell.urlLab.text = [dic objectForKey:@"url"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *selUrl = [[Web3UrlHelper standardHelper] currentWebUrl];
    
    // 如果本地没有缓存记录，默认为第一个
    if (selUrl) {
        if ([[dic objectForKey:@"url"] isEqualToString:selUrl]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.urlLab.textColor = kMain_Color;
            _current = indexPath.row;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.urlLab.textColor = [UIColor darkGrayColor];
        }
    }else{
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.urlLab.textColor = kMain_Color;
            _current = indexPath.row;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.urlLab.textColor = [UIColor darkGrayColor];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == _current) return;
    
    Web3Cell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.urlLab.textColor = kMain_Color;
    }
    
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:_current inSection:0];
    
    Web3Cell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if(oldCell.accessoryType == UITableViewCellAccessoryCheckmark){
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        oldCell.urlLab.textColor = [UIColor darkGrayColor];
    }
    _current = indexPath.row;
}

#pragma mark - btnOnClick

- (void)saveItemOnClick:(UIBarButtonItem *)item {
    
    NSDictionary *dic = self.dataArr[self.tableView.indexPathForSelectedRow.row];
    [[Web3UrlHelper standardHelper] setWebUrl:dic];
    [HTTPRequestManager deallocManager];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
