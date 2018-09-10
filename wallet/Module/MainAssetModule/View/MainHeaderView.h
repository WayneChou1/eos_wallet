//
//  MainHeaderView.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/17.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Account;

@protocol MainHeaderDelegate <NSObject>

- (void)gotoMore;

@end

@interface MainHeaderView : UIView

@property (weak, nonatomic) id <MainHeaderDelegate> delegate;

- (instancetype)initHeaderViewWithFrame:(CGRect)frame;

- (void)reloadSubViews;

@end
