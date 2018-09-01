//
//  HTTPRequestUrl.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/31.
//  Copyright © 2018年 eos. All rights reserved.
//

#ifndef HTTPRequestUrl_h
#define HTTPRequestUrl_h

#define eos_get_account @"v1/chain/get_account" // 获取账号信息
#define eos_get_info @"v1/chain/get_info" // 获取区块信息
#define eos_get_required_keys @"v1/chain/get_required_keys" // 获取公钥
#define eos_push_transaction @"v1/chain/push_transaction" // 提交区块
#define eos_abi_json_to_bin @"v1/chain/abi_json_to_bin" // 获取行动码
#define eos_get_actions @"v1/history/get_actions" // 获取交易记录

#define eos_get_transfer @"transfer"

#define eosmonitor(account,action,page,pagesize) [NSString stringWithFormat:@"%@/actions?action=%@&page=%@&pagesize=%@",account,action,page,pagesize]

///account/zzzzzzzzzzss/actions?action=transfer&page=1&pagesize=10
//http://eosmonitor.io/api/v1/account/zzzzzzzzzzss/actions?action=deleteauth&page=1&pagesize=10
#endif /* HTTPRequestUrl_h */
