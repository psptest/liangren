//
//  HouseModelHandle.m
//  security
//
//  Created by sen5labs on 15/10/21.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import "HouseModelHandle.h"

static HouseModelHandle * _houseHandle = nil;

NSString * const CurrentHouseDidChangeHouseNotification = @"CurrentHouseDidChangeHouseNotification";
NSString * const HouseUserDefaultKey = @"HouseUserDefaultKey";
NSString * const CurrentHouseDefaultKey = @"CurrentHouseDefaultKey";

@interface HouseModelHandle () {
    HouseModel * _currentHouse;
}

@property (nonatomic, strong) NSMutableArray < HouseModel *> *houseArray;

@end

@implementation HouseModelHandle

//单例
+ (instancetype)shareHouseHandle {

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _houseHandle = [[HouseModelHandle alloc] init];
        });
        return _houseHandle;
}

//实例化
- (instancetype)init
{
    self = [super init];
    if (self) {

        if (self.houses.count < 1) {
            
#if TARGET_IPHONE_SIMULATOR
            // 自己加上test  模拟器 不能扫描二维码
            HouseModel * model = [[HouseModel alloc] init];
            model.address = @"RUZZI-000027-HWNVF";
            model.name = @"House 1";
            [self addWithHouse:model];
#elif TARGET_OS_IPHONE

#endif
        
        }

    }
    return self;
}
//增加房子 命名方式自动加1 增加房子并没有判断对应地址是否有房子 应该是无则才增加
- (void)addWithAddress:(NSString *)address {
    NSString * name = [NSString stringWithFormat:@"%@ %d",@"House",(int)[self houseArray].count + 1];
    HouseModel *house = [[HouseModel alloc] init];
    //根据self houseArray 的count +1 命名house.name 并传值house.address
    house.name = name;
    house.address = address;
    //添加house 并将house作为currentHouse
    self.currentHouse = house;
    [self addWithHouse:house];
}

/// 增加房子
- (void)addWithHouse:(HouseModel *)houseModel {
    [[self houseArray] addObject:houseModel];
    [self synchronizeHouse];
}

/// 删除房子
- (void)removeWithHouse:(HouseModel *)houseModel {
    
  //  NSAssert(houseModel, @"houseModel 不能为nil");
    [[self houseArray] removeObject:houseModel];
    
//    if ([houseModel.address isEqualToString:self.currentHouse.address]) {
//        if (self.houseArray.count > 0) {
//            self.currentHouse = self.houseArray[0];
//        } else {
//            self.currentHouse = nil;
//        }
//        [self synchronizeCurrentHouse];
//    }
    
    NSString *address = houseModel.address;
    
    [self synchronizeHouse];
}

/// 查找房子
- (NSArray *)houses {
    //如果已经读取了  则直接copy
    if ([self houseArray].count > 0) {
        return [self.houseArray copy];
    }
    // 从沙河路径中直接读取
    NSData * houseData = [[NSUserDefaults standardUserDefaults] objectForKey:HouseUserDefaultKey];
    
    if ([houseData isKindOfClass:[NSData class]]) {
        //从houseData中接档数据
        NSArray * houseArray = [NSKeyedUnarchiver unarchiveObjectWithData: houseData];
        if (houseArray.count > 0) {
           // [[self houseArray] removeAllObjects];
            [[self houseArray] addObjectsFromArray:houseArray];
        }
    }
    
    return [NSArray arrayWithArray:[self houseArray]];
}

/// 修改房子
- (void)updateWithHouse:(HouseModel *)houseModel {
    __block NSUInteger uint = NSNotFound;
    __weak HouseModel * weakHouseModel = houseModel;
    [[self houseArray] enumerateObjectsUsingBlock:^(HouseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.address isEqualToString:weakHouseModel.address]) {
            uint = idx;
            *stop = YES;
        }
    }];
    if (uint == NSNotFound) {
        //如果不存在则增加 否则变更
        [[self houseArray] addObject:houseModel];
    } else {
        [[self houseArray] replaceObjectAtIndex:uint withObject:houseModel];
    }
    [self synchronizeHouse];
    
}

//判断对应地址的房子是否存在
- (BOOL)isExistHouseWithAdress:(NSString *)address {
    __block NSUInteger uint = NSNotFound;
    [[self houseArray] enumerateObjectsUsingBlock:^(HouseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.address isEqualToString:address]) {
            uint = idx;
            *stop = YES;
        }
    }];
    if (uint == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

//更新houseName
- (void)house:(HouseModel *)houseModel updateWithHouseName:(NSString *)name {
    houseModel.name = name;
    [self updateWithHouse:houseModel];
}

- (void)synchronizeHouse {
    //归档 并存储信息
    NSData *archiveHouseData = [NSKeyedArchiver archivedDataWithRootObject:[self houseArray]];
    [[NSUserDefaults standardUserDefaults] setObject:archiveHouseData
                                              forKey:HouseUserDefaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//同步当前房屋数据
- (void)synchronizeCurrentHouseWithHouse:(HouseModel *)houseModel {
    if (houseModel == nil) {
//        NSAssert((!HouseModel), @"houseModel为nil时删除之前的");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CurrentHouseDefaultKey];
    } else {
        //将当前房屋信息归档
        NSData *archiveHouseData = [NSKeyedArchiver archivedDataWithRootObject:self.currentHouse];
        NSAssert(archiveHouseData, @"currentHouse不能为nil");
        [[NSUserDefaults standardUserDefaults] setObject:archiveHouseData
                                                  forKey:CurrentHouseDefaultKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//懒加载houseArray
- (NSMutableArray<HouseModel *> *)houseArray {
    if (!_houseArray) {
        _houseArray = [NSMutableArray array];
    }
    return _houseArray;
}

//设置当前房屋 并发送通知
- (void)setCurrentHouse:(HouseModel *)currentHouse {
    _currentHouse = currentHouse;
    [self synchronizeCurrentHouseWithHouse:currentHouse];
    [[NSNotificationCenter defaultCenter] postNotificationName:CurrentHouseDidChangeHouseNotification
                                                        object:currentHouse];
    
}
//获取当前房屋
- (HouseModel *)currentHouse {
    if (!_currentHouse) {
    
        NSData * houseData = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentHouseDefaultKey];
        if ([houseData isKindOfClass:[NSData class]]) {
            HouseModel * houseModel = [NSKeyedUnarchiver unarchiveObjectWithData: houseData];
            _currentHouse = houseModel;
        }
    }
    return _currentHouse;
}

@end
