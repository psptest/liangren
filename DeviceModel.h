//
//  DeviceModel.h
//  security
//
//  Created by sen5labs on 15/10/13.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kDeviceSensor = 0,//传感器
    kDeviceControl,//控制设备
    kDeviceFull,//
    kDeviceUnknown,//未知设备
    kDeviceCamera //摄像头
} kDeviceMode;

@interface DeviceModel : NSObject
@property(nonatomic,assign) NSInteger dev_id;
@property(nonatomic,copy) NSString *dev_type;//类型 用于判断是何种设备
@property(nonatomic,assign) NSInteger mode;//模式 用于判断是传感器 还是控制设备 或是摄像头
@property(nonatomic,copy) NSString *name;//名称
@property(nonatomic,assign) NSInteger update_time;//更新时间
@property(nonatomic,strong) NSArray *status;// 状态 用于判断设备的开启与否 摄像头 did
@property(nonatomic,assign) NSInteger table_id;//废弃

@property(nonatomic,assign) BOOL isFavorate;//辅助判断是否为目标设备

@property(nonatomic,assign,readwrite) NSInteger room_id;//房间ID 用于判断设备的分配房间
@property(nonatomic,assign) NSInteger scene_id;//

// 模式
@property(nonatomic,assign) NSInteger sec_stay;
@property(nonatomic,assign) NSInteger sec_away;
@property(nonatomic,assign) NSInteger sec_disarm;


-(id)initWithDictionary:(NSDictionary *)dic;

@end