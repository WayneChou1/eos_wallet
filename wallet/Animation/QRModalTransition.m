//
//  QRModalTransition.m
//  wallet
//
//  Created by 周志伟 on 2018/8/21.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "QRModalTransition.h"
#import "WalletQRViewController.h"

@interface QRModalTransition ()

@property (nonatomic, assign) QRModalTransitionType type;
@property (nonatomic, assign) NSTimeInterval duration;

@end

@implementation QRModalTransition

+ (QRModalTransition *)transitionWithType:(QRModalTransitionType)type
                                  duration:(NSTimeInterval)duration {
    QRModalTransition *transition = [[QRModalTransition alloc] init];
    
    transition.type = type;
    transition.duration = duration;
    
    return transition;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if ([toVC isKindOfClass:[WalletQRViewController class]] && self.type == kQRModalTransitionPresent) {
        // present
        UIView *containerView = [transitionContext containerView];
        toVC.view.frame = containerView.bounds;
        [containerView addSubview:toVC.view];
        
        WalletQRViewController *qrVC = (WalletQRViewController *)toVC;
        [qrVC show:self.duration present:YES completion:^{
            if ([transitionContext transitionWasCancelled]) {
                //失败了接标记失败
                [transitionContext completeTransition:NO];
            }else{
                //如果成功了，我们需要标记成功，同时让vc1显示出来，然后移除截图视图，
                [transitionContext completeTransition:YES];
            }
        }];
    }else if ([fromVC isKindOfClass:[WalletQRViewController class]] && self.type == kQRModalTransitionDismiss) {
        // dismiss
        WalletQRViewController *qrVC = (WalletQRViewController *)fromVC;
        [qrVC dismiss:self.duration completion:^{
            if ([transitionContext transitionWasCancelled]) {
                //失败了接标记失败
                [transitionContext completeTransition:NO];
            }else{
                //如果成功了，我们需要标记成功，同时让vc1显示出来，然后移除截图视图，
                [transitionContext completeTransition:YES];
            }
        }];
    }
}



//- (void)present:(id<UIViewControllerContextTransitioning>)transitonContext {
//
//    UIViewController *fromVC = [transitonContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toVC = [transitonContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIView *containerView = [transitonContext containerView];
//
//    // 对fromVC.view的截图添加动画效果
//    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
//    tempView.frame = fromVC.view.frame;
//
//    // 对截图添加动画，则fromVC可以隐藏
//    fromVC.view.hidden = YES;
//
//    // 要实现转场，必须加入到containerView中
//    [containerView addSubview:tempView];
//    [containerView addSubview:toVC.view];
//
//    // 我们要设置外部所传参数
//    // 设置呈现的高度
//    toVC.view.frame = CGRectMake(0,
//                                 containerView.frame.size.height,
//                                 containerView.frame.size.width,
//                                 self.presentHeight);
//
//    // 开始动画
//    __weak __typeof(self) weakSelf = self;
//    [UIView animateWithDuration:self.duration delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 / 0.5 options:0 animations:^{
//        // 在Y方向移动指定的高度
//        toVC.view.transform = CGAffineTransformMakeTranslation(0, -weakSelf.presentHeight);
//
//        // 让截图缩放
//        tempView.transform = CGAffineTransformMakeScale(weakSelf.scale.x, weakSelf.scale.y);
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [transitonContext completeTransition:YES];
//        }
//    }];
//}
//
//- (void)dismiss:(id<UIViewControllerContextTransitioning>)transitonContext {
//    UIViewController *fromVC = [transitonContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toVC = [transitonContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIView *containerView = [transitonContext containerView];
//
//    // 取出present时的截图用于动画
//    UIView *tempView = containerView.subviews.lastObject;
//
//    // 开始动画
//    [UIView animateWithDuration:self.duration animations:^{
//        toVC.view.transform = CGAffineTransformIdentity;
//        fromVC.view.transform = CGAffineTransformIdentity;
//
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [transitonContext completeTransition:YES];
//            toVC.view.hidden = NO;
//
//            // 将截图去掉
//            [tempView removeFromSuperview];
//        }
//    }];
//}

@end
