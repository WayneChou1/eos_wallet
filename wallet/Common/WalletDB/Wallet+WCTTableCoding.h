//
//  Wallet+WCTTableCoding.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/24.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "Wallet.h"
#import <WCDB/WCDB.h>

@interface Wallet (WCTTableCoding) <WCTTableCoding>

// 需要绑定到表中的字段在这里声明，在.mm中去绑定
WCDB_PROPERTY(ID)
WCDB_PROPERTY(walletName)
WCDB_PROPERTY(walletUUID)
WCDB_PROPERTY(walletMD5pwd)
WCDB_PROPERTY(createTime)
WCDB_PROPERTY(pswHint)

@end
