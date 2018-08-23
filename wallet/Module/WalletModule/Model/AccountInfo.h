//
//  AccountInfo.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/31.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"


@interface Key : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) NSInteger weight;

@end


@interface Auth : NSObject

@property (nonatomic, copy) NSArray *accounts;
@property (nonatomic, copy) NSArray <Key *> *keys;
@property (nonatomic, assign) NSInteger threshold;

@end


@interface Permission : NSObject

@property (nonatomic, copy) NSString *parent;
@property (nonatomic, copy) NSString *perm_name;
@property (nonatomic, strong) Auth *required_auth;

@end

@interface Resources :NSObject

@property (nonatomic, copy) NSString *cpu_weight;
@property (nonatomic, copy) NSString *net_weight;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, assign) NSInteger ram_bytes;

@end

@interface NET : NSObject

@property (nonatomic, assign) NSInteger available;
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, assign) NSInteger used;

@end

@interface CPU : NSObject

@property (nonatomic, assign) NSInteger available;
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, assign) NSInteger used;

@end


@interface AccountInfo : NSObject

@property (nonatomic, strong) NSString *account_name;
@property (nonatomic, copy) NSString *core_liquid_balance;
@property (nonatomic, strong) CPU *cpu_limit;
@property (nonatomic, assign) NSInteger cpu_weight;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, assign) double head_block_num;
@property (nonatomic, copy) NSString *head_block_time;
@property (nonatomic, copy) NSString *last_code_update;
@property (nonatomic, strong) NET *net_limit;
@property (nonatomic, assign) NSInteger net_weight;
@property (nonatomic, copy) NSArray <Permission *> *permissions;
@property (nonatomic, assign) NSInteger privileged;
@property (nonatomic, assign) NSInteger ram_quota;
@property (nonatomic, assign) NSInteger ram_usage;
@property (nonatomic, strong) Resources *total_resources;
@property (nonatomic, strong) Account *localAccout;

@end
