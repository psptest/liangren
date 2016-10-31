//
//  endConvert.h
//  testlib
//
//  Created by liuhuangshuzz on 9/6/16.
//  Copyright © 2016 hsl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface endConvert : NSObject


+ (instancetype)sharedConvert;

// 大小端 转换
-(int  )convertToBit:(int )little;
-(NSData *)convertToBig:(int )little;
-(int )convertToBitWithTwoBytes:(int )little;

// 整型转数据流
-(NSData *)convertToData:(int )little;

-(int  )convertToLittle:(int )big;

@end
