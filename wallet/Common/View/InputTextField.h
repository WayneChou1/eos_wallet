//
//  InputTextField.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/25.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputTextField : UIView

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) UIColor *shadowColor;

@property (assign, nonatomic) CGFloat cornerRadius;

@property (assign, nonatomic) UIEdgeInsets edgeInset;


- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)setTitleForActionBtn:(NSString *)title forState:(UIControlState)state;

- (void)setImageForActionBtn:(UIImage *)img forState:(UIControlState)state;

- (void)setWidthForActionBtn:(CGFloat)width;

@end
