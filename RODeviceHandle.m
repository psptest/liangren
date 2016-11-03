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
#import "DeviceModel.h"

@implementation RODeviceHandle


typedef enum : NSUInteger {
    // zigbee
    
    kDeviceUnknowns,
    kDeviceOnOrOff,
    kDeviceOrdinarySensor,
    kDeviceTemperature,
    kDeviceHumidity,
    kDeviceGroup,
    
    kDeviceCameras,
    
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


-(NSDictionary *)statusDictionaryWithModel:(DeviceModel *)device
{
    NSInteger dev_id = device.dev_id;
    NSArray *status = device.status;
    
    NSDictionary *dict = nil;
    if (status) {
        
        dict = @{@"dev_id":@(dev_id),@"status":status};
    
    }else
    {
        dict = @{@"dev_id":@(dev_id),@"status":@[]};

    }
    
    return dict;
}

-(NSDictionary *)StatusOrEventWithObject:(NSDictionary *)object
{
    
    NSDictionary *dic = nil;
    
    if ([object.allKeys containsObject:@"status"]) {
        
        NSArray *status = object[@"status"];
        
        NSInteger idCounts = status.count;
        
        if (idCounts == 0) {
            
            return nil;
            
        }else
        {
            for (NSDictionary *dict in status) {
                
//                if ([dict.allValues containsObject:@(kDeviceTemperature)] || [dict.allValues con]) {
//                    <#statements#>
//                }
                if ([dict[@"id"] isEqualToNumber:@(kDeviceTemperature)]||[dict[@"id"] isEqualToNumber:@(kDeviceTemperature)]) {
                    
                    dic = [self packageTempatureAndHumidityWithDictionary:object];
                    
                }
                if ([dict[@"id"] isEqualToNumber:@(kDeviceOnOrOff)]||[dict[@"id"] isEqualToNumber:@(kDeviceOrdinarySensor)]) {
                    
                        // 普通的sensor or control
                        NSInteger deviceID = [object[@"dev_id"] integerValue];
                        NSNumber *idNumber = status[0][@"id"];
                        NSString *parString = [status[0][@"params"] substringToIndex:2];
                    
                        dic = [self packageDictionaryWithIDNumber:idNumber params:parString deviceID:deviceID];
                    
                }
            
            }
            
            
        }
        
//        else if (idCounts == 1)
//        {
//            // 普通的sensor or control
//            NSInteger deviceID = [object[@"dev_id"] integerValue];
//            NSNumber *idNumber = status[0][@"id"];
//            NSString *parString = [status[0][@"params"] substringToIndex:2];
//            
//            dic = [self packageDictionaryWithIDNumber:idNumber params:parString deviceID:deviceID];
//            
//        }else if (idCounts == 3){
//            
//            //判断不一定准确 之后再判断
//            dic = [self packageTempatureAndHumidityWithDictionary:object];
//        
//        }
        
    }
    
    return dic;
    
}

-(NSDictionary *)StatusOrEventWithModel:(DeviceModel *)device
{
    NSDictionary *dict = [self statusDictionaryWithModel:device];
    
    NSDictionary *diction = [self StatusOrEventWithObject:dict];
    
    return diction;
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
    
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    
    [mutDic setObject:@(deviceID) forKey:@"dev_id"];
    
    if (temp ) {
        
        [mutDic setObject:temp forKey:@"temp"];
      //  NSDictionary *userInfo = @{@"idNumber":@(deviceID),@"temp":temp,@"humi":humi};
    
    }
    
    if (humi) {
        [mutDic setObject:humi forKey:@"humi"];
    }
    
    NSDictionary *dict = @{NOTIFICATION_NAME:NOTIFICATION_TEM_HUM,USER_INFO:[mutDic copy]};
    
    
    return dict;
}

//普通设备
-(NSDictionary *)packageDictionaryWithIDNumber:(NSNumber *)idNumber params:(NSString *)parString deviceID:(NSInteger )deviceID
{
    NSString *notificationName = nil;
    
    switch ([idNumber integerValue]) {
        case kDeviceUnknowns:
            return nil;
            break;
        case kDeviceOnOrOff:
            notificationName =  NOTIFICATION_ON_OR_OF;
            break;
        case kDeviceOrdinarySensor:
            notificationName =  NOTIFICATION_ORDINARY_SENSOR;
            break;
            
            
        default:
            return nil;
            break;
    }
    
    NSDictionary *userInfo = @{@"idNumber":idNumber,@"params":parString,@"dev_id":@(deviceID)};
    
    NSDictionary *diction = @{NOTIFICATION_NAME:notificationName,USER_INFO:userInfo};
    
    return diction;
}


-(NSString *)temperAndHumityWithParams:(NSString *)params
{
    
//},
//{
//    id = 4;
//    params = "HTs=";
//},
//{
//    id = 3;
//    params = "NmE=";
//}

NSData *data = [GTMBase64 decodeString:params];

    Byte *testByte = (Byte *)[data bytes];


    for(int i=0;i<[data length];i++){
        
        printf("testByte = %d\n",testByte[i]);
    }

    
    NSMutableString *mut = [NSMutableString stringWithFormat:@"%d.%d",testByte[0],testByte[1]];
    
    return  [mut copy];
    
#if 0
    NSData *integData = [GTMBase64 decodeString:params];
    
    NSString *integString = [[NSString alloc] initWithData:integData encoding:NSUTF8StringEncoding];
    
    return integString;
#endif
    
}


@end
