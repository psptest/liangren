//
//  NSDataWithCameraType.h
//  security
//
//  Created by Sen5 on 15/12/24.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDataWithCameraType : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) NSInteger cameraType;

//包含data 和cameraType的model
+ (instancetype) data:(NSData *)data withcameraType:(NSInteger)type;


@end
