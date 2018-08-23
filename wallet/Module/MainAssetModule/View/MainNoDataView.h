//
//  MainNoDataView.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/17.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainNoDataPushDelegate <NSObject>

- (void)needCreateWallet;
- (void)needInsertAccount;

@end

@interface MainNoDataView : UIView

@property (nonatomic, weak) id <MainNoDataPushDelegate> delegate;

- (instancetype)initHeaderViewWithFrame:(CGRect)frame noWallet:(BOOL)noWallet noAccount:(BOOL)noAccount;

@end
