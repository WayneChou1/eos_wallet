//
//  QRModelPanInteractiveTransition.h
//  wallet
//
//  Created by 周志伟 on 2018/8/21.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRModelPanInteractiveTransition : UIPercentDrivenInteractiveTransition

-(void)panToDismiss:(UIViewController *)viewcontroller;

@end
