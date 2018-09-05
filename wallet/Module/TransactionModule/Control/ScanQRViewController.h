//
//  ScanQRViewController.h
//  wallet
//
//  Created by 周志伟 on 2018/8/26.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ScanCompleteHandler)(BOOL success,NSString *codeString);

typedef NS_ENUM(NSInteger,ScanQRCodeType) {
    ScanQRCodeTypeForAccount,
    ScanQRCodeTypeForTrx,
};

@interface ScanQRViewController : BaseViewController

- (instancetype)initWithHandler:(ScanCompleteHandler)handler;

@end
