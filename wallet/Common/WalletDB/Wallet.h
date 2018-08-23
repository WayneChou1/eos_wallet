//
//  Wallet.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/24.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wallet : NSObject


/**
 自增ID
 */
@property(nonatomic, assign) NSInteger ID;

/**
 钱包名称
 */
@property(nonatomic, copy) NSString *walletName;

/**
 钱包唯一标识
 */
@property(nonatomic, copy) NSString *walletUUID;

/**
 创建时间
 */
@property (nonatomic, strong) NSDate *createTime;


/**
  密码提示
 */
@property (nonatomic, copy) NSString *pswHint;

/**
 对密码进行 MD5
 */
@property(nonatomic, copy) NSString *walletMD5pwd;

@end
