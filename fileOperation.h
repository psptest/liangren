//
//  fileOperation.h
//  security2.0
//
//  Created by Sen5 on 16/3/25.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//
#import <Foundation/Foundation.h>
@class roomsModel;
@class DeviceModel;
@class sceneModel;
@class securityModel;

@interface fileOperation : NSObject

+(fileOperation *)sharedOperation;


// ------------------------Device--------------------


//获取设备
-(NSArray<DeviceModel *> *)getDevices;
-(NSArray<DeviceModel *> *)getControls;
-(NSArray<DeviceModel *> *)getCameras;
-(NSArray<DeviceModel *> *)getSensors;
-(NSArray<DeviceModel *>*)getFavorateDevices;
-(NSArray<DeviceModel *> *)getTemperatures;
//获取未分配的设备
-(NSArray *)getIdleDevices;
//根据roomModel查询已分配的设备
-(NSArray *)getAssignedDevicesWithModel:(roomsModel *)room;

//根据传入的字典添加或者删除 更新设备列表
-(BOOL)addNewDevice:(NSDictionary *)device;
-(BOOL)deleteDevice:(NSDictionary *)device;
-(BOOL)editeDevice:(NSDictionary *)device;
-(BOOL)controlDevice:(NSDictionary *)device;

// 根据dev_id 获取device_model
-(NSArray *)searchDevicesWithDev_id:(NSArray<NSNumber *> *)dev_ids;

//根据房间列表为device 分配room_id
-(BOOL)addDevice_Room_id:(NSDictionary *)room_list;

//根据状态列表更新设备列表
-(BOOL)setDeviceStatusWithList:(NSDictionary *)status;

//dev_id与DeviceModel相互转换
-(NSArray<DeviceModel *> *)getDeviceWithDev_ID:(NSArray<NSNumber *> *)dev_ids;
-(NSArray<NSDictionary *> *)getDev_IDAndTab_IDWithDeveciModle:(NSArray<DeviceModel *>*)devices;

//根据deviceModel返回字典
-(NSDictionary *)dictionaryWithDeviceModel:(DeviceModel *)device;

//根据device type 获取默认的device_name
-(NSString *)getDeviceNameWithDevice_type:(NSString *)dev_type;


//根据scenemodel返回打开或关闭的设备
-(NSArray *)getOpennedDeviceWithSceneModle:(sceneModel *)scene;
-(NSArray *)getClosedDeviceWithSceneModle:(sceneModel *)scene;

//根据传入的打开或关闭设备生成action_list
-(NSArray *)actionListWithOpenDevice:(NSArray *)open closeDevice:(NSArray *)close;

//--------------------Room---------------------------

//获取房间列表
-(NSArray<roomsModel *> *)getRooms;

//根据传入的字典添加或者删除房间列表
-(BOOL)addNewRoom:(NSDictionary *)room;
-(BOOL)deleteRoom:(NSDictionary *)room;

//根据room_id返回room信息字典
-(NSDictionary *)dictionWithRoom_id:(NSInteger )room_id;

// ----------------------Scene--------------------------

-(NSArray<sceneModel *> *)getScenes;

//更新scene_list
-(BOOL )addNewScene:(NSDictionary *)scene;
-(BOOL )deleteScene:(NSNumber *)scene_id;
-(BOOL )editScene:(NSDictionary *)scene;



//-------------------mode-------------

-(NSArray<securityModel *> *)getSecurities;

//更新modeList
-(BOOL )editeMode:(NSDictionary *)mode;


// -----------------------other------------------

//根据device type 获取图像名称
-(NSDictionary *)getImageNameWithDevice_type:(NSString *)dev_type device_mode:(NSInteger )mode;

//清空列表
-(BOOL )clearList;

// 获取假数据的方法
-(NSArray *)getCellInfoWithCellName:(NSString *)cellName;
-(NSMutableArray *)getDataWithCellName:(NSString *)cellName;

//根据文件名获取路径
-(NSString *)getBundlePath:(NSString *)fileName;
-(NSString *)getHomePath:(NSString *)fileName;



@end