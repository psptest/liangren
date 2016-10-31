//
//  HSLSearchDevice.m
//  HSLCam
//
//  Created by APPLE on 27/10/14.
//  Copyright (c) 2014年 hsl. All rights reserved.
//

#import "HSLSearchDevice.h"
#import "IPCClientNetLib.h"



@implementation HSLSearchDevice

/*
 * 设备搜索回调
 */
void STDCALL CallBack_BroadcastSearchCallback(const BCASTPARAM *param, void *data)
{
    id pThiz = (__bridge id)data;
    [pThiz ProcessSearchDevice:param];
}

// 处理搜索回调
- (void)ProcessSearchDevice:(const BCASTPARAM *)param
{
    char szMac[32];
    memset(szMac, 0, sizeof(szMac));
    sprintf(szMac, "%02X-%02X-%02X-%02X-%02X-%02X", (unsigned char)param->szMacAddr[0], (unsigned char)param->szMacAddr[1], (unsigned char)param->szMacAddr[2], (unsigned char)param->szMacAddr[3], (unsigned char)param->szMacAddr[4], (unsigned char)param->szMacAddr[5]);
    
    if (self.searchDelegate != nil) {
        if ([self.searchDelegate respondsToSelector:@selector(SearchDevice:MAC:Name:Addr:Port:DeviceID:SmartConnect:)]) {
            [self.searchDelegate SearchDevice:param->type
                                          MAC:[NSString stringWithUTF8String:szMac]
                                         Name:[NSString stringWithUTF8String:param->szDevName]
                                         Addr:[NSString stringWithUTF8String:param->szIpAddr]
                                         Port:param->nPort
                                     DeviceID:[NSString stringWithUTF8String:param->dwDeviceID]SmartConnect:param->smartconnect];
        }
    }
}

- (id)init
{
    if (self = [super init]) {
        device_broadcast_Initialization();
    }
    return self;
}

- (void)dealloc
{
    device_broadcast_unInitialization();
  //  [super dealloc];
}

- (void)Search
{
    device_broadcast_search(CallBack_BroadcastSearchCallback, (__bridge void *)(self));
}

@end
