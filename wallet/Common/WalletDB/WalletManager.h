//
//  WalletManager.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/24.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wallet.h"

@interface WalletManager : NSObject



/**
 创建单例

 @return 实例对象
 */
+ (instancetype)shareManager;


/**
 插入钱包

 @param Wallets 待插入钱包数组
 @return BOOL 是否成功
 */
- (BOOL)insertWallets:(NSArray <Wallet *> *)Wallets;


/**
 查询所有钱包

 @return 所有钱包
 */
- (NSArray<Wallet *> *)selectAllWallets;


/**
 查询单个钱包

 @param UUID 钱包唯一标识
 @return 单个钱包
 */
- (Wallet *)selectWalletsFromUUID:(NSString *)UUID;


/**
 删除单个钱包

 @param UUID 钱包唯一标识
 @return 是否成功
 */
- (BOOL)deleteWalletsWithUUID:(NSString *)UUID;


/**
 删除所有钱包

 @return 是否成功
 */
- (BOOL)deleteAllWallets;



/**
 更新钱包名称和密码提示

 @param wallet wallet
 @return 是否更新成功
 */
- (BOOL)updateWalletNameAndPswHintWithWallet:(Wallet *)wallet;


/**
 更新表
 */
- (BOOL)updateTable;

@end
