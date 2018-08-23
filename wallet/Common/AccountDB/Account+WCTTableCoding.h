//
//  Account+WCTTableCoding.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/31.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "Account.h"
#import <WCDB/WCDB.h>

@interface Account (WCTTableCoding) <WCTTableCoding>

// 需要绑定到表中的字段在这里声明，在.mm中去绑定
WCDB_PROPERTY(ID)
WCDB_PROPERTY(walletID)
WCDB_PROPERTY(accountName)
WCDB_PROPERTY(ownerPublickKey)
WCDB_PROPERTY(activePublickKey)
WCDB_PROPERTY(ownerPrivatekKey)
WCDB_PROPERTY(activePrivatekKey)

@end
