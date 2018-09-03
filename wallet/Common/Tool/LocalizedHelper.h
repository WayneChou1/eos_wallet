//
//  LocalizedHelper.h
//  wallet
//
//  Created by 周志伟 on 2018/9/3.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kUserLanguage;
extern NSString * const kZh_Hans;
extern NSString * const kEn;
//#define CNS @"zh-Hans"
//#define EN @"en"

@interface LocalizedHelper : NSObject

+ (instancetype)standardHelper;

- (NSBundle *)bundle;

- (NSString *)currentLanguage;

- (void)setUserLanguage:(NSString *)language;

- (NSString *)stringWithKey:(NSString *)key;

@end
