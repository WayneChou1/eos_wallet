//
//  TransactionViewController.h
//  wallet
//
//  Created by zhouzhiwei on 2018/8/1.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "BaseViewController.h"

@class Account;

@interface TransactionViewController : BaseViewController


/**
 初始化方法

 @param account account
 @return 实例对象
 */
- (instancetype)initWithAccount:(Account *)account;

@end
