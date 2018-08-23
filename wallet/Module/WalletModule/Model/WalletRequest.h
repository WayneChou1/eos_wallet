//
//  WalletRequest.h
//  wallet
//
//  Created by zhouzhiwei on 2018/8/1.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wallet.h"
#import "AccountInfo.h"

@interface WalletRequest : NSObject

@property (nonatomic, strong) Wallet *wallet;

- (void)getAccountInfo:(void(^)(AccountInfo *accountInfo,BOOL success,WalletRequest *request))response;

@end
