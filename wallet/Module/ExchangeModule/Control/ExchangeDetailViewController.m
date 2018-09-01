//
//  ExchangeDetailViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/8/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "ExchangeDetailViewController.h"
#import "Exchange.h"

@interface ExchangeDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *sendAccountLab;
@property (weak, nonatomic) IBOutlet UILabel *receivedAccountLab;
@property (weak, nonatomic) IBOutlet UILabel *memoLab;
@property (weak, nonatomic) IBOutlet UILabel *hashLab;
@property (weak, nonatomic) IBOutlet UILabel *blockLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *qrImgV;

@property (strong, nonatomic) Exchange *exchange;

@end

@implementation ExchangeDetailViewController

- (instancetype)initWithExchange:(Exchange *)exchange {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.exchange = exchange;
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

- (void)setUpSubViews {
    if (self.exchange) {
        self.amountLab.text = self.exchange.quantity;
        self.sendAccountLab.text = self.exchange.from;
        self.receivedAccountLab.text = self.exchange.to;
        self.memoLab.text = self.exchange.mome;
        self.hashLab.text = self.exchange.trx_id;
        self.timeLab.text = self.exchange.expiration;
    }
}

#pragma mark - btnOnClick

- (IBAction)copyBtnOnClick:(UIButton *)sender {
}

@end
