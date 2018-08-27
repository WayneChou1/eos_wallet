//
//  WalletQRViewController.h
//  wallet
//
//  Created by 周志伟 on 2018/8/20.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "BaseViewController.h"

@interface WalletQRViewController : BaseViewController


/**
 初始化方法

 @param publicKey 公钥
 @return 实例对象
 */
- (instancetype)initWithPublicKey:(NSString *)publicKey;

- (void)show:(NSTimeInterval)duration present:(BOOL)present completion:(void(^)(void))completion;
- (void)dismiss:(NSTimeInterval)duration completion:(void(^)(void))completion;
- (void)panViewController:(CGFloat)percent;

@end
