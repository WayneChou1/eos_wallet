//
//  Web3UrlHelper.h
//  wallet
//
//  Created by zhouzhiwei on 2018/9/4.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Web3UrlHelper : NSObject

+ (instancetype)standardHelper;

- (NSString *)currentWebUrl;

- (void)setWebUrl:(NSDictionary *)webDic;

@end
