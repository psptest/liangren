//
//  selectRoomForDeviceViewController.h
//  security2.0
//
//  Created by Sen5 on 16/6/1.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "myTableViewController.h"
@class roomsModel;
@class DeviceModel;

@protocol selecteRoomForDeviceDelegate <NSObject>
-(void)haveSelectedRooms:(NSArray *)rooms;
@end
@interface selectRoomForDeviceViewController : myTableViewController

@property(nonatomic,weak)id<selecteRoomForDeviceDelegate> delegate;

-(id)initWithDeviceModel:(DeviceModel *)mod;

@end