//
//  Account.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/31.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "Account.h"
#import "Account+WCTTableCoding.h"
#import <WCDB.h>

@implementation Account

// 自增
- (instancetype)init {
    self = [super init];
    if (self) {
        self.isAutoIncrement = YES;
    }
    return self;
}

// 利用这个宏定义绑定到表的类
WCDB_IMPLEMENTATION(Account)

// 下面宏定义绑定到表中的字段
WCDB_SYNTHESIZE(Account, ID)
WCDB_SYNTHESIZE(Account, walletID)
WCDB_SYNTHESIZE(Account, accountName)
WCDB_SYNTHESIZE(Account, ownerPublickKey)
WCDB_SYNTHESIZE(Account, activePublickKey)
WCDB_SYNTHESIZE(Account, ownerPrivatekKey)
WCDB_SYNTHESIZE(Account, activePrivatekKey)

// 约束宏定义数据库的主键
WCDB_PRIMARY_AUTO_INCREMENT(Account, ID)

@end
