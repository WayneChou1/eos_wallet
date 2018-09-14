//
//  ExchangeDetailViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/8/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "ExchangeDetailViewController.h"
#import "Exchange.h"
#import "UIImage+Color.h"
#import "UIImage+Filter.h"
#import "NSDate+ExFoundation.h"

@interface ExchangeDetailViewController ()


@property (weak, nonatomic) IBOutlet UILabel *fromTipLab;
@property (weak, nonatomic) IBOutlet UILabel *toTipLab;
@property (weak, nonatomic) IBOutlet UILabel *memoTipLab;
@property (weak, nonatomic) IBOutlet UILabel *transactionTipLab;
@property (weak, nonatomic) IBOutlet UILabel *timeTipLab;
@property (weak, nonatomic) IBOutlet UIButton *copBtn;

@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *sendAccountLab;
@property (weak, nonatomic) IBOutlet UILabel *receivedAccountLab;
@property (weak, nonatomic) IBOutlet UILabel *memoLab;
@property (weak, nonatomic) IBOutlet UILabel *hashLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *qrImgV;
@property (weak, nonatomic) IBOutlet UIScrollView *backgroundView;

@property (strong, nonatomic) Exchange *exchange;
@property (copy, nonatomic) NSString *transaction_id;

@end

@implementation ExchangeDetailViewController

- (instancetype)initWithExchange:(Exchange *)exchange {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.exchange = exchange;
        self.title = kLocalizable(@"交易详情");
    }
    return self;
}

- (instancetype)initWithTransactionId:(NSString *)transactionId {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.transaction_id = transactionId;
        self.title = kLocalizable(@"交易详情");
        [self loadData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (@available(iOS 11.0, *)) {
        self.backgroundView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setUpSubViews];
    
    if (self.exchange) {
        [self reloadSubView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNav];
}

- (void)setNav {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:17], NSFontAttributeName, nil]];
}

- (void)setUpSubViews {
    self.fromTipLab.text = kLocalizable(@"发款方");
    self.toTipLab.text = kLocalizable(@"收款方");
    self.memoTipLab.text = kLocalizable(@"备注");
    self.transactionTipLab.text = kLocalizable(@"交易号");
    self.timeTipLab.text = kLocalizable(@"交易时间");
    [self.copBtn setTitle:kLocalizable(@"复制交易号") forState:UIControlStateNormal];
}

- (void)reloadSubView {
    if (self.exchange) {
        self.amountLab.text = self.exchange.data.quantity;
        self.sendAccountLab.text = self.exchange.data.from;
        self.receivedAccountLab.text = self.exchange.data.to;
        self.memoLab.text = self.exchange.data.memo;
        self.hashLab.text = self.exchange.trx_id;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.exchange.expiration.doubleValue];
        self.timeLab.text = [date stringFormate:@"yyyy-MM-dd HH:mm:ss"];
        self.qrImgV.image = [UIImage createImageWithString:[NSString stringWithFormat:@""] filterWithName:CIQRCode];
    }
}

- (void)loadData {
    [[HTTPRequestManager shareMonitorManager] get:eos_get_transaction_action(self.transaction_id) paramters:nil success:^(BOOL isSuccess, id responseObject) {
        if (isSuccess) {
            if ([[[responseObject objectForKey:@"data"] objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in [[responseObject objectForKey:@"data"] objectForKey:@"data"]) {
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        Exchange *exchange = [Exchange yy_modelWithDictionary:dic];
                        self.exchange = exchange;
                        [self reloadSubView];
                    }
                }
            }
        }
    } failure:nil superView:self.view showLoading:YES];
}

#pragma mark - btnOnClick

- (IBAction)copyBtnOnClick:(UIButton *)sender {
    [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"复制成功") afterSecond:1.5];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.hashLab.text;
}

@end
