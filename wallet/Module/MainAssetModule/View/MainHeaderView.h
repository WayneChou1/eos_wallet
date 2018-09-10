//
//  MainHeaderView.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/17.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Account;

@interface MainHeaderView : UIView

- (instancetype)initHeaderViewWithFrame:(CGRect)frame;

- (void)reloadSubViews;

@end
