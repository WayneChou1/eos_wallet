//
//  MBProgressHUD+ZJExtension.m
//  Underworld
//
//  Created by zhouzhiwei on 2018/6/22.
//  Copyright © 2018年 zijinph. All rights reserved.
//

#import "MBProgressHUD+ZJExtension.h"

static NSString * const ZJMBProgressMsgLoading = @"正在加载...";
static NSString * const ZJMBProgressMsgError = @"加载失败";
static NSString * const ZJMBProgressMsgSuccessful = @"加载成功";
static NSString * const ZJMBProgressMsgNoMoreData = @"没有更多数据了";

static NSTimeInterval const ZJMBProgressMsgTimeInterval = 1.2;
static CGFloat const font_size = 15.0;
static CGFloat const opacity = 0.85;

@implementation MBProgressHUD (ZJExtension)

/// 添加到一个视图，并选择是否显示动画
+ (MBProgressHUD *)zj_showHUDAddedToView:(UIView *)view title:(NSString *)title animated:(BOOL)animated {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:animated];
    HUD.label.font = [UIFont systemFontOfSize:font_size];
    HUD.label.text = title;
    HUD.bezelView.alpha = opacity;
    return HUD;
}

/// 有动画
+ (MBProgressHUD *) zj_showHUDAddToViewWithAnimate:(UIView *)view title:(NSString *)title {
    return [self zj_showHUDAddedToView:view title:title animated:YES];
}

+ (MBProgressHUD *) zj_showHUDAddToViewWithoutAnimate:(UIView *)view title:(NSString *)title {
    return [self zj_showHUDAddedToView:view title:title animated:NO];
}

+ (void) zj_showViewAfterSecondWithView:(UIView *)view title:(NSString *)title afterSecond:(NSTimeInterval)afterSecond {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.label.font = [UIFont systemFontOfSize:font_size];
    HUD.label.text = title;
    HUD.bezelView.alpha = opacity;
    [HUD hideAnimated:YES afterDelay:afterSecond];
}

+ (void) zj_ShowHUDHidAfterSecondWithMsgType:(ZJMBProgress)msgType view:(UIView *)view title:(NSString *)title afterSecond:(NSTimeInterval)afterSecond {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    NSString *imgName = [self zj_imageNamedWithMsgType:msgType];
    HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    
    HUD.label.font = [UIFont systemFontOfSize:font_size];
    HUD.label.text = title;
    HUD.bezelView.alpha = opacity;
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hideAnimated:YES afterDelay:afterSecond];
}

// 根据显示类型来选择背景图片
+ (NSString *)zj_imageNamedWithMsgType:(ZJMBProgress)msgType {
    NSString *imgName = @"";
    switch (msgType) {
        case ZJMBProgressSuccessful:
            imgName = @"";
            break;
        case ZJMBProgressError:
            imgName = @"";
            break;
        case ZJMBProgressWarning:
            imgName = @"";
            break;
        case ZJMBProgressInfo:
            imgName = @"";
            break;
            
        default:
            break;
    }
    return imgName;
}

@end
