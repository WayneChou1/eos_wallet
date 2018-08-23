//
//  WalletRequest.m
//  wallet
//
//  Created by zhouzhiwei on 2018/8/1.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "WalletRequest.h"
#import "AccountManager.h"

@interface WalletRequest ()

@property (nonatomic, strong) AccountInfo *info;
@property (nonatomic, strong) NSURLSessionTask *task;

@end

@implementation WalletRequest

- (void)getAccountInfo:(void (^)(AccountInfo *, BOOL, WalletRequest *))response {
    if (self.wallet && !self.task) {
        
        // 如果存在直接返回
        if (self.info) {
            response(self.info,YES,self);
            return;
        }
        
        // 获取当前钱包的用户名
        NSString *accountName;
        NSArray <Account*> *walletArr = [[AccountManager shareManager] selectAccountsFromWalletID:self.wallet.walletUUID];
        
        if (walletArr.count > 0) {
            accountName = walletArr.firstObject.accountName;
        }
        
        // 判断用户名是否存在
        if (accountName) {
            NSDictionary *dic = @{@"account_name":VALIDATE_STRING(accountName)};
            self.task = [[HTTPRequestManager shareManager] sendPOSTDataWithPath:eos_get_account withParamters:dic success:^(BOOL isSuccess, id responseObject) {
                self.task = nil;
                if (isSuccess) {
                    AccountInfo *info = [AccountInfo yy_modelWithJSON:responseObject];
                    self.info = info;
                    response(info,YES,self);
                }else{
                    response(nil,NO,self);
                }
            } failure:^(NSError *error) {
                self.task = nil;
                response(nil,NO,self);
            }];
        }else{
            response(nil,NO,self);
        }
        
    }else{
        response(nil,NO,self);
    }
}

@end
