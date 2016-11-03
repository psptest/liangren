//
//  RODeviceHandle.h
//  secQre
//
//  Created by Sen5 on 16/10/27.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DeviceModel;
@interface RODeviceHandle : NSObject


+ (instancetype)sharedDeviceHandle ;



//返回要发送对应通知的相关信息 包括名字和传送的object
-(NSDictionary *)StatusOrEventWithObject:(NSDictionary *)object;

-(NSDictionary *)StatusOrEventWithModel:(DeviceModel *)device;



@end
