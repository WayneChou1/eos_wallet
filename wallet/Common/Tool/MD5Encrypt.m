//
//  MD5Encrypt.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/24.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "MD5Encrypt.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *const salt = @"wallet_zzw";

@implementation MD5Encrypt

#pragma mark - 32位 小写 加盐

+(NSString *)MD5ForLower32Bate:(NSString *)str isSalt:(BOOL)isSalt {
    if (isSalt) {
        return [self MD5ForLower32Bate:[NSString stringWithFormat:@"%@%@",salt,str]];
    }else{
        return [self MD5ForLower32Bate:str];
    }
}

+(NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

#pragma mark - 32位 大写 加盐

+(NSString *)MD5ForUpper32Bate:(NSString *)str isSalt:(BOOL)isSalt {
    if (isSalt) {
        return [self MD5ForUpper32Bate:[NSString stringWithFormat:@"%@%@",salt,str]];
    }else{
        return [self MD5ForUpper32Bate:str];
    }
}


+(NSString *)MD5ForUpper32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

#pragma mark - 16位 大写 加盐

+(NSString *)MD5ForUpper16Bate:(NSString *)str isSalt:(BOOL)isSalt {
    if (isSalt) {
        return [self MD5ForUpper16Bate:[NSString stringWithFormat:@"%@%@",salt,str]];
    }else{
        return [self MD5ForUpper16Bate:str];
    }
}

#pragma mark - 16位 大写

+(NSString *)MD5ForUpper16Bate:(NSString *)str{
    
    NSString *md5Str = [self MD5ForUpper32Bate:str];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}


#pragma mark - 16位 小写 加盐

+(NSString *)MD5ForLower16Bate:(NSString *)str isSalt:(BOOL)isSalt {
    if (isSalt) {
        return [self MD5ForLower16Bate:[NSString stringWithFormat:@"%@%@",salt,str]];
    }else{
        return [self MD5ForLower16Bate:str];
    }
}


#pragma mark - 16位 小写
+(NSString *)MD5ForLower16Bate:(NSString *)str{
    
    NSString *md5Str = [self MD5ForLower32Bate:str];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

@end
