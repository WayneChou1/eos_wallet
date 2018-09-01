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

@interface ExchangeDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *sendAccountLab;
@property (weak, nonatomic) IBOutlet UILabel *receivedAccountLab;
@property (weak, nonatomic) IBOutlet UILabel *memoLab;
@property (weak, nonatomic) IBOutlet UILabel *hashLab;
@property (weak, nonatomic) IBOutlet UILabel *blockLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *qrImgV;
@property (weak, nonatomic) IBOutlet UIScrollView *backgroundView;

@property (strong, nonatomic) Exchange *exchange;


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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    if (self.exchange) {
        self.amountLab.text = self.exchange.quantity;
        self.sendAccountLab.text = self.exchange.from;
        self.receivedAccountLab.text = self.exchange.to;
        self.memoLab.text = self.exchange.mome;
        self.hashLab.text = self.exchange.trx_id;
        self.timeLab.text = self.exchange.expiration;
        self.qrImgV.image = [UIImage createImageWithString:self.exchange.trx_id filterWithName:CIQRCode];
    }
    
    if (@available(iOS 11.0, *)) {
        self.backgroundView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - btnOnClick

- (IBAction)copyBtnOnClick:(UIButton *)sender {
    [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"复制成功") afterSecond:0.5];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.hashLab.text;
}

@end
