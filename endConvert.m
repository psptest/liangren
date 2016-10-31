//
//  endConvert.m
//  testlib
//
//  Created by liuhuangshuzz on 9/6/16.
//  Copyright © 2016 hsl. All rights reserved.
//

#import "endConvert.h"

static endConvert * sharedConvert = nil;

@implementation endConvert

+ (instancetype)sharedConvert{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConvert = [[endConvert alloc] init];
    });
    return sharedConvert;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(int )convertToBit:(int)little
{
    //获取高低位
    char c1 = (little >> 24) & 0xff;
    char c2 = (little >> 16) & 0xff;
    char c3 = (little >> 8) & 0xff;
    char c4 = little & 0xff;
    
    //转换高低位
    NSMutableData *receiveData = [[NSMutableData alloc] initWithCapacity:4];
    
    [receiveData appendBytes:&c1 length:1];
    [receiveData appendBytes:&c2 length:1];
    [receiveData appendBytes:&c3 length:1];
    [receiveData appendBytes:&c4 length:1];
    
    int a ;
    
    [receiveData getBytes:&a range:NSMakeRange(0, 4)];
    
    return a;
}

-(int )convertToBitWithTwoBytes:(int )little
{
    char c3 = (little >> 8) & 0xff;
    char c4 = little & 0xff;
    
    //转换高低位
    NSMutableData *receiveData = [[NSMutableData alloc] initWithCapacity:4];
    
    [receiveData appendBytes:&c3 length:1];
    [receiveData appendBytes:&c4 length:1];
    
    int a ;
    
    [receiveData getBytes:&a range:NSMakeRange(0, 2)];
    
    return a;

}

-(NSData *)convertToData:(int )little
{
    //获取高低位
    char c1 = (little >> 24) & 0xff;
    char c2 = (little >> 16) & 0xff;
    char c3 = (little >> 8) & 0xff;
    char c4 = little & 0xff;
    
    //转换高低位
    NSMutableData *receiveData = [[NSMutableData alloc] initWithCapacity:4];
    
    [receiveData appendBytes:&c4 length:1];
    [receiveData appendBytes:&c3 length:1];
    [receiveData appendBytes:&c2 length:1];
    [receiveData appendBytes:&c1 length:1];
   
    return receiveData;
}

-(NSData *)convertToBig:(int )little
{
    //获取高低位
    char c1 = (little >> 24) & 0xff;
    char c2 = (little >> 16) & 0xff;
    char c3 = (little >> 8) & 0xff;
    char c4 = little & 0xff;
    
    //转换高低位
    NSMutableData *receiveData = [[NSMutableData alloc] initWithCapacity:4];
    
    [receiveData appendBytes:&c1 length:1];
    [receiveData appendBytes:&c2 length:1];
    [receiveData appendBytes:&c3 length:1];
    [receiveData appendBytes:&c4 length:1];
    
    
    return receiveData ;
}

-(int )convertToLittle:(int)big
{
    return 0;
}

@end
