//
//  NSString+RegularExp.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "NSString+RegularExp.h"

@implementation NSString (RegularExp)

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber{
    NSString *pattern = @"^[1][3,4,5,6,7,8,9][0-9]{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}


#pragma 正则匹配eos用户账号,只包含字母数字
+ (BOOL)checkEosAccount : (NSString *) account{
    NSString *verifyAccountNameRegex = @"^[a-z]{1}[1-5a-z]{11}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",verifyAccountNameRegex];
    BOOL isMatch = [predicate evaluateWithObject:account];
    return isMatch;
}


#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}


#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url{
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
}

@end
