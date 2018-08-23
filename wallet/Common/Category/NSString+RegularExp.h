//
//  NSString+RegularExp.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegularExp)

// 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;

// 正则匹配eos用户账号,只包含字母数字
+ (BOOL)checkEosAccount:(NSString *) account;

// 正则匹配用户身份证号
+ (BOOL)checkUserIdCard:(NSString *) idCard;

// 正则匹配URL
+ (BOOL)checkURL:(NSString *) url;

@end
