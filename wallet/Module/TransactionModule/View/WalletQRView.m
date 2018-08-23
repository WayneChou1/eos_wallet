//
//  WalletQRView.m
//  wallet
//
//  Created by 周志伟 on 2018/8/22.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "WalletQRView.h"
#import <CoreImage/CoreImage.h>
#import "UIImage+Compression.h"

static CGFloat arrowWidthOffset = 15.0;
static CGFloat arrowHeightOffset = 8.0;

@interface WalletQRView ()

@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageV;
@property (weak, nonatomic) IBOutlet UIButton *copBtn;

@end

@implementation WalletQRView


- (instancetype)initWithFrame:(CGRect)frame publickey:(NSString *)publicKey {
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:@"WalletQRView" owner:nil options:nil];
    
    if (viewArr.count != 0 && viewArr) {
        self = viewArr.firstObject;
        self.frame = frame;
        self.addressLab.text = publicKey;
        self.qrImageV.image = [self createImageWithString:publicKey];
        
        [self setUp];
    }
    return self;
}

#pragma mark - Subviews

- (void)setUp {
//    self.layer.cornerRadius = 5.0;
}

#pragma mark - createQRCode

- (UIImage *)createImageWithString:(NSString *)str {
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
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

#pragma mark - btnOnClick

- (IBAction)copyBtnOnClick:(id)sender {
}

- (void)drawRect:(CGRect)rect {
    // Drawing code.
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapRound);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 3.0);
    
    //设置颜色
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, self.frame.size.width/2.0 - arrowWidthOffset, 2*arrowHeightOffset);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, self.frame.size.width/2.0, arrowHeightOffset);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, self.frame.size.width/2.0 + arrowWidthOffset, 2*arrowHeightOffset);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}

@end
