//
//  HouseModelHandle.h
//  security
//
//  Created by sen5labs on 15/10/21.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HouseModel.h"
extern NSString * const CurrentHouseDidChangeHouseNotification;  /// 改变当前house

extern NSString * const HouseUserDefaultKey;
extern NSString * const CurrentHouseDefaultKey;

@interface HouseModelHandle : NSObject

+ (instancetype)shareHouseHandle;

@property (nonatomic, strong) HouseModel *currentHouse;

/// 根据address增加房子(房子自动命名)
- (void)addWithAddress:(NSString *)address;

/** 是否存在该地址房子 */
- (BOOL)isExistHouseWithAdress:(NSString *)address;


/// 增加房子
- (void)addWithHouse:(HouseModel *)houseModel;

/// 删除房子
- (void)removeWithHouse:(HouseModel *)houseModel;


/// 修改房子
- (void)updateWithHouse:(HouseModel *)houseModel;


/// 查找房子
- (NSArray *)houses;

@end
