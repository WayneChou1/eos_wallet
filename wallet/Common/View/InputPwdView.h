//
//  InputPwdView.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/26.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat inputViewWidth = 250.0;
static CGFloat inputViewHeight = 140.0;

typedef void(^InputPwdHandler)(BOOL pwdValied,BOOL isCanceled,NSString *psw);

@interface InputPwdView : UIView

- (void)showInView:(UIView *)view handler:(InputPwdHandler)handler;

@end
