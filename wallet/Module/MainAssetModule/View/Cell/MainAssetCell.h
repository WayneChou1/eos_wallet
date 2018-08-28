//
//  MainAssetCell.h
//  wallet
//
//  Created by zhouzhiwei on 2018/7/31.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "BaseTableViewCell.h"

@class AccountInfo;

@interface MainAssetCell : BaseTableViewCell

@property (nonatomic, strong) AccountInfo *info;

@end
