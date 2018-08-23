//
//  Wallet.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/24.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "Wallet.h"
#import "Wallet+WCTTableCoding.h"
#import <WCDB.h>

@implementation Wallet


// 自增
- (instancetype)init {
    self = [super init];
    if (self) {
        self.isAutoIncrement = YES;
    }
    return self;
}

// 利用这个宏定义绑定到表的类
WCDB_IMPLEMENTATION(Wallet)

// 下面宏定义绑定到表中的字段
WCDB_SYNTHESIZE(Wallet, ID)
WCDB_SYNTHESIZE(Wallet, walletName)
WCDB_SYNTHESIZE(Wallet, walletUUID)
WCDB_SYNTHESIZE(Wallet, walletMD5pwd)
WCDB_SYNTHESIZE(Wallet, createTime)
WCDB_SYNTHESIZE(Wallet, pswHint)

// 约束宏定义数据库的主键
WCDB_PRIMARY_AUTO_INCREMENT(Wallet, ID)

@end
