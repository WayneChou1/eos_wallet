//
//  MainAssetViewController.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/16.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockChain : NSObject
@property(nonatomic, strong) NSString *server_version;
@property(nonatomic, strong) NSNumber *head_block_num;
@property(nonatomic, strong) NSString *last_irreversible_block_num;
@property(nonatomic, strong) NSString *chain_id;
@property(nonatomic, strong) NSString *head_block_id;
@property(nonatomic, strong) NSString *head_block_time;
@property(nonatomic, strong) NSString *head_block_producer;
@property(nonatomic, strong) NSString *recent_slots;
@property(nonatomic, strong) NSString *participation_rate;
@end
