//
//  NSDataWithCameraType.m
//  security
//
//  Created by Sen5 on 15/12/24.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import "NSDataWithCameraType.h"

@implementation NSDataWithCameraType

+ (instancetype) data:(NSData *)data withcameraType:(NSInteger)type
{
    NSDataWithCameraType * dataW = [[NSDataWithCameraType alloc]  init];
    dataW.data = data;
    dataW.cameraType = type;
    
    return dataW;
}

@end
