//
//  UIImage+Filter.h
//  wallet
//
//  Created by 周志伟 on 2018/9/2.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const CIQRCode;

@interface UIImage (Filter)

+ (UIImage *)createImageWithString:(NSString *)str filterWithName:(NSString *)name;

@end
