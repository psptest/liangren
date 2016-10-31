//
//  Encryption.h
//  AESEncryption
//
//  Created by changxin on 14-11-27.
//  Copyright (c) 2014年 changxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encryption : NSObject

//加密字符串
+ (NSString*) AES128Encrypt:(NSString *)EncryStr key:(NSString *)aKey;

//解密字符串
+ (NSData *) AES128Decrypt:(NSData *)data key:(NSString *)aKey;

@end

