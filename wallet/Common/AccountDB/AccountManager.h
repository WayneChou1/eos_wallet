//
//  AccountManager.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/31.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface AccountManager : NSObject

/**
 创建单例
 
 @return 实例对象
 */
+ (instancetype)shareManager;



/**
 插入账号

 @param accounts 账号
 @return 是否成功
 */
- (BOOL)insertAccounts:(NSArray <Account *> *)accounts;


/**
 查询本地所有账号
 
 @return 所有账号
 */
- (NSArray<Account *> *)selectAllAccounts;



/**
 查询单个钱包内的所有账号

 @param walletId 钱包id
 @return 钱包
 */
- (NSArray<Account *> *)selectAccountsFromWalletID:(NSString *)walletId;


/**
 删除单个账号
 
 @param accountId 钱包唯一标识
 @return 是否成功
 */
- (BOOL)deleteAccountWithID:(NSString *)accountId;


/**
 删除所有账号
 
 @return 是否成功
 */
- (BOOL)deleteAllAccount;


/**
 更新表
 */
- (BOOL)updateTable;


@end
