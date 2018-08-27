//
//  QRModelPanInteractiveTransition.m
//  wallet
//
//  Created by 周志伟 on 2018/8/21.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "QRModelPanInteractiveTransition.h"
#import "WalletQRViewController.h"
#import "WalletQRView.h"

static CGFloat max_pan_height = 100.0;

@interface QRModelPanInteractiveTransition ()

@property(nonatomic, weak) WalletQRViewController *presentedVC;
@property (nonatomic, copy)ModelPanHandler handler;

@end

@implementation QRModelPanInteractiveTransition

-(void)panToDismiss:(WalletQRViewController *)viewcontroller handler:(ModelPanHandler)handler{
    self.presentedVC = viewcontroller;
    self.handler = handler;
    UIPanGestureRecognizer *panGstR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    [self.presentedVC.view addGestureRecognizer:panGstR];
}

#pragma mark -panGestureAction

-(void)panGestureAction:(UIPanGestureRecognizer *)gesture{
    CGPoint translation = [gesture translationInView:self.presentedVC.view];
    self.handler(gesture);
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.interactiveDismiss = YES;
            [self.presentedVC dismissViewControllerAnimated:YES completion:nil];
        }
        case UIGestureRecognizerStateChanged:{
            //1
            CGFloat percent = (translation.y/SCREEN_HEIGHT) <= 1 ? (translation.y/SCREEN_HEIGHT):1;
            [self.presentedVC panViewController:percent];
            [self updateInteractiveTransition:percent];

            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            //2
            if (gesture.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }else{
                if (translation.y >= max_pan_height) {
                    self.interactiveDismiss = YES;
                    NSTimeInterval d = (1.0 - (translation.y/SCREEN_HEIGHT)) * duration;
                    [self.presentedVC dismiss:d completion:^{
                       [self finishInteractiveTransition];
                    }];
                }else{
                    self.interactiveDismiss = NO;
                    NSTimeInterval d = (translation.y/SCREEN_HEIGHT) * duration;
                    [self.presentedVC show:d present:NO completion:^{
                        [self cancelInteractiveTransition];
                    }];
                }
                
            }
            break;
        }
        default:
            break;
    }
}

@end
