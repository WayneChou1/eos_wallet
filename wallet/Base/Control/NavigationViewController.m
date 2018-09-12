//
//  NavigationViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/16.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "NavigationViewController.h"
#import "UIImage+Color.h"

@interface NavigationViewController () <UINavigationControllerDelegate,UIGestureRecognizerDelegate,UINavigationBarDelegate>

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
    
    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationBar setTintColor:kMain_Color];
    [self.navigationBar setBarTintColor:kBar_Backgroud_Color];
    [self.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                 kLight_Text_Color, NSForegroundColorAttributeName, [UIFont systemFontOfSize:17], NSFontAttributeName, nil]];
    
    // 隐藏返回按钮title
    if (@available(iOS 11.0, *)) {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100,0) forBarMetrics:UIBarMetricsDefault];
    }else {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
    }
    // 隐藏分割线
    [self findNavBarBottomImage:self.navigationBar].hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    UIViewController* topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}


-(UIImageView *)findNavBarBottomImage:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findNavBarBottomImage:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

#pragma mark - 返回按钮

- (void)setBackItemWithController:(UIViewController *)viewControlller {
    viewControlller.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"Wallet.bundle/main/back_icon"];
    viewControlller.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"Wallet.bundle/main/back_icon"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:0 target:nil action:nil];
    viewControlller.navigationItem.backBarButtonItem = backItem;
}

#pragma mark - 重写push方法

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
    
    [super pushViewController:viewController animated:animated];
}


#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate {
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        
        //navigationControl 第一层界面不添加返回手势，不然会造成页面假死的情况
        if ([navigationController.viewControllers indexOfObject:viewController] == 0){
            self.interactivePopGestureRecognizer.enabled = NO;
            [self setBackItemWithController:viewController];
        }
        else
            self.interactivePopGestureRecognizer.enabled = YES;
        
    }
    
}


@end
