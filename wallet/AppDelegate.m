//
//  AppDelegate.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/16.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "AppDelegate.h"
#import "BootPageViewController.h"
#import "TabBarViewController.h"
#import "WalletManager.h"
#import <StoreKit/StoreKit.h>
#import <Bugly/Bugly.h>

static NSString * const buglyKey = @"00ccce3736";

@interface AppDelegate () <SKStoreProductViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    sleep(1.5);
    
    // 集成IQ
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    // 更新表
    [[WalletManager shareManager] updateTable];
    
    // 创建主窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    // 判断是否是第一次
//    if (kIs_First_Launch) {
//    }else{
//        [kUserDefault setBool:YES forKey:kFirst_launch];
//    }
    self.window.rootViewController = [[TabBarViewController alloc]init];
    [self.window makeKeyAndVisible];
    
    // 应用评分
    [self showAppStoreReView];
    
    [Bugly startWithAppId:@"buglyKey"];
    return YES;
}

- (void)showAppStoreReView{
    Class SKSRC = NSClassFromString(@"SKStoreReviewController");
    if (SKSRC) {
        [SKSRC performSelector:@selector(requestReview)];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {}


- (void)applicationDidEnterBackground:(UIApplication *)application {}


- (void)applicationWillEnterForeground:(UIApplication *)application {}


- (void)applicationDidBecomeActive:(UIApplication *)application {}


- (void)applicationWillTerminate:(UIApplication *)application {}


@end
