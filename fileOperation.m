////  fileOperation.m//  security2.0////  Created by Sen5 on 16/3/25.//  Copyright © 2016年 com.letianxia. All rights reserved.//#import "fileOperation.h"#import "prefrenceHeader.h"#import "HouseModelHandle.h"#import "GTMBase64.h"#import "AddData.h"#import "roomsModel.h"#import "DeviceModel.h"#import "HouseModelHandle.h"#import "sceneModel.h"#import "securityModel.h"#import "RODeviceHandle.h"static fileOperation *_sharedInstace ;@implementation fileOperation+ (fileOperation *)sharedOperation{    static dispatch_once_t onceToken;    dispatch_once(&onceToken, ^{        _sharedInstace = [[super alloc]init];    });        return _sharedInstace;}+ (id)allocWithZone:(NSZone *)zone{    static dispatch_once_t onceToken;    dispatch_once(&onceToken, ^{        _sharedInstace = [super allocWithZone:zone];    });        return _sharedInstace;}#pragma mark - devices//获取设备数组-(NSArray *)getDevicesArray{    NSString *path = [self getHomePath:kDeviceInfo];    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];    NSArray *arr = dic[@"devices"];        return arr;}// 获取设备-(NSArray<DeviceModel *> *)getDevices{    NSArray *arr = [self getDevicesArray];        NSMutableArray *mods = [NSMutableArray array];            for (NSDictionary *dic in arr) {                //取出非camera        if ((![dic[@"dev_type"] isEqualToString:@"B000000000002"])&&(![dic[@"dev_type"] isEqualToString:@"B000000000001"])) {                DeviceModel *mod = [[DeviceModel alloc] initWithDictionary:dic];        [mods addObject:mod];                }    }        return [mods copy]; // 返回非camera列表或是空列表    }// 获取常用设备-(NSArray<DeviceModel *> *)getFavorateDevices{    NSString *path = [self getHomePath:kFavorate_Device];        NSDictionary *arr = [NSDictionary dictionaryWithContentsOfFile:path];        NSString *address = [[[HouseModelHandle shareHouseHandle] currentHouse] address];        NSMutableArray *mods = [NSMutableArray array];        for (NSDictionary *dic in arr[address]) {        MYLog(@"the favorate devices %@",dic);        DeviceModel *mod = [[DeviceModel alloc] initWithDictionary:dic];        mod.isFavorate = YES;        [mods addObject:mod];    }        return mods;}//获取控制器-(NSArray<DeviceModel *> *)getControls{    NSArray *arr = [self getDevicesArray];    NSMutableArray *mods = [NSMutableArray array];    for (NSDictionary *dic in arr) {        // action        if ([dic[@"mode"] isEqualToNumber:@(kDeviceControl)]) {            DeviceModel *mod = [[DeviceModel alloc] initWithDictionary:dic];            [mods addObject:mod];            continue;        }    }    return mods;}//获取摄像头-(NSArray<DeviceModel *> *)getCameras{    NSArray *arr = [self getDevicesArray];        NSMutableArray *mods = [NSMutableArray array];    for (NSDictionary *dic in arr) {        // action        if ([dic[@"dev_type"] isEqualToString:@"B000000000002"]&&([dic[@"status"] count] != 0)) {                        DeviceModel *mod = [[DeviceModel alloc] initWithDictionary:dic];            [mods addObject:mod];            continue;        }    }        return mods;}//获取传感器-(NSArray<DeviceModel *> *)getSensors{    NSArray *arr = [self getDevicesArray];    NSMutableArray *mods = [NSMutableArray array];    for (NSDictionary *dic in arr) {        // sensor        if ([dic[@"mode"] isEqualToNumber:@(kDeviceSensor)]) {            DeviceModel *mod = [[DeviceModel alloc] initWithDictionary:dic];            [mods addObject:mod];            continue;        }    }    return mods;}//获取闲置设备-(NSArray *)getIdleDevices{    NSMutableArray *mut = [NSMutableArray array];    NSMutableArray *models = [NSMutableArray arrayWithArray:[self getDevices]];    NSArray *rooms = [self getRooms];        for (roomsModel *room in rooms) {        if (room.devices.count != 0) {            if ([room.devices[0] isKindOfClass:[NSNumber class]]) {                            for (NSNumber *dev_id in room.devices) {                for (DeviceModel *mod in models) {                    if ([@(mod.dev_id) isEqualToNumber:dev_id]) {                        [mut addObject:mod];                    }                }            }            }else            {                for (NSDictionary  *dic in room.devices) {                    for (DeviceModel *mod in models) {                        if ([@(mod.dev_id) isEqualToNumber:dic[@"dev_id"]]) {                            [mut addObject:mod];                        }                    }                }                        }                    }    }        [models removeObjectsInArray:mut];        return models;}-(NSArray<DeviceModel *> *)getTemperatures{    NSArray *array = [self getDevices];    NSMutableArray *mut = [NSMutableArray array];    for (DeviceModel *dev in array) {                if ([dev.dev_type isEqualToString:@"A010403020000"]) {            if (dev.status.count != 0) {                // 类型为温湿度计 状态不为空                [mut addObject:dev];            }        }    }        return  [mut copy];}//获取房间分配设备-(NSArray *)getAssignedDevicesWithModel:(roomsModel *)room{    NSMutableArray *devices = nil;    NSMutableArray *models = [NSMutableArray array];        NSArray *rooms = [self getRooms];    for (roomsModel *mod in rooms ) {        if ([@(room.room_id) isEqualToNumber:@(mod.room_id)]) {                        devices = [NSMutableArray arrayWithArray:room.devices];            break;        }    }        NSArray *array = [self getDevices];  //  NSLog(@"the array is %@",array);    if (array.count != 0) {    if (devices.count != 0) {                if ([devices[0] isKindOfClass:[NSNumber class]]) {                    for (NSNumber *dev_id in devices) {                    for (DeviceModel *device in array) {                if([@(device.dev_id) isEqualToNumber:dev_id]) {                                        [models addObject:device];                    break;                }            }        }        }else        {            for (NSDictionary *dic in devices) {                                for (DeviceModel *device in array) {                                        if([@(device.dev_id) isEqualToNumber:dic[@"dev_id"]]) {                        [models addObject:device];                        break;                    }                }        }    }    }    }        return models;    //return nil;}-(BOOL)addNewDevice:(NSDictionary *)device{    NSMutableArray *mut = [NSMutableArray arrayWithArray:[self getDevicesArray]];        for (NSDictionary *dic in mut) {        // 如果存在 直接返回        if ([dic[@"dev_id"] isEqualToNumber:device[@"dev_id"]]) {            return NO;        }    }    //否则更新列表    [mut addObject:device];    NSDictionary *dict = @{@"devices":mut};    BOOL ret =[dict writeToFile:[self getHomePath:kDeviceInfo] atomically:YES];    return  ret;}-(BOOL)deleteDevice:(NSDictionary *)device{    NSArray *arr = [self getDevicesArray];    NSMutableArray *mut = [NSMutableArray arrayWithArray:arr];        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {        if ([[(NSDictionary *)obj objectForKey:@"dev_id"] integerValue] == [device[@"dev_id"] integerValue]) {            [mut removeObject:obj];            *stop = YES;        }    }] ;        NSDictionary *dict = @{@"devices":mut};    BOOL ret =[dict writeToFile:[self getHomePath:kDeviceInfo] atomically:YES];        // 删除常用列表    NSString *path_f = [self getHomePath:kFavorate_Device];        NSDictionary *arr_f = [NSDictionary dictionaryWithContentsOfFile:path_f];    NSString *address_f = [[[HouseModelHandle shareHouseHandle] currentHouse] address];        NSMutableArray *mods = [NSMutableArray arrayWithArray:arr_f[address_f]];        [arr_f[address_f] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {        if ([[(NSDictionary *)obj objectForKey:@"dev_id"] integerValue] == [device[@"dev_id"] integerValue]) {            [mods removeObject:obj];            *stop = YES;        }    }] ;        NSMutableDictionary *mut_dic = [NSMutableDictionary dictionaryWithDictionary:arr_f];    [mut_dic setObject:mods forKey:address_f];        BOOL ret_f = [mut_dic writeToFile:path_f atomically:YES];        return  ret&&ret_f;}-(BOOL )editeDevice:(NSDictionary *)device{    NSArray *arr = [self getDevicesArray];    NSMutableArray *mut = [NSMutableArray arrayWithArray:arr];        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {        if ([[(NSDictionary *)obj objectForKey:@"dev_id"] integerValue] == [device[@"dev_id"] integerValue]) {                        NSMutableDictionary *mutDic = [obj mutableCopy];            //[mut replaceObjectAtIndex:idx withObject:device];            [mutDic setObject:device[@"name"] forKey:@"name"];                        if ([device.allKeys containsObject:@"room_id"]&&device[@"room_id"]!= 0) {            [mutDic setObject:device[@"room_id"] forKey:@"room_id"];            }            if ([device.allKeys containsObject:@"sec_away"]) {                            [mutDic setObject:device[@"sec_away"] forKey:@"sec_away"];            [mutDic setObject:device[@"sec_stay"] forKey:@"sec_stay"];            [mutDic setObject:device[@"sec_disarm"] forKey:@"sec_disarm"];            }            [mut replaceObjectAtIndex:idx withObject:mutDic];                *stop = YES;        }    }] ;        NSDictionary *dict = @{@"devices":mut};    BOOL ret =[dict writeToFile:[self getHomePath:kDeviceInfo] atomically:YES];        // 更新常用列表    NSString *path_f = [self getHomePath:kFavorate_Device];        NSDictionary *arr_f = [NSDictionary dictionaryWithContentsOfFile:path_f];    NSString *address_f = [[[HouseModelHandle shareHouseHandle] currentHouse] address];        NSMutableArray *mods = [NSMutableArray arrayWithArray:arr_f[address_f]];    NSMutableDictionary *mut_dic = [NSMutableDictionary dictionaryWithDictionary:arr_f];       [arr_f[address_f] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {                if ([obj[@"dev_id"] isEqualToNumber:device[@"dev_id"]]) {            NSMutableDictionary *mutDic = [obj mutableCopy];                                    if ([device.allKeys containsObject:@"room_id"]&&device[@"room_id"]!= 0) {                [mutDic setObject:device[@"room_id"] forKey:@"room_id"];            }                        [mutDic setObject:device[@"name"] forKey:@"name"];            if ([device.allKeys containsObject:@"sec_away"]) {                                [mutDic setObject:device[@"sec_away"] forKey:@"sec_away"];                [mutDic setObject:device[@"sec_stay"] forKey:@"sec_stay"];                [mutDic setObject:device[@"sec_disarm"] forKey:@"sec_disarm"];            }            [mods replaceObjectAtIndex:idx withObject:mutDic];             [mut_dic setObject:mods forKey:address_f];            *stop = YES;        }    }];            BOOL ret_f = [mut_dic writeToFile:path_f atomically:YES];        return  ret&&ret_f;}-(BOOL)controlDevice:(NSDictionary *)device{    NSArray *arr = [self getDevicesArray];        NSMutableArray *mut = [NSMutableArray arrayWithArray:arr];        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {                if ([[(NSDictionary *)obj objectForKey:@"dev_id"] integerValue] == [device[@"dev_id"] integerValue]) {                        NSMutableDictionary *mutDic = [obj mutableCopy];            //[mut replaceObjectAtIndex:idx withObject:device];            [mutDic setObject:device[@"status"] forKey:@"status"];            [mut replaceObjectAtIndex:idx withObject:mutDic];                        *stop = YES;        }    }] ;        NSDictionary *dict = @{@"devices":mut};    BOOL ret =[dict writeToFile:[self getHomePath:kDeviceInfo] atomically:YES];            NSString *path_f = [self getHomePath:kFavorate_Device];    NSDictionary *dic_f = [NSDictionary dictionaryWithContentsOfFile:path_f];    NSMutableDictionary *mut_dic_f = [NSMutableDictionary dictionaryWithDictionary:dic_f];    NSString *address = [[[HouseModelHandle shareHouseHandle] currentHouse] address];    NSArray *arr_f = dic_f[address];    NSMutableArray *mut_f = [NSMutableArray arrayWithArray:arr_f];        [arr_f enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {        if ([[(NSDictionary *)obj objectForKey:@"dev_id"] integerValue] == [device[@"dev_id"] integerValue]) {                        NSMutableDictionary *mutDic = [obj mutableCopy];            [mutDic setObject:device[@"status"] forKey:@"status"];                        [mut_f replaceObjectAtIndex:idx withObject:mutDic];                        *stop = YES;        }    }] ;        [mut_dic_f setObject:mut_f forKey:address];        BOOL ret_f =[mut_dic_f writeToFile:[self getHomePath:kFavorate_Device] atomically:YES];        return ret && ret_f;}-(NSArray *)searchDevicesWithDev_id:(NSArray<NSNumber *> *)dev_ids{    NSArray *arr = [self getDevicesArray];    NSMutableArray *mut = [NSMutableArray array];        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {               for (NSNumber *dev_id in dev_ids) {            if ([[(NSDictionary *)obj objectForKey:@"dev_id"] isEqualToNumber:dev_id]) {                [mut addObject:obj];                                break;            }        }            }] ;        return mut;}//根据房间列表为device 分配room_id-(BOOL)addDevice_Room_id:(NSDictionary *)room_list{    NSArray *arr = [self getDevicesArray];    NSMutableArray *mut = [NSMutableArray arrayWithArray:arr];        NSString *path_room = [self getHomePath:kRoomInfo];    NSArray *array_room = [NSDictionary dictionaryWithContentsOfFile:path_room][@"rooms"];        for (NSDictionary *dic in array_room) {        if ([dic[@"dev_list"] count] != 0) {                        for (NSNumber *dev_id in dic[@"dev_list"]) {               [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {                   if ([obj[@"dev_id"] isEqualToNumber:dev_id]) {                       NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:obj];                       [mutDic setObject:dic[@"room_id"] forKey:@"room_id"];                       [mut replaceObjectAtIndex:idx withObject:mutDic];                                              *stop = YES;                   }               }];            }        }            }        NSDictionary *dict = @{@"devices":[mut copy]};        BOOL ret =[dict writeToFile:[self getHomePath:kDeviceInfo] atomically:YES];    return  ret;}//根据状态列表更新设备列表-(BOOL)setDeviceStatusWithList:(NSDictionary *)status{    NSMutableArray *mut = [NSMutableArray arrayWithArray:[self getDevicesArray]];      //  for (NSDictionary *dic in diction[@"devices"]) {        // 如果存在 直接返回    [[self getDevicesArray] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {                for (NSDictionary *dict in status[@"status_list"]) {            if ([dict[@"dev_id"] isEqualToNumber:obj[@"dev_id"]] ) {                                NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:obj];                if ([dict[@"status"] count] != 0) {                                   [mutDic setObject:dict[@"status"] forKey:@"status"];                                                        [mut replaceObjectAtIndex:idx withObject:mutDic];                }else                {#warning  - something wrong                    // 设为默认的关闭状态 和非触发状态                    if ([dict[@"mode"] isEqualToNumber:@(kDeviceSensor)]) {                        [mutDic setObject:@[@{@"id":@(2),@"params":@"AAAAAA=="}] forKey:@"status"];                        [mut replaceObjectAtIndex:idx withObject:mutDic];                    }else if ([dict[@"mode"] isEqualToNumber:@(kDeviceControl)])                    {                        [mutDic setObject:@[@{@"id":@(1),@"params":@"AA=="}] forKey:@"status"];                        [mut replaceObjectAtIndex:idx withObject:mutDic];                                            }                }                                break;            }        }          }];        NSDictionary *dict = @{@"devices":mut};        BOOL ret = [dict writeToFile:[self getHomePath:kDeviceInfo] atomically:YES];    NSString *path_f = [self getHomePath:kFavorate_Device];    NSDictionary *diction_f = [NSDictionary dictionaryWithContentsOfFile:path_f];    NSMutableDictionary *mut_dic_f = [NSMutableDictionary dictionaryWithDictionary:diction_f];    NSString *address = [[[HouseModelHandle shareHouseHandle] currentHouse] address];    NSArray *array_f = diction_f[address];    NSMutableArray *mut_f = [NSMutableArray arrayWithArray:array_f];        //  for (NSDictionary *dic in diction[@"devices"]) {    // 如果存在 直接返回    [array_f enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {                for (NSDictionary *dict in status[@"status_list"]) {            if ([dict[@"dev_id"] isEqualToNumber:obj[@"dev_id"]] ) {                                NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:obj];                               if ([dict[@"status"] count] != 0) {                                        [mutDic setObject:dict[@"status"] forKey:@"status"];                    [mut_f replaceObjectAtIndex:idx withObject:mutDic];                }else                {                    if ([dict[@"mode"] isEqualToNumber:@(0)]) {                        [mutDic setObject:@[@{@"id":@(2),@"params":@"AAAAAA=="}] forKey:@"status"];                        [mut_f replaceObjectAtIndex:idx withObject:mutDic];                    }else if ([dict[@"mode"] isEqualToNumber:@(1)])                    {                        [mutDic setObject:@[@{@"id":@(1),@"params":@"AA=="}] forKey:@"status"];                        [mut_f replaceObjectAtIndex:idx withObject:mutDic];                                            }                }                                break;            }        }            }];        [mut_dic_f setObject:mut_f forKey:address];        BOOL ret_f  = [mut_dic_f writeToFile:path_f atomically:YES];        return ret && ret_f;}-(NSArray<DeviceModel *> *)getDeviceWithDev_ID:(NSArray<NSNumber *> *)dev_ids{    NSMutableArray *devices = [NSMutableArray array];        NSArray *array = [self getDevices];        for (NSNumber * dev_id in dev_ids) {                for (DeviceModel *device in array) {                        if ([@(device.dev_id) isEqualToNumber:dev_id]) {                                [devices addObject:device];                break;            }        }    }    return devices;}-(NSArray<NSDictionary *> *)getDev_IDAndTab_IDWithDeveciModle:(NSArray<DeviceModel *> *)devices{    NSMutableArray *mut = [NSMutableArray arrayWithCapacity:devices.count];    for (DeviceModel *device in devices) {        NSDictionary *dic =@{@"table_id":@(device.table_id),@"dev_id":@(device.dev_id)};        [mut addObject:dic];    }    NSArray *array = [mut copy];    return array;}-(NSDictionary *)dictionaryWithDeviceModel:(DeviceModel *)device{    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:7];    [dic setObject:@(device.dev_id) forKey:@"dev_id"];    [dic setObject:@(device.table_id) forKey:@"table_id"];    [dic setObject:device.dev_type forKey:@"dev_type"];    [dic setObject:@(device.mode) forKey:@"mode"];    [dic setObject:device.name forKey:@"name"];    if (device.update_time) {        [dic setObject:@(device.update_time) forKey:@"update_time"];    }    if (device.status) {        [dic setObject:device.status forKey:@"status"];    }        return [dic copy];}-(NSString *)getDeviceNameWithDevice_type:(NSString *)dev_type{    if ([dev_type isEqualToString:@"AC05E02100000"]) {                return NSLocalizedString(@"Light", nil);//1 灯            }else if ([dev_type isEqualToString:@"A010402200000"])    {        return NSLocalizedString(@"Light", nil);//2 灯            }else if ([dev_type isEqualToString:@"A010400020000"])    {        return NSLocalizedString(@"Binary Switch", nil); // 3            }else if ([dev_type isEqualToString:@"A010400090000"])    {        return NSLocalizedString(@"Outlet", nil);// 4 插座            } else if ([dev_type isEqualToString:@"A010400510000"])    {        return NSLocalizedString(@"Outlet", nil);//5 插座    }        else if ([dev_type isEqualToString:@"A010401000000"])    {        return NSLocalizedString(@"Relay", nil);//6 继电器            }else if ([dev_type isEqualToString:@"A010404020000"])    {        return NSLocalizedString(@"Sensor", nil);//7 传感            }else if ([dev_type isEqualToString:@"A010404020015"])    {        return NSLocalizedString(@"Door Sensor", nil);//8 门磁            }else if ([dev_type isEqualToString:@"A01040402000D"])    {        return NSLocalizedString(@"Infrared Sensor", nil);//9 红外            }else if ([dev_type isEqualToString:@"A010404020028"])    {        return NSLocalizedString(@"Smoke Sensor", nil);// 10 烟雾            }else if ([dev_type isEqualToString:@"A01040402002B"])    {        return NSLocalizedString(@"Gas Sensor", nil);//11 气体            }else if ([dev_type isEqualToString:@"A010404028001"])    {        return NSLocalizedString(@"CO Sensor", nil);//12 一氧化碳            }else if ([dev_type isEqualToString:@"A01040402002D"])    {        return NSLocalizedString(@"Shake Sensor", nil);//13 震动            }else if ([dev_type isEqualToString:@"A01040402002A"])    {        return NSLocalizedString(@"Water Sensor", nil);//14 水浸            }else if ([dev_type isEqualToString:@"A010404020115"])    {        return NSLocalizedString(@"Remote Control", nil);//15 远程            }else if ([dev_type isEqualToString:@"A01040402002C"])    {        return NSLocalizedString(@"SOS Sensor", nil);//16 急救            }else if ([dev_type isEqualToString:@"A010404030225"])    {        return NSLocalizedString(@"Siren Sensor", nil);//17 色温            }else if ([dev_type isEqualToString:@"A010403020000"])    {        return NSLocalizedString(@"Humidity_Temperature Sensor", nil);//18 温湿度    }            // z-wave    else if ([dev_type isEqualToString:@"CA04070106070"])    {        return NSLocalizedString(@"Door Sensor", nil);//门磁    }    else if ([dev_type isEqualToString:@"CP04100100000"])    {        return NSLocalizedString(@"Outlet", nil);//插头    }    else if ([dev_type isEqualToString:@"CA04070107000"])    {        return NSLocalizedString(@"Infrared Sensor", nil);//红外    }        else    {        return @"Unknown";// 未知 ；    }}-(NSArray *)getOpennedDeviceWithSceneModle:(sceneModel *)scene{    NSMutableArray *mut = [NSMutableArray array];        NSArray *action_list = scene.action_list;        NSArray *devices = [self getDevices];    for (DeviceModel  *dev in devices) {        for (NSDictionary *dic in action_list) {            if ((dev.dev_id == [dic[@"dev_id"] integerValue]) && ([dic[@"action_params"]  isEqual: @"AQ=="])) {                [mut addObject:dev];                break;            }        }    }        return [mut copy];    }-(NSArray *)getClosedDeviceWithSceneModle:(sceneModel *)scene{    NSMutableArray *mut = [NSMutableArray array];        NSArray *action_list = scene.action_list;        NSArray *devices = [self getDevices];    for (DeviceModel  *dev in devices) {        for (NSDictionary *dic in action_list) {            if (dev.dev_id == [dic[@"dev_id"] integerValue] && ([dic[@"action_params"]  isEqual: @"AA=="])) {                [mut addObject:dev];                break;            }        }    }    return [mut copy];}-(NSArray *)actionListWithOpenDevice:(NSArray *)open closeDevice:(NSArray *)close{    /* scene_name:'SceneA',     select_mode:0, //设防模式 1:AWAY 2:STAY 3:DISARM     action_list:[     {     dev_id:111,     action_id:1,     action_params:"MQ=="     }，     ......     ]*/    NSMutableArray *mut = [NSMutableArray array];    char c0 = 0 & 0xff;    char c1 = 1 & 0xff;    NSString *para0 = [GTMBase64 stringByEncodingBytes:&c0 length:1];    NSString *para1 = [GTMBase64 stringByEncodingBytes:&c1 length:1];        for (DeviceModel *dev in open) {        NSDictionary *dic = @{@"dev_id":@(dev.dev_id),@"action_id":@(1),@"action_params":para1};//,@"table_id":@(1)        [mut addObject:dic];    }    //,@"table_id":@(1)    for (DeviceModel *dev in close) {        NSDictionary *dic = @{@"dev_id":@(dev.dev_id),@"action_id":@(1),@"action_params":para0};        [mut addObject:dic];    }        return [mut copy];}#pragma mark - rooms-(NSArray<roomsModel *> *)getRooms{    NSString *path = [self getHomePath:kRoomInfo];    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];    NSArray *arr = dic[@"rooms"];        NSMutableArray *rooms = [NSMutableArray array];    for (NSDictionary *dic in arr) {                roomsModel *mod = [[roomsModel alloc] initWithDictionary:dic];        [rooms addObject:mod];    }    return rooms;}//根据传入的字典添加或者删除房间列表-(BOOL)addNewRoom:(NSDictionary *)room{    NSString *path = [self getHomePath:kRoomInfo];    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];    NSMutableArray *mut = [NSMutableArray arrayWithArray:dic[@"rooms"]];        [mut addObject:room];        NSDictionary *dict = @{@"rooms":mut};    BOOL ret =[dict writeToFile:[self getHomePath:kRoomInfo] atomically:YES];        return  ret;}-(BOOL)deleteRoom:(NSDictionary *)room{        NSString *path = [self getHomePath:kRoomInfo];    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];    NSArray *arr = dic[@"rooms"];    NSMutableArray *mut = [NSMutableArray arrayWithArray:arr];        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {        if ([(roomsModel *)obj room_id] == [room[@"room_id"] integerValue]) {            [mut removeObject:obj];            *stop = YES;        }    }] ;        NSDictionary *dict = @{@"rooms":mut};    BOOL ret =[dict writeToFile:[self getHomePath:kRoomInfo] atomically:YES];        return  ret;}//根据room_id返回room信息字典-(NSDictionary *)dictionWithRoom_id:(NSInteger )room_id{    NSString *path = [self getHomePath:kRoomInfo];    NSArray *array = [NSDictionary dictionaryWithContentsOfFile:path][@"rooms"];         for (NSDictionary *dic in array) {                if ([dic[@"room_id"] integerValue] == room_id) {            return [dic copy];        }    }        return nil;    }#pragma mark -scenes-(NSArray<sceneModel *> *)getScenes{    NSString *path = [self getHomePath:kSceneInfo];    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];    NSArray *arr = dic[@"scenes"];        NSMutableArray *rooms = [NSMutableArray array];    for (NSDictionary *dic in arr) {        sceneModel *mod = [[sceneModel alloc]initWithDictionary:dic];        [rooms addObject:mod];    }    return rooms;}-(BOOL )addNewScene:(NSDictionary *)scene{    NSString *path = [self getHomePath:kSceneInfo];    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];       NSMutableArray *mut = [NSMutableArray arrayWithArray:dic[@"scenes"]];        [mut addObject:scene];        NSDictionary *dict = @{@"scenes":mut};        BOOL ret =[dict writeToFile:[self getHomePath:kSceneInfo] atomically:YES];        return  ret;}-(BOOL )deleteScene:(NSNumber *)scene_id{    NSString *path = [self getHomePath:kSceneInfo];        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];        NSMutableArray *mut = [NSMutableArray arrayWithArray:dic[@"scenes"]];        [[mut copy] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {        if ([obj[@"scene_id"] isEqualToNumber:scene_id]) {            [mut removeObjectAtIndex:idx];            *stop = YES;        }    }];        NSDictionary *dict = @{@"scenes":mut};        // delete picture    NSString *address = [HouseModelHandle shareHouseHandle].currentHouse.address;    NSString *key = [NSString stringWithFormat:@"%@scene_id%@.png",address,scene_id];        NSString *path_ = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),key];        [[NSFileManager defaultManager] removeItemAtPath:path_ error:nil];            BOOL ret =[dict writeToFile:[self getHomePath:kSceneInfo] atomically:YES];        return  ret;}-(BOOL )editScene:(NSDictionary *)scene{        NSString *path = [self getHomePath:kSceneInfo];        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];        NSMutableArray *mut = [NSMutableArray arrayWithArray:dic[@"scenes"]];        [[mut copy] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {        if ([obj[@"scene_id"] isEqualToNumber:scene[@"scene_id"]]) {            [mut replaceObjectAtIndex:idx withObject:scene];            *stop = YES;        }    }];        NSDictionary *dict = @{@"scenes":mut};        BOOL ret =[dict writeToFile:[self getHomePath:kSceneInfo] atomically:YES];        return  ret;}#pragma mark - modes//获取安全列表-(NSArray<securityModel *> *)getSecurities{    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[self getHomePath:kSecurityInfo]];        NSMutableArray *mut = [NSMutableArray array];        if ([dic.allKeys containsObject:@"modes"]) {        NSArray *array = dic[@"modes"];                for (NSDictionary *dict in array) {                        securityModel *security = [[securityModel alloc] initWithDictionary:dict];            [mut addObject:security];        }    }    return mut;}//更新modeList-(BOOL )editeMode:(NSDictionary *)mode{    NSString *path = [self getHomePath:kSecurityInfo];    NSString *path_ = [self getHomePath:kSecurityMotion];        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];        NSMutableArray *mut = [NSMutableArray arrayWithArray:dic[@"modes"]];    [[mut copy] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {        if ([obj[@"sec_mode"] isEqualToNumber:mode[@"sec_mode"]]) {            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:obj];            [mutDic setObject:mode[@"dev_list"] forKey:@"dev_list"];            [mutDic setObject:mode[@"no_motion"] forKey:@"no_motion"];            [mut replaceObjectAtIndex:idx withObject:mutDic];            *stop = YES;        }    }];        NSDictionary *dict = @{@"modes":mut};        BOOL ret = [dict writeToFile:path atomically:YES];     NSMutableDictionary *mut_ = [NSMutableDictionary dictionary];    [mut_ setObject:mode[@"no_motion"] forKey:[NSString stringWithFormat:@"%@",mode[@"sec_mode"]]];        BOOL ret_ = [mut_ writeToFile:path_ atomically:YES];        return ret&&ret_;}#pragma mark - others-(NSString *)getBundlePath:(NSString *)fileName{    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];        return path;}-(NSString *)getHomePath:(NSString *)fileName{    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),fileName];        return path;}-(BOOL )clearList{    NSArray *removes = @[[self getHomePath:kDeviceInfo],[self getHomePath:kRoomInfo],[self getHomePath:kSecurityInfo],[self getHomePath:kSceneInfo],[self getHomePath:kFavorate_Device],[self getHomePath:MEMBERINFO]];        NSArray *notifications = @[kNotification_deviceListUpdated,kNotification_roomListUpdated,kNotification_modeListUpdated,kNotification_sceneListUpdated,kNotification_FavorateDeviceListUpdated,MEMBERINFO];        for (NSInteger i = 0; i<removes.count ; i++) {        BOOL ret  = [[NSFileManager defaultManager] removeItemAtPath:removes[i] error:nil];        if (ret) {                        [[NSNotificationCenter defaultCenter] postNotificationName:notifications[i] object:nil];        }        }        return YES;}-(NSDictionary *)getImageNameWithDevice_type:(NSString *)dev_type device_mode:(NSInteger )mode{    NSArray *array = nil;        array = [NSArray arrayWithContentsOfFile:[self getBundlePath:kImage_dev_type]];        if (mode == 0) {        //sensor A01040402000D        if ([[array[1] allKeys] containsObject:dev_type]) {            return  [array[1] objectForKey:dev_type];//返回个字典        }    }else if(mode == 1 )    {        // control        if ([[array[0] allKeys] containsObject:dev_type]) {            return  [array[0] objectForKey:dev_type];//返回个字典        }    }    else{                return @{@"device":@"ic_unknown_device_",@"room":@"ic_unknown_device_",@"nowork":@"ic_unknown_device_",@"safety":@"ic_unknown_device_",@"on":@"ic_unknown_device_",@"off":@"ic_unknown_device_"};    }        return nil;}#pragma mark -  以后这几个方法可能会被删除//获取cell信息-(NSArray *)getCellInfoWithCellName:(NSString *)cellName{        NSString *path = [[NSBundle mainBundle]pathForResource:cellName ofType:@"Plist"];        NSArray *cellInfo = [NSArray arrayWithContentsOfFile:path];            return cellInfo;}-(NSMutableArray *)getDataWithCellName:(NSString *)cellName{    NSArray *_totalData = [[fileOperation sharedOperation]getCellInfoWithCellName:cellName];    NSMutableArray *dataList = [NSMutableArray array];    [dataList addObject:_totalData[0]];    for (NSInteger i =1; i<_totalData.count; i++) {        NSMutableArray *data = [NSMutableArray array];        for (NSInteger j=0; j<[_totalData[i][@"item"] count]; j++) {            AddData *mod = [[AddData alloc]init];            mod.title = _totalData[i][@"item"][j];            mod.hasImage = NO;            mod.accessayType = kAccessaryTypeSwitch;            [data addObject:mod];        }        NSDictionary *cellInfo = @{@"section":_totalData[i][@"section"],@"item":data};                [dataList addObject:cellInfo];            }    return dataList;}@end