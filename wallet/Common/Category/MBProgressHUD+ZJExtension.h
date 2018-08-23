//
//  MBProgressHUD+ZJExtension.h
//  Underworld
//
//  Created by zhouzhiwei on 2018/6/22.
//  Copyright © 2018年 zijinph. All rights reserved.
//

#import "MBProgressHUD.h"   


typedef enum {
    ZJMBProgressSuccessful = 1, // 成功
    ZJMBProgressError,          // 错误
    ZJMBProgressWarning,        // 警告
    ZJMBProgressInfo            // 内容
} ZJMBProgress;

@interface MBProgressHUD (ZJExtension)



/**

 @param view HUD 父视图
 @param title 标题
 @param animated 是否显示动画
 @return MBProgressHUD实例对象
 */
+ (MBProgressHUD *)zj_showHUDAddedToView:(UIView *)view title:(NSString *)title animated:(BOOL)animated;



/**

 @param view HUD 父视图
 @param title 标题
 @return MBProgressHUD实例对象
 */
+ (MBProgressHUD *) zj_showHUDAddToViewWithAnimate:(UIView *)view title:(NSString *)title;



/**

 @param view HUD 父视图
 @param title 标题
 @return MBProgressHUD实例对象
 */
+ (MBProgressHUD *) zj_showHUDAddToViewWithoutAnimate:(UIView *)view title:(NSString *)title;




/**
 自动消失HUD

 @param view HUD 父视图
 @param title 标题
 @param afterSecond 延迟消失 单位为s
 */
+ (void) zj_showViewAfterSecondWithView:(UIView *)view title:(NSString *)title afterSecond:(NSTimeInterval)afterSecond;



/**
  自动消失HUD，添加自定义视图

 @param msgType 自定义状态
 @param view HUD 父视图
 @param title 标题
 @param afterSecond 延迟消失 单位为s
 */
+ (void) zj_ShowHUDHidAfterSecondWithMsgType:(ZJMBProgress)msgType view:(UIView *)view title:(NSString *)title afterSecond:(NSTimeInterval)afterSecond;

@end
