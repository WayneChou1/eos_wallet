//
//  MainHeaderView.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/17.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "MainHeaderView.h"
#import "AccountManager.h"
#import "AccountInfo.h"
#import "WalletManager.h"

@interface MainHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *walletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@end

@implementation MainHeaderView

- (instancetype)initHeaderViewWithFrame:(CGRect)frame {
    return [self initHeaderViewWithAccount:nil frame:frame];
}

- (instancetype)initHeaderViewWithAccount:(Account *)account frame:(CGRect)frame {
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:@"MainHeaderView" owner:nil options:nil];
    
    if (viewArr.count != 0 && viewArr) {
        self = viewArr.firstObject;
        self.frame = frame;
        [self setUpSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)reloadSubViews {
    [self setUpSubViews];
}

- (void)setUpSubViews {
    if (kCurrentWallet) {
        self.walletNameLab.text = kCurrentWallet.walletName;
        NSArray <Account *> *accArr = [[AccountManager shareManager] selectAccountsFromWalletID:kCurrentWallet_UUID];
        if (accArr.count > 0) {
            self.accountNameLab.text = accArr.firstObject.accountName;
        }else{
            self.accountNameLab.text = kLocalizable(@"没有相关账号！");
        }
    }else{
        self.walletNameLab.text = kLocalizable(@"没有相关资产！");
    }
}

#pragma mark - public

- (void)loadUSDWithAccountInfo:(AccountInfo *)accounInfo {
    NSString *urlStr = @"https://api.coinmarketcap.com/v2/ticker/1765/";
    [[HTTPRequestManager shareNormalManager] get:urlStr paramters:@{@"convert":@"CNY"} success:^(BOOL isSuccess, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                if ([[[[responseObject objectForKey:@"data"] objectForKey:@"quotes"] objectForKey:@"CNY"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = [[[responseObject objectForKey:@"data"] objectForKey:@"quotes"] objectForKey:@"CNY"];
                    self.amountLab.text = [NSString stringWithFormat:@"≈ %.2f",[[dic objectForKey:@"price"] floatValue] * [accounInfo.core_liquid_balance floatValue]];
                }
            }
        }
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            if ([[responseObject firstObject] isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *dic = (NSDictionary *)[responseObject firstObject];
//
//                self.amountLab.text = [NSString stringWithFormat:@"≈ %.2f",[[dic objectForKey:@"price"] floatValue] * [accounInfo.core_liquid_balance floatValue]];
//            }
//        }
    } failure:nil superView:nil showLoading:NO showFaliureDescription:NO];
}

#pragma mark - btnOnClick

- (IBAction)moreBtnOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(gotoMore)]) {
        [self.delegate gotoMore];
    }
}

@end
