//
//  QRModelPanInteractiveTransition.h
//  wallet
//
//  Created by 周志伟 on 2018/8/21.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WalletQRViewController;

typedef void(^ModelPanHandler)(UIPanGestureRecognizer *gesture);

@interface QRModelPanInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (assign, nonatomic)  BOOL interactiveDismiss;

-(void)panToDismiss:(WalletQRViewController *)viewcontroller handler:(ModelPanHandler)handler;

@end
