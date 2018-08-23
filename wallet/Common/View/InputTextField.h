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

@end
