//
//  HSLSearchDevice.h
//  HSLCam
//
//  Created by APPLE on 27/10/14.
//  Copyright (c) 2014年 hsl. All rights reserved.
//

#import <Foundation/Foundation.h>

// 搜索协议
@protocol HSLSearchDeviceDelegate <NSObject>
@required
- (void)SearchDevice:(int)DeviceType MAC:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:( int)port DeviceID:(NSString*)did SmartConnect:(int)smartconnection;

@end

/**********************************************************************
                        类功能: 搜索设备
 **********************************************************************/
@interface HSLSearchDevice : NSObject

@property (nonatomic, assign) id<HSLSearchDeviceDelegate> searchDelegate;

- (void)Search;
@end
