//
//  WalletCell.h
//  wallet
//
//  Created by zhouzhiwei on 2018/8/1.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "WalletRequest.h"

@interface WalletCell : BaseTableViewCell

@property (nonatomic, strong) WalletRequest *wallet;

@end
