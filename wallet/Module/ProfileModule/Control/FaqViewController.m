//
//  FaqViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/9/17.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "FaqViewController.h"
#import "TelegramContactViewController.h"
#import "TencentContactViewController.h"
#import "ProfileCell.h"

static NSString * const email = @"waynechou1@outlook.com";

@interface FaqViewController ()

@property (copy, nonatomic) NSArray *dataArr;

@end

@implementation FaqViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"Faq");
    [self setUpTableView];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpTableView {
    self.tableView.rowHeight = 50;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    self.tableView.separatorColor = kLine_Color;
    [self.tableView registerNib:[UINib nibWithNibName:[ProfileCell cellIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[ProfileCell cellIdentifier]];
    
    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 45)];
    headerLab.font = kSys_font(12);
    headerLab.textColor = [UIColor lightGrayColor];
    headerLab.numberOfLines = 0;
    headerLab.textAlignment = NSTextAlignmentCenter;
    headerLab.text = kLocalizable(@"如果你在使用过程中遇到了任何问题，请通过以上方式联系方式联系我们");
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    [headerView addSubview:headerLab];
    
    self.tableView.tableFooterView = headerView;
}

- (void)loadData {
    self.dataArr = @[@{@"imgName":@"Wallet.bundle/profile/faq/profile_faq_telegram",
                       @"titleName":kLocalizable(@"电报群"),
                       },
                     @{@"imgName":@"Wallet.bundle/profile/faq/profile_faq_qq",
                       @"titleName":kLocalizable(@"QQ群"),
                       },
//                     @{@"imgName":@"Wallet.bundle/profile/faq/profile_faq_wechat",
//                       @"titleName":kLocalizable(@"微信群"),
//                       },
                     @{@"imgName":@"Wallet.bundle/profile/faq/profile_faq_email",
                       @"titleName":kLocalizable(@"邮箱"),
                       }];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:[ProfileCell cellIdentifier] forIndexPath:indexPath];
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.iconImgV.image = [UIImage imageNamed:[dic objectForKey:@"imgName"]];
    cell.titleLab.text = [dic objectForKey:@"titleName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/joinchat/J2Q_rxI1kDeTyPu9MUn3gQ"]];
            break;
        case 1:
        {
            TencentContactViewController *VC = [[TencentContactViewController alloc] initWithContact:TencentContactTypeQQ];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
//        case 2:
//        {
//            TencentContactViewController *VC = [[TencentContactViewController alloc] initWithContact:TencentContactTypeWechat];
//            [self.navigationController pushViewController:VC animated:YES];
//        }
//            break;
        case 2:
        {
            NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=Send email to Wayne Chou",email];
            NSString *email = [NSString stringWithFormat:@"%@", recipients];
            email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
        }
            break;
        default:
            break;
    }
}

@end
