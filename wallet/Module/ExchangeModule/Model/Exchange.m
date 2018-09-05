//
//  Exchange.m
//  wallet
//
//  Created by 周志伟 on 2018/8/29.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "Exchange.h"

@implementation Data
@end

@implementation Authorization
@end

@implementation Exchange

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"authorization":[Authorization class],
             @"data":[Data class]
             };
}

@end
