//
//  BootPageControl.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/16.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "BootPageControl.h"

@interface BootPageControl ()

@property (nonatomic, strong) UIImage *imagePageStateNormal;
@property (nonatomic, strong) UIImage *imagePageStateHighlighted;

@end

@implementation BootPageControl

- (void)setImagePageStateNormal:(UIImage *)imageNormal ImagePageStateHighlighted:(UIImage *)imageHighlighted {
    // 设置正常状态点按钮的图片
    self.imagePageStateNormal = imageNormal;
    self.imagePageStateHighlighted = imageHighlighted;
    [self updateDots];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

- (void)updateDots { // 更新显示所有的点按钮
    if (self.imagePageStateNormal || self.imagePageStateHighlighted){
        NSArray *subview = self.subviews;  // 获取所有子视图
        for (NSInteger i = 0; i < [subview count]; i++){
            UIImageView *dot = [subview objectAtIndex:i];
            dot.image = self.currentPage == i ? self.imagePageStateNormal : self.imagePageStateHighlighted;
        }
    }
}

@end
