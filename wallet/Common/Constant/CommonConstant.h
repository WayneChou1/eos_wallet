//
//  CommonConstant.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/16.
//  Copyright © 2018年 eos. All rights reserved.
//

#ifndef CommonConstant_h
#define CommonConstant_h

#define kUserDefault [NSUserDefaults standardUserDefaults]
#define kIs_First_Launch [kUserDefault boolForKey:kFirst_launch]
#define kIs_TouchId_on [kUserDefault boolForKey:kTouchId_on]

/** 设置颜色 */
#define kColor(_hex) [UIColor colorWithHex:_hex]

/** 图片 */
#define kImageBundle [[NSBundle mainBundle] pathForResource:@"Wallet" ofType:@"bundle"]
#define kPath_resource(_fileName) [kImageBundle stringByAppendingPathComponent:_fileName]
#define kImageWithPath(_imageName) [UIImage imageWithContentsOfFile:kPath_resource(_imageName)]

/** 国际化 */
#define kLocalizable(_key) [[LocalizedHelper standardHelper] stringWithKey:_key]


/** 默认背景颜色 */
#define kBackgroud_Color [UIColor colorWithHex:0xF8F8F8]

/** 默认Bar背景颜色 */
#define kBar_Backgroud_Color [UIColor colorWithHex:0xF8F8F8]

/** 默认分割线颜色 */
#define kLine_Color [UIColor colorWithHex:0xD9D9D9]

/** 深色字体颜色 */
#define kDark_Text_Color [UIColor colorWithHex:0x282828]

/** 浅色字体颜色 */
#define kLight_Text_Color [UIColor colorWithHex:0x666666]

/** 主题色 */
#define kMain_Color [UIColor colorWithHex:0x3A78F6]

/** 严重 */
#define kWarning_Text_Color [UIColor colorWithHex:0xFF0F26]

/** 字体 */
#define kSys_font(font) [UIFont systemFontOfSize:font]

// 状态栏高度
#define kRectOfStatusbarH [[UIApplication sharedApplication] statusBarFrame].size.height
// 导航栏高度
#define kRectOfNavigationbarH  self.navigationController.navigationBar.frame.size.height
// 导航视图中可视区域（Y）
#define kOriginY (kRectOfStatusbarH + kRectOfNavigationbarH)

/** 当前钱包 */
#define kCurrentWallet_UUID [kUserDefault objectForKey:kCurrent_wallet]
#define kCurrentWallet [[WalletManager shareManager] selectWalletsFromUUID:kCurrentWallet_UUID]

/**  APPID */
#define APPID @"1435906738"

#endif /* CommonConstant_h */
