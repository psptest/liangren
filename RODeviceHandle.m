//
//  RODeviceHandle.m
//  secQre
//
//  Created by Sen5 on 16/10/27.
//  Copyright © 2016年 hsl. All rights reserved.
//{

#import "RODeviceHandle.h"
#import "GTMBase64.h"
#import "prefrenceHeader.h"

#define kNotificationName @"notificationName"
#define kUserInfo @"userInfo"

@implementation RODeviceHandle


typedef enum : NSUInteger {
    // zigbee
    
    kDeviceUnknown,
    kDeviceOnOrOff,
    kDeviceSensor,
    kDeviceTemperature,
    kDeviceHumidity,
    kDeviceGroup,
    
    kDeviceCamera,
    
    // z_wave
    kZwaveDoor,
    kZwaveLuminance,
    kZwazeSecurity,
    kZwaveHumidity,
    kZwaveWater,
    kZwaveCO,
    kZwaveSmoke,
    kZwaveCombustible
    
    
} kDeviceID;

static RODeviceHandle * _deviceHandle = nil;
+ (instancetype)sharedDeviceHandle {

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _deviceHandle = [[RODeviceHandle alloc] init];
        });
        return _deviceHandle;
}

-(NSDictionary *)StatusOrEventWithObject:(NSDictionary *)object
{
    
//    "dev_id" = 12;
//    status =             (
//                          {
//                              id = 2;
//                              params = "HgAAAA==";
//                          },
//                          {
//                              id = 4;
//                              params = "Gws=";
//                          },
//                          {
//                              id = 3;
//                              params = "O08=";
//                          }
//                          );
//}
//);
    
    NSDictionary *dic = nil;
    
    if ([object.allKeys containsObject:@"status"]) {
        
        NSArray *status = object[@"status"];
        
        NSInteger idCounts = status.count;
        
        if (idCounts == 0) {
            
            return nil;
            
        }else if (idCounts == 1)
        {
            // 普通的sensor or control
            NSInteger deviceID = [object[@"dev_id"] integerValue];
            NSNumber *idNumber = status[0][@"id"];
            NSString *parString = [status[0][@"params"] substringToIndex:2];
            
            dic = [self packageDictionaryWithIDNumber:idNumber params:parString deviceID:deviceID];
            
        }else if (idCounts == 3){
            
            //判断不一定准确 之后再判断
            dic = [self packageTempatureAndHumidityWithDictionary:object];
        
        }
        
    }
    
    return dic;
    
}

#pragma mark - 打包数据传送
//温湿度传感
-(NSDictionary *)packageTempatureAndHumidityWithDictionary:(NSDictionary *)object
{
    NSInteger deviceID = [object[@"dev_id"] integerValue];
    
    NSArray *status = object[@"status"];
    
    NSString *temp = nil;
    NSString *humi = nil;
    
    for (NSDictionary *dict in status) {
        if ([dict.allValues containsObject:@(kDeviceTemperature)]) {
            //温度
            temp = [self temperAndHumityWithParams:dict[@"params"]];
            
        }else if ([dict.allValues containsObject:@(kDeviceHumidity)])
        {
            //湿度
            humi = [self temperAndHumityWithParams:dict[@"params"]];
        }
    }
    
    NSDictionary *dict = nil;
    
    if (temp && humi) {
        
        NSDictionary *userInfo = @{@"idNumber":@(deviceID),@"temp":temp,@"humi":humi};
        
        dict = @{kNotificationName:NOTIFICATION_TEM_HUM,kUserInfo:userInfo};
        
        return dict;
    
    }
    
    return nil;
}

//普通设备
-(NSDictionary *)packageDictionaryWithIDNumber:(NSNumber *)idNumber params:(NSString *)parString deviceID:(NSInteger )deviceID
{
    NSString *notificationName = nil;
    
    switch ([idNumber integerValue]) {
        case kDeviceUnknown:
            return nil;
            break;
        case kDeviceOnOrOff:
            notificationName =  NOTIFICATION_ON_OR_OF;
            break;
        case kDeviceSensor:
            notificationName =  NOTIFICATION_ORDINARY_SENSOR;
            break;
            
            
        default:
            return nil;
            break;
    }
    
    NSDictionary *userInfo = @{@"idNumber":idNumber,@"params":parString,@"dev_id":@(deviceID)};
    
    NSDictionary *diction = @{kNotificationName:notificationName,kUserInfo:userInfo};
    
    return diction;
}


-(NSString *)temperAndHumityWithParams:(NSString *)params
{

    NSData *data = [GTMBase64 decodeString:params];
    
    Byte *testByte = (Byte *)[data bytes];
    
#if 0
    for(int i=0;i<[data length];i++){
        
        printf("testByte = %d\n",testByte[i]);
    }
#endif
    
    NSMutableString *mut = [NSMutableString stringWithFormat:@"%c.%c",testByte[0],testByte[1]];
    
    return  [mut copy];
    
#if 0
    NSData *integData = [GTMBase64 decodeString:params];
    
    NSString *integString = [[NSString alloc] initWithData:integData encoding:NSUTF8StringEncoding];
    
    return integString;
#endif
    
}


//{
//    "dev_id" = 11;
//    status =             (
//                          {
//                              id = 2;
//                              params = "HgAAAA==";
//                          },
//                          {
//                              id = 4;
//                              params = "HiU=";
//                          },
//                          {
//                              id = 3;
//                              params = "RWI=";
//                          }
//                          );

@end
