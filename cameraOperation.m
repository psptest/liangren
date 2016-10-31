//
//  cameraOperation.m
//  testlib
//
//  Created by Sen5 on 16/10/10.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import "cameraOperation.h"

@implementation cameraOperation
static cameraOperation * _camera = nil;
+ (instancetype)sharedOperationHandle {

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _camera = [[cameraOperation alloc] init];
        });
        return _camera;
}

-(BOOL )hasCameraBackgoundImageWithDid:(NSString *)did
{
    NSString *betaCompressionDirectory = [NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),did];
    BOOL ret = [[NSFileManager defaultManager] fileExistsAtPath:betaCompressionDirectory];

    return  ret;
}

-(NSData *)getCameraBackgoundImageWithDid:(NSString *)did
{
    NSData *img = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),did]];
    return img;
}

@end
