//
//  simulatorOperation.m
//  security2.0
//
//  Created by Sen5 on 16/6/27.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "simulatorOperation.h"
#import "prefrenceHeader.h"
#import "DeviceModel.h"
#import "roomsModel.h"
#import "sceneModel.h"
static simulatorOperation *_sharedInstace ;
@implementation simulatorOperation

+ (simulatorOperation *)sharedOperation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstace = [[super alloc]init];
    });
    
    return _sharedInstace;
}
+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstace = [super allocWithZone:zone];
    });
    
    return _sharedInstace;
}
-(NSArray<DeviceModel *> *)getDevices
{
    NSString *path = [self getBundlePath:@"simDevice.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *arr = dic[@"devices"];
    NSMutableArray *mods = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        DeviceModel *mod = [[DeviceModel alloc] initWithDictionary:dic];
        [mods addObject:mod];
    }
    
    return mods;
}
-(NSArray<roomsModel *> *)getRooms
{
    NSString *path = [self getBundlePath:@"simRoom.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *arr = dic[@"rooms"];
    
    NSMutableArray *rooms = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        roomsModel *mod = [[roomsModel alloc] initWithDictionary:dic];
        [rooms addObject:mod];
    }
    
    return rooms;
}

-(NSArray *)getAssignedDevicesWithModel:(roomsModel *)room
{
    NSMutableArray *devices = nil;
    NSMutableArray *models = [NSMutableArray array];
    
    NSArray *rooms = [self getRooms];
    for (roomsModel *mod in rooms ) {
        if ([@(room.room_id) isEqualToNumber:@(mod.room_id)]) {
            
            devices = [NSMutableArray arrayWithArray:room.devices];
            break;
        }
    }
    NSArray *array = [self getDevices];
    
    if (devices.count != 0) {
        for (NSDictionary *dic in devices) {
            
            for (DeviceModel *device in array) {
                if([@(device.dev_id) isEqualToNumber:dic[@"dev_id"]]) {
                    [models addObject:device];
                    break;
                }
            }
        }
    }
    
    NSLog(@"the assigned models %@",models);
    
    return models;
}
-(NSArray<sceneModel *> *)getScenes
{
    NSString *path = [self getBundlePath:@"simScene.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *arr = dic[@"scenes"];
    
    NSMutableArray *rooms = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        sceneModel *mod = [[sceneModel alloc]initWithDictionary:dic];
        [rooms addObject:mod];
    }
    return rooms;
}
-(NSString *)getBundlePath:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    BOOL ret = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!ret) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    
    return path;
}
-(NSDictionary *)getImageNameWithDevice_type:(NSString *)dev_type device_mode:(NSInteger )mode
{
    NSArray *array = nil;
    
    array = [NSArray arrayWithContentsOfFile:[self getBundlePath:kImage_dev_type]];
    
    if (mode == 0) {
        //sensor
        if ([[array[1] allKeys] containsObject:dev_type]) {
            return  [array[1] objectForKey:dev_type];//返回个字典
        }
    }else if(mode == 1 )
    {
        MYLog(@"/////////%@",array[0]);
        // action
        if ([[array[0] allKeys] containsObject:dev_type]) {
            return  [array[0] objectForKey:dev_type];//返回个字典
        }
    }
    else{
        
        return nil;
    }

    return nil;
}

@end
