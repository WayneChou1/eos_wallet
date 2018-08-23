//
//  MainAssetCell.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/31.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "BaseTableViewCell.h"

@class Account;

@interface MainAssetCell : BaseTableViewCell

@property (nonatomic, strong) Account *info;

@end
