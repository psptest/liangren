//
//  memoryOperation.h
//  ;
//
//  Created by Sen5 on 16/10/9.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface memoryOperation : NSObject

+ (instancetype)shareMemoryOperation;
- (double)availableMemory;
- (double)usedMemory;

@end
