//
//  Web3UrlHelper.m
//  wallet
//
//  Created by zhouzhiwei on 2018/9/4.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "Web3UrlHelper.h"

static NSString * const web3_save_name = @"web3Url.plist";

static NSString *const web_url_key = @"url";

@implementation Web3UrlHelper

+ (instancetype)standardHelper {
    static Web3UrlHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[Web3UrlHelper alloc] init];
    });
    return helper;
}

- (NSString *)currentWebUrl {
    
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:web3_save_name];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    if ([dic objectForKey:web_url_key]) {
        return [dic objectForKey:web_url_key];
    }
    return nil;
}

- (void)setWebUrl:(NSDictionary *)webDic {
    
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:web3_save_name];
    
    //下边if判断很重要，不然会写入失败.
    if (!webDic) {
        webDic = [[NSMutableDictionary alloc] init];
    }
    
    //写入文件
    [webDic writeToFile:plistPath atomically:YES];
}

@end
