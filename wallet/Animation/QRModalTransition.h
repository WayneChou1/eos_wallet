//
//  QRModalTransition.h
//  wallet
//
//  Created by 周志伟 on 2018/8/21.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QRModalTransitionType) {
    kQRModalTransitionPresent = 1 << 1,
    kQRModalTransitionDismiss = 1 << 2
};

@interface QRModalTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (QRModalTransition *)transitionWithType:(QRModalTransitionType)type
                                 duration:(NSTimeInterval)duration;

@end
