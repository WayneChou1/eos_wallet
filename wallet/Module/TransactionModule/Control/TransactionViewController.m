//
//  TransactionViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/8/1.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "TransactionViewController.h"
#import "WalletQRViewController.h"
#import "Account.h"

@interface TransactionViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) Account *account;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@end

@implementation TransactionViewController

- (instancetype)initWithAccount:(Account *)account {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.account = account;
        self.title = @"EOS";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
    [self setNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpSubViews {
//    self.detailLab.text = self.account.core_liquid_balance;
}

- (void)setNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Wallet.bundle/transation/transation_setting_icon"] style:0 target:self action:@selector(QRItemOnClick:)];
}


#pragma mark - btnOnClick

- (IBAction)receiveBtnOnClick:(UIButton *)sender {
    
    NSString *publicKey = self.account.ownerPublickKey;
    
    WalletQRViewController *VC = [[WalletQRViewController alloc] initWithPublicKey:publicKey];
    [self presentViewController:VC animated:YES completion:nil];
}

- (IBAction)transferBtnOnClick:(UIButton *)sender {
}

- (void)QRItemOnClick:(UIBarButtonItem *)item {
    
}


@end
