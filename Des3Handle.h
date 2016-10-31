//
//  Des3Handle.h
//  security
//
//  Created by sen5labs on 15/12/3.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@interface Des3Handle : NSObject

/**
 *  3des 加密解密
 *
 *  @param plainText        明文/密文
 *  @param encryptOrDecrypt 加密/解密
 *
 *  @return 密文/明文
 */
+ (NSString *)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt;

@end
