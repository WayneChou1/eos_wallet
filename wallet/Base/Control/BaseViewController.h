//
//  BaseViewController.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/16.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 获取状态栏高度 */
#define kHeight_Statusbar [[UIApplication sharedApplication] statusBarFrame].size.height
/** 获取导航栏栏高度 */
#define kHeight_Navigationbar self.navigationController.navigationBar.frame.size.height;

@interface BaseViewController : UIViewController

- (void)setBackGroudColor;

- (CGFloat)getNavBarHeight;

@end
