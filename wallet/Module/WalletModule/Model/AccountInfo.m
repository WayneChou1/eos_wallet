//
//  AccountInfo.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/31.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "AccountInfo.h"

@implementation CPU

@end

@implementation NET

@end

@implementation Resources

@end

@interface Auth () <YYModel>
@end

@implementation Auth

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"keys":[Key class]};
}

@end

@implementation Key

@end

@implementation Permission

@end


@interface AccountInfo () <YYModel>
@end

@implementation AccountInfo

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"permissions":[Permission class]};
}

@end
