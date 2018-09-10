//
//  WalletCell.m
//  wallet
//
//  Created by zhouzhiwei on 2018/8/1.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "WalletCell.h"
#import "AccountManager.h"

@interface WalletCell ()

@property (weak, nonatomic) IBOutlet UILabel *walletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (weak, nonatomic) IBOutlet UIView *tagView;

@end

@implementation WalletCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setWallet:(WalletRequest *)wallet {
    _wallet = wallet;
    
    self.walletNameLab.text = wallet.wallet.walletName;
    
    // 获取当前钱包的用户名
    NSArray <Account*> *walletArr = [[AccountManager shareManager] selectAccountsFromWalletID:wallet.wallet.walletUUID];
    if (walletArr.count > 0) {
        self.addressLab.text = walletArr.firstObject.ownerPublickKey;
        self.accountLab.text = walletArr.firstObject.accountName;
    }else{
        self.addressLab.text = @"";
    }
    
    [self.wallet getAccountInfo:^(AccountInfo *accountInfo, BOOL success, WalletRequest *request) {
        
        // 判断cell是否已经被重用过
        if (request == self->_wallet) {
            if (success) {
                self.amountLab.text = [accountInfo.core_liquid_balance componentsSeparatedByString:@" "].firstObject;
            }else{
                self.amountLab.text = @"0";
            }
        }
    }];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (self.wallet.wallet.createTime) {
        self.createTimeLab.text = [dateFormatter stringFromDate:self.wallet.wallet.createTime];
    }else{
        self.createTimeLab.text = @"";
    }
    
    self.tagView.hidden = ![wallet.wallet.walletUUID isEqualToString:kCurrentWallet_UUID];
}

@end
