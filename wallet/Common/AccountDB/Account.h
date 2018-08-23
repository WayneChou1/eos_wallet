//
//  Account.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/31.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject


/**
 自增 id
 */
@property(nonatomic, assign) NSInteger ID;


/**
 钱包id
 */
@property(nonatomic, copy) NSString *walletID;

/**
 账号
 */
@property(nonatomic, copy) NSString *accountName;


/**
 ower 公钥
 */
@property(nonatomic, copy) NSString *ownerPublickKey;

/**
 active 公钥
 */
@property(nonatomic, copy) NSString *activePublickKey;

/**
 ower 私钥
 */
@property(nonatomic, copy) NSString *ownerPrivatekKey;

/**
 active 私钥
 */
@property(nonatomic, copy) NSString *activePrivatekKey;

@end
