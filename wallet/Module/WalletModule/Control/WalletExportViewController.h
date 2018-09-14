//
//  WalletExportViewController.h
//  wallet
//
//  Created by 周志伟 on 2018/9/13.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Account;

@interface WalletExportViewController : UITableViewController

- (instancetype)initWithAccount:(Account *)account;

@end
