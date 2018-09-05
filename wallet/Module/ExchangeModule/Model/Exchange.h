//
//  Exchange.h
//  wallet
//
//  Created by 周志伟 on 2018/8/29.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject

@property (copy, nonatomic) NSString *from;
@property (copy, nonatomic) NSString *to;
@property (copy, nonatomic) NSString *memo;
@property (copy, nonatomic) NSString *quantity;

@end

@interface Authorization : NSObject

@property (copy, nonatomic) NSString *actor;
@property (copy, nonatomic) NSString *permission;

@end

@interface Exchange : NSObject

@property (copy, nonatomic) NSString *action_num;
@property (copy, nonatomic) NSString *expiration;
@property (copy, nonatomic) NSString *handler_account;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *trx_id;
@property (strong, nonatomic) Authorization *authorization;
@property (strong, nonatomic) Data *data;

@end
