//
//  TencentContactViewController.h
//  wallet
//
//  Created by zhouzhiwei on 2018/9/19.
//  Copyright © 2018年 eos. All rights reserved.
//

typedef NS_ENUM(NSInteger,TencentContactType) {
    TencentContactTypeQQ,
    TencentContactTypeWechat,
};

#import "BaseViewController.h"

@interface TencentContactViewController : BaseViewController

- (instancetype)initWithContact:(TencentContactType)type;

@end
