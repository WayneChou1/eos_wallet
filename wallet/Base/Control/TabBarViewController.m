//
//  BaseTabBarViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/16.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "TabBarViewController.h"
#import "NavigationViewController.h"
#import "MainAssetViewController.h"
#import "ProfileViewController.h"
#import "ExchangeViewController.h"
#import "UIImage+Color.h"

@interface TabBarViewController () <UITabBarControllerDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setTintColor:kMain_Color];
    [[UITabBar appearance] setBarTintColor:kBar_Backgroud_Color];
//    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]];
//    [[UITabBar appearance] setShadowImage:[UIImage imageWithColor:kLine_Color]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kLight_Text_Color, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kMain_Color, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [self createControllers];
    
    self.delegate = self;
    self.view.backgroundColor = kBackgroud_Color;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private

#pragma mark 创建控制器
- (void)createControllers {
    
    MainAssetViewController *mainVC = [[MainAssetViewController alloc]init];
    ProfileViewController *profileVC = [[ProfileViewController alloc]init];
    ExchangeViewController *exchangeVC = [[ExchangeViewController alloc]init];
    
    NSArray *vcArr = @[mainVC,exchangeVC,profileVC];
    NSArray *titleArr = @[kLocalizable(@"资产"),kLocalizable(@"交易"),kLocalizable(@"我的")];
    NSArray *imageSelArr = @[@"tab_item_asset_select.png",@"tab_item_exchange_select.png",@"tab_item_profile_select.png"];
    NSArray *imageArr = @[@"tab_item_asset_unselect.png",@"tab_item_exchange_unselect.png",@"tab_item_profile_unselect.png"];
    
    for (int i = 0; i < 3; i++) {
        NSString *path = [NSString stringWithFormat:@"Wallet.bundle/tabItem/%@",imageArr[i]];
        NSString *pathSel = [NSString stringWithFormat:@"Wallet.bundle/tabItem/%@",imageSelArr[i]];
        
        UIImage *image = [[UIImage imageNamed:path] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selImage = [[UIImage imageNamed:pathSel] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UINavigationController *navc = [self viewControllerWithTitle:titleArr[i] image:image selImage:selImage viewController:vcArr[i]];
        [self addChildViewController:navc];
    }
}

- (UINavigationController *) viewControllerWithTitle:(NSString*) title image:(UIImage*)image selImage:(UIImage *)selImage viewController:(UIViewController *)vc {
    
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selImage];
    vc.tabBarItem.title = title;
    NavigationViewController *nav = [[NavigationViewController alloc]initWithRootViewController:vc];
    return nav;
}


@end
