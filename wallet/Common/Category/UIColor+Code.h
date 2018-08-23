//
//  UIColor+Code.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/16.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Code)

+ (UIColor *)colorWithHex:(NSInteger)hex;

+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
