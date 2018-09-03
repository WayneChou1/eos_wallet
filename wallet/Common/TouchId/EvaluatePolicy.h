//
//  EvaluatePolicy.h
//  wallet
//
//  Created by zhouzhiwei on 2018/9/3.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaluatePolicy : NSObject

+ (void)EvaluatePolicy:(void(^)(BOOL success,NSString *message))handler;

@end
