//
//  QRModelPanInteractiveTransition.m
//  wallet
//
//  Created by 周志伟 on 2018/8/21.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "QRModelPanInteractiveTransition.h"

@interface QRModelPanInteractiveTransition ()

@property(nonatomic,strong)UIViewController *presentedVC;

@end

@implementation QRModelPanInteractiveTransition

-(void)panToDismiss:(UIViewController *)viewcontroller{
    self.presentedVC = viewcontroller;
    UIPanGestureRecognizer *panGstR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    [self.presentedVC.view addGestureRecognizer:panGstR];
}

#pragma mark -panGestureAction

-(void)panGestureAction:(UIPanGestureRecognizer *)gesture{
    CGPoint translation = [gesture translationInView:self.presentedVC.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged:{
            //1
            CGFloat percent = (translation.y/100) <= 1 ? (translation.y/100):1;
            [self updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            //2
            if (gesture.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }else{
                [self finishInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

@end
