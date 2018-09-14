//
//  EditorView.m
//  OCR
//
//  Created by Apple on 16/10/12.
//  Copyright © 2016年 Choyea. All rights reserved.
//

#import "EditorView.h"

static CGFloat editLineH = 20;
static CGFloat cornerLineW = 4;
static CGFloat lineW = 2;
static CGFloat duration = 0.25;


@interface EditorView(){
//    BOOL _canScale;
    NSInteger _currentCorner;
    CGPoint  _lastPoint;
}

@property (strong, nonatomic) UIButton *lightBtn;

@end

@implementation EditorView


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
        [self setUpLightBtn];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
        [self setUpLightBtn];
    }
    return self;
}

- (void)setUpLightBtn {
    CGFloat width = 150.0;
    CGFloat height = 100.0;
    self.lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lightBtn.frame = CGRectMake(self.frame.size.width/2.0 - width/2.0, self.frame.size.height - height, width, height);
    [self.lightBtn setImage:[UIImage imageNamed:@"Wallet.bundle/transation/transation_light_off"] forState:UIControlStateNormal];
    [self.lightBtn setImage:[UIImage imageNamed:@"Wallet.bundle/transation/transation_light_on"] forState:UIControlStateSelected];
    [self.lightBtn setTitle:kLocalizable(@"开启灯光") forState:UIControlStateNormal];
    [self.lightBtn.titleLabel setFont:kSys_font(10)];
    [self.lightBtn setTitle:kLocalizable(@"关闭灯光") forState:UIControlStateSelected];
    [self.lightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.lightBtn setTitleColor:kMain_Color forState:UIControlStateSelected];
    [self.lightBtn addTarget:self action:@selector(lightBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize titleSize;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        titleSize = self.lightBtn.titleLabel.intrinsicContentSize;
    } else {
        titleSize = self.lightBtn.titleLabel.frame.size;
    }
    CGSize imageSize = self.lightBtn.imageView.bounds.size;
    //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [self.lightBtn setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + titleSize.height + 20,-imageSize.width, 0.0,0.0)];
    //图片距离右边框距离减少图片的宽度，其它不变
    [self.lightBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -titleSize.width)];
    
    [self addSubview:self.lightBtn];
}

- (void)showLightBtn {
    if (self.lightBtn.hidden == NO) return;
    self.lightBtn.hidden = NO;
    self.lightBtn.layer.opacity = 1.0;
    [self.lightBtn.layer addAnimation:[self opacityForever_Animation:duration hidden:NO] forKey:nil];
}

- (void)hidLightBtn {
    if (self.lightBtn.hidden == YES) return;
    self.lightBtn.hidden = YES;
    self.lightBtn.layer.opacity = 0.0;
}


#pragma mark === 永久闪烁的动画 ======
-(CABasicAnimation *)opacityForever_Animation:(float)time hidden:(BOOL)hidden {
    
    CGFloat fromValue = hidden?0:1;
    CGFloat toValue = hidden?1:0;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:fromValue];
    animation.toValue = [NSNumber numberWithFloat:toValue];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = 3;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

#pragma mark - btnOnClick

- (void)lightBtnOnClick:(UIButton *)btn {
    // 如果btn为选中状态，直接调用隐藏方法
    if (btn.selected) {
        [self hidLightBtn];
    }
    
    btn.selected = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(light:)]) {
        [self.delegate light:btn.isSelected];
    }
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, lineW);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);

    CGContextAddRect(context, rect);
    
    CGContextDrawPath(context, kCGPathStroke);
    

    CGPoint aPoints[2];
    CGPoint bPoints[2];
    CGPoint cPoints[2];
    CGPoint dPoints[2];
    CGPoint ePoints[2];
    CGPoint fPoints[2];
    CGPoint gPoints[2];
    CGPoint hPoints[2];
    
    
    aPoints[0] =CGPointMake(0, 0);//坐标1
    aPoints[1] =CGPointMake(0, editLineH);//坐标2
    
    bPoints[0] =CGPointMake(0, 0);//坐标1
    bPoints[1] =CGPointMake(editLineH, 0);//坐标2
    
    cPoints[0] =CGPointMake(rect.size.width - editLineH, 0);//坐标1
    cPoints[1] =CGPointMake(rect.size.width, 0);//坐标2
    
    dPoints[0] =CGPointMake(rect.size.width, 0);//坐标1
    dPoints[1] =CGPointMake(rect.size.width, editLineH);//坐标2
    
    ePoints[0] =CGPointMake(rect.size.width, rect.size.height - editLineH);//坐标1
    ePoints[1] =CGPointMake(rect.size.width, rect.size.height);//坐标2=
    
    fPoints[0] =CGPointMake(rect.size.width, rect.size.height);//坐标1
    fPoints[1] =CGPointMake(rect.size.width - editLineH, rect.size.height);//坐标2
    
    gPoints[0] =CGPointMake(editLineH, rect.size.height);//坐标1
    gPoints[1] =CGPointMake(0, rect.size.height);//坐标2
    
    hPoints[0] =CGPointMake(0, rect.size.height);//坐标1
    hPoints[1] =CGPointMake(0, rect.size.height - editLineH);//坐标2
    
    CGContextSetStrokeColorWithColor(context, kMain_Color.CGColor);
    CGContextSetLineWidth(context, cornerLineW);
    
    CGContextAddLines(context, aPoints, 2);
    CGContextAddLines(context, bPoints, 2);
    CGContextAddLines(context, cPoints, 2);
    CGContextAddLines(context, dPoints, 2);
    CGContextAddLines(context, ePoints, 2);
    CGContextAddLines(context, fPoints, 2);
    CGContextAddLines(context, gPoints, 2);
    CGContextAddLines(context, hPoints, 2);
    
    
    CGContextDrawPath(context, kCGPathStroke);
}


@end
