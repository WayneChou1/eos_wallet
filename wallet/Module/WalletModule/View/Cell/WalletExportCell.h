//
//  WalletExportCell.h
//  wallet
//
//  Created by zhouzhiwei on 2018/9/14.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface Export : NSObject

@property (copy, nonatomic) NSString *permission;
@property (copy, nonatomic) NSString *publicKey;
@property (copy, nonatomic) NSString *privateKey;
@property (assign, nonatomic) BOOL showQR;

@end

@protocol RefreshPrivateDelegate <NSObject>

- (void)refreshCell:(UITableViewCell *)cell;

@end

@interface WalletExportCell : BaseTableViewCell

@property (strong, nonatomic) Export *exp;
@property (weak, nonatomic) id <RefreshPrivateDelegate> delegate;

@end
