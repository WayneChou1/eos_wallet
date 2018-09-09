//
//  ResourceViewController.h
//  wallet
//
//  Created by 周志伟 on 2018/9/9.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountInfo;

@interface ResourceViewController : UITableViewController

- (instancetype)initWithAccountName:(NSString *)accountName;
- (instancetype)initWithAccountInfo:(AccountInfo *)accountInfo;

@end
