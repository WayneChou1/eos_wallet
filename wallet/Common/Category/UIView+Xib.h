//
//  UIView+Xib.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/18.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Xib)

@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
@property (nonatomic, strong)IBInspectable UIColor *borderColor;

@end
