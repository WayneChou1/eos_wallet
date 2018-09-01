//
//  Exchange_2.h
//  wallet
//
//  Created by 周志伟 on 2018/8/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Authorization : NSObject

@property (copy, nonatomic) NSString *actor;
@property (copy, nonatomic) NSString *permission;

@end

@interface Data : NSObject

@property (copy, nonatomic) NSString *from;
@property (copy, nonatomic) NSString *to;
@property (copy, nonatomic) NSString *quantity;
@property (copy, nonatomic) NSString *memo;

@end

@interface Act : NSObject

@property (copy, nonatomic) NSString *account;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *hex_data;
@property (strong, nonatomic) Authorization *authorization;
@property (strong, nonatomic) Data *data;

@end


@interface Receipt : NSObject

@property (copy, nonatomic) NSString *receiver;
@property (copy, nonatomic) NSString *act_digest;
@property (copy, nonatomic) NSString *global_sequence;
@property (copy, nonatomic) NSString *recv_sequence;
@property (copy, nonatomic) NSString *elapsed;
@property (copy, nonatomic) NSString *code_sequence;
@property (copy, nonatomic) NSString *abi_sequence;
@property (copy, nonatomic) NSArray *auth_sequence;

@end


@interface Action_trace : NSObject

@property (strong, nonatomic) Receipt *receipt;
@property (strong, nonatomic) Act *act;

@end

@interface Exchange_2 : NSObject

@property (copy, nonatomic) NSString *global_action_seq;
@property (copy, nonatomic) NSString *account_action_seq;
@property (copy, nonatomic) NSString *block_num;
@property (copy, nonatomic) NSString *block_time;
@property (copy, nonatomic) NSString *elapsed;
@property (copy, nonatomic) NSString *cpu_usage;
@property (copy, nonatomic) NSString *console;
@property (copy, nonatomic) NSString *total_cpu_usage;
@property (copy, nonatomic) NSString *trx_id;
@property (copy, nonatomic) NSString *inline_traces;
@property (strong, nonatomic) Action_trace *action_trace;

@end
