//
//  WalletManager.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/24.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "WalletManager.h"
#import "Wallet+WCTTableCoding.h"
#import <WCDB.h>

static NSString * const TABLE_WCDB_NAME = @"wallet_eos";
static NSString * const DB_WCDB_NAME = @"wallet.db";

@interface WalletManager ()

@property (nonatomic,strong) WCTDatabase *database;

@end

@implementation WalletManager

+ (instancetype)shareManager {
    static WalletManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[WalletManager alloc] init];
            if ([manager creatDatabase]) {
                wLog(@"数据库创建成功");
            }else{
                wLog(@"数据库创建失败");
            }
        }
    });
    return manager;
}

//获得存放数据库文件的沙盒地址
- (NSString *)wcdbFilePath {
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:DB_WCDB_NAME];
    return dbFilePath;
}

//1.创建数据库的操作
- (BOOL)creatDatabase{
    _database = [[WCTDatabase alloc] initWithPath:[self wcdbFilePath]];
    if (![_database isTableExists:TABLE_WCDB_NAME]) {
        BOOL result = [_database createTableAndIndexesOfName:TABLE_WCDB_NAME withClass:Wallet.class];
        return result;
    }
    return YES;
}

- (BOOL)updateTable {
    _database = [[WCTDatabase alloc] initWithPath:[self wcdbFilePath]];
    BOOL result = [_database createTableAndIndexesOfName:TABLE_WCDB_NAME withClass:Wallet.class];
    return result;
}


- (BOOL)insertWallets:(NSArray<Wallet *> *)Wallets {
    if (_database == nil) {
        [self creatDatabase];
    }
    return [_database insertObjects:Wallets into:TABLE_WCDB_NAME];
}

- (Wallet *)selectWalletsFromUUID:(NSString *)UUID {
    if (_database == nil) {
        [self creatDatabase];
    }
    
    NSArray <Wallet *>*dataArr = [_database getObjectsOfClass:Wallet.class fromTable:TABLE_WCDB_NAME where:Wallet.walletUUID == UUID];
    
    if (dataArr.count == 1) {
        return dataArr.firstObject;
    }
    
    return nil;
}

- (NSArray<Wallet *> *)selectAllWallets {
    if (_database == nil) {
        [self creatDatabase];
    }
    return [_database getAllObjectsOfClass:Wallet.class fromTable:TABLE_WCDB_NAME];
}

- (BOOL)updateWallet:(Wallet *)wallet {
    if (_database == nil) {
        [self creatDatabase];
    }
    return[_database updateRowsInTable:TABLE_WCDB_NAME onProperties:{Wallet.walletName,Wallet.pswHint,Wallet.walletMD5pwd} withObject:wallet where:Wallet.ID == wallet.ID];
}


- (BOOL)deleteWalletsWithUUID:(NSString *)UUID {
    if (_database == nil) {
        [self creatDatabase];
    }
    return [_database deleteObjectsFromTable:TABLE_WCDB_NAME where:Wallet.walletUUID == UUID];
}

- (BOOL)deleteAllWallets {
    if (_database == nil) {
        [self creatDatabase];
    }
    return [_database deleteAllObjectsFromTable:TABLE_WCDB_NAME];
}

@end
