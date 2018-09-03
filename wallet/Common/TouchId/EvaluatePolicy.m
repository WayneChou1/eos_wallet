//
//  EvaluatePolicy.m
//  wallet
//
//  Created by zhouzhiwei on 2018/9/3.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "EvaluatePolicy.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation EvaluatePolicy

+ (void)EvaluatePolicy:(void(^)(BOOL success,NSString *message))handler {
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = kLocalizable(@"使用密码");
    // LAPolicyDeviceOwnerAuthentication
    __weak __typeof(self)weakSelf = self;
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:kLocalizable(@"通过Home键验证已有手机指纹") reply:^(BOOL success, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = @"";
            if (success) {
                message = @"通过了Touch ID 指纹验证";
                handler(YES, message);
            } else {
                //失败操作
                LAError errorCode = error.code;
                BOOL inputPassword = NO;
                switch (errorCode) {
                    case LAErrorAuthenticationFailed: {
                        // -1
                        message = @"连续三次指纹识别错误";
                    }
                        break;
                        
                    case LAErrorUserCancel: {
                        // -2
                        message = @"用户取消验证Touch ID";
                    }
                        break;
                        
                    case LAErrorUserFallback: {
                        // -3
                        inputPassword = YES;
                        message = @"用户选择输入密码";
                    }
                        break;
                        
                    case LAErrorSystemCancel: {
                        // -4 TouchID对话框被系统取消，例如按下Home或者电源键
                        message = @"取消授权，如其他应用切入";
                    }
                        break;
                        
                    case LAErrorPasscodeNotSet: {
                        // -5
                        message = @"设备系统未设置密码";
                    }
                        break;
                        
                    case LAErrorTouchIDNotAvailable: {
                        // -6
                        message = @"此设备不支持 Touch ID";
                    }
                        break;
                        
                    case LAErrorTouchIDNotEnrolled: {
                        // -7
                        message = @"用户未录入指纹";
                    }
                        break;
                        
                    case LAErrorTouchIDLockout: {
                        // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
//                        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
//                            [weakSelf openTouchIDWithPolicy:LAPolicyDeviceOwnerAuthentication touchIDBlock:block];
//                        }
                        message = @"Touch ID被锁，需要用户输入密码解锁";
                    }
                        break;
                        
                    case LAErrorAppCancel: {
                        // -9 如突然来了电话，电话应用进入前台，APP被挂起啦
                        message = @"用户不能控制情况下APP被挂起";
                    }
                        break;
                        
                    case LAErrorInvalidContext: {
                        // -10
                        message = @"Touch ID 失效";
                    }
                        break;
                        
                    default:
                        // [SVProgressHUD showErrorWithStatus:@"此设备不支持 Touch ID"];
                        break;
                }
                handler(NO, message);
            }
        });
    }];
}

@end
