//
//  BootPageControl.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/16.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BootPageControl : UIPageControl


/**
 自定义PageControl图

 @param imageNormal 正常状态下
 @param imageHighlighted 选中状态下
 */
- (void)setImagePageStateNormal:(UIImage *)imageNormal ImagePageStateHighlighted:(UIImage *)imageHighlighted;

@end
