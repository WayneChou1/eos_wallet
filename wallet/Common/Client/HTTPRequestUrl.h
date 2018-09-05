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


// eosmonitor actions
#define eosmonitor(account,action,page,pagesize) [NSString stringWithFormat:@"actions?name=%@&account=%@&page=%@&per_page=%@",action,account,page,pagesize]

#define eos_get_transfer @"transfer"


// eosmonitor API
#define eos_get_transaction_action(transaction_id) [NSString stringWithFormat:@"transactions/%@/actions",transaction_id]


#endif /* HTTPRequestUrl_h */
//https://api.eosmonitor.io/v1/transactions/<transaction_id>/actions
