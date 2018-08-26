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

static CGFloat arrow_width_offset = 15.0;
static CGFloat arrow_height_offset = 8.0;
static CGFloat max_pan_height = 100.0;

static CGFloat top_offset = 40.0;

@interface WalletQRView (){
    BOOL _canDismiss;
}

@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageV;
@property (weak, nonatomic) IBOutlet UIButton *copBtn;

@property (assign, nonatomic) CGRect contentFrame;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation WalletQRView


- (instancetype)initWithFrame:(CGRect)frame publickey:(NSString *)publicKey {
    
    self = [super init];
    if (self) {
         NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:@"WalletQRView" owner:self options:nil];
        if (viewArr.count != 0 && viewArr) {
            self.contentView = viewArr.firstObject;
            self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self addSubview:self.contentView];
            
            self.contentFrame = self.contentView.frame;
            self.frame = frame;
            self.backgroundColor = [UIColor clearColor];
            self.addressLab.text = publicKey;
            self.qrImageV.image = [self createImageWithString:publicKey];
            
            [self.copBtn setTitle:kLocalizable(@"复制") forState:UIControlStateNormal];
        }
    }
    
    return self;
}

- (void)showQRWithDuration:(CGFloat)duration isShow:(BOOL)isShow{
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (isShow) {
            self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }else{
            self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
    } completion:^(BOOL finished) {
        self.contentFrame = self.contentView.frame;
    }];
}



#pragma mark - public

-(void)panGestureAction:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged:{
            //1
            [self panViewWithPoint:translation];
            if (translation.y >= max_pan_height) {
                _canDismiss = YES;
                [self setNeedsDisplay];
            }else{
                _canDismiss = NO;
                [self setNeedsDisplay];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            //2
            if (gesture.state == UIGestureRecognizerStateCancelled) {
                [self showQRWithDuration:duration isShow:YES];
            }else{
                if (translation.y >= max_pan_height) {
                    [self showQRWithDuration:duration isShow:NO];
                }else{
                    [self showQRWithDuration:duration isShow:YES];
                }
                
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - private

- (void)panViewWithPoint:(CGPoint)point {
    // 移动二维码视图
    self.contentView.frame = CGRectMake(self.contentFrame.origin.x, self.contentFrame.origin.y + point.y, self.contentFrame.size.width, self.contentFrame.size.height);
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
    [MBProgressHUD zj_showViewAfterSecondWithView:self title:@"复制成功" afterSecond:0.5];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.addressLab.text;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code.
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapRound);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 4.0);
    
    //设置颜色
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    //开始一个起始路径
    CGContextBeginPath(context);
    
    if (_canDismiss) {
        //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
        CGContextMoveToPoint(context, self.frame.size.width/2.0 - arrow_width_offset, 2*arrow_height_offset + top_offset);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, self.frame.size.width/2.0 + arrow_width_offset, 2*arrow_height_offset + top_offset);
        //连接上面定义的坐标点
        CGContextStrokePath(context);
    }else{
        
        //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
        CGContextMoveToPoint(context, self.frame.size.width/2.0 - arrow_width_offset, 2*arrow_height_offset + top_offset);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, self.frame.size.width/2.0, arrow_height_offset + top_offset);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, self.frame.size.width/2.0 + arrow_width_offset, 2*arrow_height_offset + top_offset);
        //连接上面定义的坐标点
        CGContextStrokePath(context);
    }
    
}

@end
