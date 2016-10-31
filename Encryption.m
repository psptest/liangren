//


#import "Encryption.h"
#import <CommonCrypto/CommonCryptor.h>
//#import "GTMBase64.h"

#define gIv             @"0000000000000000"

@implementation Encryption
+(NSString *)AES128Encrypt:(NSString *)EncryStr key:(NSString *)aKey
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [aKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [EncryStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
//    int diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
//    int newSize = 0;
//    if(diff > 0)
//    {
//        newSize = dataLength + diff;
//    }
    int newSize = (int )dataLength;
    
    char dataPtr[newSize];
    
    memcpy(dataPtr, [data bytes], [data length]);
    
//    for(int i = 0; i < diff; i++)
//    {
//        dataPtr[i + dataLength] = 0x00;
//    }
    
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode,
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          NULL,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
//        return [GTMBase64 stringByEncodingData:resultData];
        NSString *Str = [[NSString alloc] initWithData:resultData encoding:NSASCIIStringEncoding];
        return Str;
    }
    free(buffer);
    return nil;
}


+(NSData *)AES128Decrypt:(NSData *)data key:(NSString *)aKey
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [aKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
//    NSData *data = [GTMBase64 decodeData:[DecryStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSUInteger dataLength = [data length];

    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        return resultData;
//        NSLog(@"resultData = %li",resultData.length);
        
//        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        
        
    }
    free(buffer);
    return nil;
}

@end

