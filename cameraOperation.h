//
//  cameraOperation.h
//  testlib
//
//  Created by Sen5 on 16/10/10.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface cameraOperation : NSObject
+ (instancetype)sharedOperationHandle;

- (BOOL )hasCameraBackgoundImageWithDid:(NSString *)did;
-(NSData *)getCameraBackgoundImageWithDid:(NSString *)did;

@end
