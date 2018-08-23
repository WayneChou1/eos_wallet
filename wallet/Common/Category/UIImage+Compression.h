//
//  UIImage+Compression.h
//  Underworld
//
//  Created by zhouzhiwei on 2018/7/13.
//  Copyright © 2018年 zijinph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compression)

/**
 *  图片压缩
 *
 *  @param sourceImage   被压缩的图片
 *  @param defineWidth 被压缩的尺寸(宽)
 *
 *  @return 被压缩的图片
 */
+ (UIImage *)imageCompressed:(UIImage *)sourceImage withdefineWidth:(CGFloat)defineWidth;


/**
 获取高清图片

 @param image 原图像
 @param size 图像大小
 @return 高清图片
 */
+ (UIImage *)getErWeiMaImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

@end
