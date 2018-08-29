//
//  Exchange.h
//  wallet
//
//  Created by 周志伟 on 2018/8/29.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface data : NSObject

@property (copy, nonatomic) NSString *from;
@property (copy, nonatomic) NSString *to;
@property (copy, nonatomic) NSString *memo;

@end

@interface authorization : NSObject

@property (copy, nonatomic) NSString *actor;
@property (copy, nonatomic) NSString *permission;

@end

@interface Exchange : NSObject

@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *account;
@property (copy, nonatomic) NSString *action_num;
@property (copy, nonatomic) NSString *expiration;
@property (copy, nonatomic) NSString *from;
@property (copy, nonatomic) NSString *mome;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *quantity;
@property (copy, nonatomic) NSString *to;
@property (copy, nonatomic) NSString *transfer;
@property (copy, nonatomic) NSString *trx_id;

@end
