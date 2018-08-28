//
//  EosSignature.h
//  EosFramework
//
//  Created by zhouzhiwei on 2018/7/30.
//  Copyright © 2018年 eos. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EosSign : NSObject

@property(nonatomic, strong, readonly) NSData *mHashBytesData;
// sha256result with hex encoding
@property(nonatomic, copy, readonly) NSString *sha256;

@end

@interface EosSignature : NSObject

@property (nonatomic, strong, readonly) EosSign *signatur;

@property (nonatomic, copy, readonly) NSString *signaturText;

+ (NSString *)initWithbytesForSignature:(NSData *)bytesForSignature privateKey:(int8_t *)privateKey;

@end
