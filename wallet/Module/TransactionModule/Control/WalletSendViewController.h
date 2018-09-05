//
//  WalletSendViewController.h
//  wallet
//
//  Created by 周志伟 on 2018/8/20.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "BaseViewController.h"

@class Account;

@interface WalletSendViewController : BaseViewController

- (instancetype)initWithAccount:(Account *)account;
- (instancetype)initWithAccount:(Account *)account receiverAccount:(NSString *)receiverAccount;

@end
