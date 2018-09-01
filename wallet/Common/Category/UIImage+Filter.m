//
//  UIImage+Filter.m
//  wallet
//
//  Created by 周志伟 on 2018/9/2.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "UIImage+Filter.h"
#import "UIImage+Compression.h"

NSString * const CIQRCode = @"CIQRCodeGenerator";

@implementation UIImage (Filter)

+ (UIImage *)createImageWithString:(NSString *)str filterWithName:(NSString *)name {
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:name];
    // 2.恢复滤镜的默认属性（因为滤镜可能保存上一次的属性）
    [filter setDefaults];
    
    // 3.讲字符串转换为NSData
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 4.通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5.通过了滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 6.因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
    return [UIImage getErWeiMaImageFormCIImage:outputImage withSize:200];
}

@end
