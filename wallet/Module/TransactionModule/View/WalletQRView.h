//
//  WalletQRView.h
//  wallet
//
//  Created by 周志伟 on 2018/8/22.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSTimeInterval duration = 0.35;

@interface WalletQRView : UIView

- (instancetype)initWithFrame:(CGRect)frame publickey:(NSString *)publicKey;

-(void)panGestureAction:(UIPanGestureRecognizer *)gesture;

- (void)showQRWithDuration:(CGFloat)duration isShow:(BOOL)isShow;

@end
