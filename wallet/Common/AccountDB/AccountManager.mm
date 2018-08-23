//
//  AccountManager.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/31.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "AccountManager.h"
#import "Account+WCTTableCoding.h"
#import <WCDB.h>


static NSString * const TABLE_WCDB_NAME = @"account_eos";
static NSString * const DB_WCDB_NAME = @"wallet.db";

@interface AccountManager ()

@property (nonatomic,strong) WCTDatabase *database;

@end

@implementation AccountManager

+ (instancetype)shareManager {
    static AccountManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[AccountManager alloc] init];
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
        BOOL result = [_database createTableAndIndexesOfName:TABLE_WCDB_NAME withClass:Account.class];
        return result;
    }
    return YES;
}

- (BOOL)updateTable {
    _database = [[WCTDatabase alloc] initWithPath:[self wcdbFilePath]];
    BOOL result = [_database createTableAndIndexesOfName:TABLE_WCDB_NAME withClass:Account.class];
    return result;
}

- (BOOL)insertAccounts:(NSArray<Account *> *)accounts {
    if (_database == nil) {
        [self creatDatabase];
    }
    return [_database insertObjects:accounts into:TABLE_WCDB_NAME];
}

- (NSArray<Account *> *)selectAllAccounts {
    if (_database == nil) {
        [self creatDatabase];
    }
    return [_database getAllObjectsOfClass:Account.class fromTable:TABLE_WCDB_NAME];
}

- (NSArray<Account *> *)selectAccountsFromWalletID:(NSString *)walletId {
    if (_database == nil) {
        [self creatDatabase];
    }
    
    NSArray <Account *> *dataArr = [_database getObjectsOfClass:Account.class fromTable:TABLE_WCDB_NAME where:Account.walletID == walletId];
    
    return dataArr;
}

- (BOOL)deleteAccountWithID:(NSString *)accountId {
    if (_database == nil) {
        [self creatDatabase];
    }
    return [_database deleteObjectsFromTable:TABLE_WCDB_NAME where:Account.ID == accountId];
}

- (BOOL)deleteAllAccount {
    if (_database == nil) {
        [self creatDatabase];
    }
    return [_database deleteAllObjectsFromTable:TABLE_WCDB_NAME];
}

@end
