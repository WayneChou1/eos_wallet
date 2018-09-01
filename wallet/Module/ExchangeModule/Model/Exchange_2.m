//
//  Exchange_2.m
//  wallet
//
//  Created by 周志伟 on 2018/8/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "Exchange_2.h"

@implementation Data
@end

@implementation Authorization
@end

@implementation Act

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"data":[Data class],
             @"authorization":[Authorization class]
             };
}

@end

@implementation Receipt
@end

@implementation Action_trace

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"receipt":[Receipt class],
             @"act":[Act class]
             };
}


@end

@implementation Exchange_2

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"action_trace":[Action_trace class]};
}

@end
