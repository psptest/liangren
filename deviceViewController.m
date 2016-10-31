 //
//  deviceViewController.m
//  security2.0
//
//  Created by Sen5 on 16/3/25.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "deviceViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "roomLightController.h"
#import "UIViewController+MBProgressHUD.h"
#import "fileOperation.h"
#import "UIImageView+imageSizeOperation.h"
#import "prefrenceHeader.h"
#import "DeviceModel.h"
#import "P2Phandle.h"
#import "socketReader.h"
#import "addButton.h"
#import "accessoryCell.h"
#import "deviceCell.h"
#import "initDeviceController.h"
#import "LookingDeviceController.h"
#import "selectRoomForDeviceViewController.h"
#import "initDeviceController.h"
#import "MBProgressHUD.h"
#import "RODeviceHandle.h"
#define kCellHeight 64
#define kMinimumTitleLength
#define kHubViewShowDuration 5

@interface deviceViewController ()<initDeviceControllerDelegate,deviceCellDelegate,accessoryCellDelegate>
@property(nonatomic,strong)MBProgressHUD *hubView;
@end
@implementation deviceViewController
{
    BOOL _isSetting;
    BOOL _open;
    deviceCell *_selectCell;
    
    //为了数据读取写入更方便 建立两个数据源
    NSMutableArray *_devices;
    NSMutableArray *_sensors;
    NSMutableArray *_remotes;
}
- (instancetype)initWithDevices:(NSArray *)devices isSetting:(BOOL)isSetting;
{
    self = [super init];
    if (self) {
        _isSetting = isSetting;
        _open = NO;
        _devices = [NSMutableArray array];
        _sensors = [NSMutableArray array];
        _remotes = [NSMutableArray array];
        [self createModelWithDevices:devices];
        
        [self addNotifications];
    }
    return self;
}


#pragma mark - add notifications
-(void )addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceListHaveUpdated) name:kNotification_deviceListUpdated object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceStatusHaveChanged:) name:kNotification_controlDevice object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusListUpdated:) name:knotification_statusList object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceEdited:) name:kNotification_deviceEditted object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDeleted:) name:kNotification_deviceDeleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceAdded:) name:kNotification_newDevieAdded object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)createModelWithDevices:(NSArray *)devices
{
    [_devices removeAllObjects];
    [_sensors removeAllObjects];
    [_remotes removeAllObjects];
    NSArray *array = [devices copy];
    
    for (DeviceModel *device in array) {
        switch (device.mode) {
            case kDeviceSensor:
            {
                // 将布防遥控器单独拿出
                if ([device.dev_type isEqualToString:@"A010404020115"]) {
                    [_remotes addObject:device];
                }else
                {
                    [_sensors addObject:device];
                }
            }
                break;
            case kDeviceControl:
                [_devices addObject:device];
                break;
                
            default:
                break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    if (_isSetting) {
        
        [self.tableView registerClass:[accessoryCell class] forCellReuseIdentifier:@"reuse"];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBtnClicked)];
        
        [self addBackBtn:NSLocalizedString(@"Devices", nil)];
        
    }else
    {
        [self.tableView  registerClass:[deviceCell class] forCellReuseIdentifier:@"reuse"];
        [self addBackBtn:NSLocalizedString(@"Back", nil)];
    }
}

#pragma mark - tableViewDelegate
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_devices.count != 0 || _devices != nil) {
        return 3;
    }else
    {
        return 0;
    }
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isSetting) {
        if (indexPath.section == 2) {
            
            return 60;
        }else
        {
            return 100;
        }
    }else
    {
        return 60;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return NSLocalizedString(@"Sensor", nil);
    }else if(section == 0)
    {
        return NSLocalizedString(@"Control", nil);
    }else
    {
        return NSLocalizedString(@"Remote Control", nil);
    }
    
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            if (_devices.count != 0) {
                return 40;
            }else
            {
                return 0;
            }
        }
            break;
        case 1:
        {
            if (_sensors.count != 0) {
                return 40;
            }else
            {
                return 0;
            }
        }
            break;
        case 2:
        {
            if (_remotes.count != 0) {
                return 40;
            }else
            {
                return 0;
            }
        }
            break;
            
        default:
            return 0;
            break;
    }
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return _devices.count;
        
    }else  if (section == 1)
    {
        return _sensors.count;
        
    }else
    {
        return _remotes.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceModel *mod = nil;
    
    if (indexPath.section == 0) {
        
        mod = _devices[indexPath.row];
        
    }else if (indexPath.section == 1)
    {
        mod = _sensors[indexPath.row];
    }else
    {
        
        mod = _remotes[indexPath.row];
    }
    
    
    // 判断特殊设备
    [self judgeParticularDevices:mod];
    
    if (!_isSetting) {
        
        //非设置界面 button可点击
        deviceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"reuse"];
        
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell refreshUIWithModel:mod];
        return cell;
    }else
    {
        accessoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];

        [cell setType:kAccessayTypeArrow];
        [cell setText:mod.name];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;

         [cell setImage:[UIImage imageNamed:[[fileOperation sharedOperation] getImageNameWithDevice_type:mod.dev_type device_mode:mod.mode][@"device"]]];
        
        cell.delegate = self;
        return cell;
    }
    
  
    
}
#pragma mark - deviceCellDelegate
-(void)controlDevice:(deviceCell *)device
{
    NSIndexPath *index = [self.tableView indexPathForCell:device];
    
    DeviceModel *mod = _devices[index.row];
    
    _selectCell = device;// 记录选中cell
    
    if ([[P2Phandle shareP2PHandle] linkState ] == P2PLinkConnnected) {
        
        if (mod.status.count != 0) {
            
            
            if ([mod.status[0][@"params"] isEqualToString:@"AQ=="]) {
                //如果选中状态 则关闭
                [[P2Phandle shareP2PHandle] ControlDeviceWithDeviceID:mod.dev_id tableID:mod.table_id action:0];
            }else
            {
                //如果未选中 则打开
                [[P2Phandle shareP2PHandle] ControlDeviceWithDeviceID:mod.dev_id tableID:mod.table_id action:1];
            }
        }else
        {
            // 之前用的随机数 但是还是不是很合理  所以建立一个全局变量
            [[P2Phandle shareP2PHandle] ControlDeviceWithDeviceID:mod.dev_id tableID:mod.table_id action:_open];
            _open = !_open;
        }
        
        [self.hubView show:YES];
        [self.hubView hide:YES afterDelay:kHubViewShowDuration];
        
    }else
    {
        [self showWithTime:hubAnimationTime title:kConnectedFailed];
    }
    
}
#pragma mark - accessaryCellDelegate
-(void)accessoryBtnClicked:(accessoryCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    
    DeviceModel *device = nil;
    if (index.section == 0) {
        // action
        device = _devices[index.row];
    }else if (index.section == 1)
    {
        device = _sensors[index.row];
    }else
    {
        device = _remotes[index.row];
    }
    
    initDeviceController *init =[[initDeviceController alloc] initWithModel:device];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:init animated:YES];
}

#pragma mark - notification
//control device
-(void)deviceStatusHaveChanged:(NSNotification *)notice
{
    [self.hubView hide:YES];
    
    NSDictionary *diction = notice.object;
#warning 有问题
    
//    
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
#if 0
    if ([diction[@"status"] count] != 0) {
        
        if ([diction[@"status"][0][@"id"] isEqual:@(1)]) {
             [self RefreshDeviceUIWithDictionary:diction dev_mode:1];
            
    }else if([diction[@"status"][0][@"id"] isEqual:@(2)]){
        
        [self RefreshDeviceUIWithDictionary:diction dev_mode:0];
        
    }else if ([diction[@"status"][0][@"id"] isEqual:@(7)])
    {
        [self RefreshDeviceUIWithDictionary:diction dev_mode:0];
    }
    else if ([diction[@"status"][0][@"id"] isEqual:@(9)])
    {
        [self RefreshDeviceUIWithDictionary:diction dev_mode:0];
        [self resumeDeviceUI];
    }
    }
#endif
    
    NSDictionary *dict = [[RODeviceHandle sharedDeviceHandle ] StatusOrEventWithObject:diction];
    
    NSString *notificationName = dict[@"notificationName"];
    NSDictionary *userInfo = dict[@"userInfo"];
    
    if ([notificationName isEqualToString:NOTIFICATION_ON_OR_OF]) {
        
        [self RefreshDeviceUIWithDictionary:userInfo dev_mode:1];
        
    }else if ([notificationName isEqualToString:NOTIFICATION_ORDINARY_SENSOR])
    {
        [self RefreshDeviceUIWithDictionary:userInfo dev_mode:0];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_deviceChanged object:nil];
}
-(void )deviceAdded:(NSNotification *)notice
{
    NSDictionary *dic = notice.object;
    
    [[fileOperation sharedOperation] addNewDevice:dic];
    //更新数据源
   // DeviceModel *dev = [[DeviceModel alloc] initWithDictionary:dic];
    self.dataList = nil;
   self.dataList = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getDevices]];
   [self createModelWithDevices:self.dataList];
    //刷新数据
 
        [self.tableView reloadData];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_deviceChanged object:nil];
}

// delete device
-(void)deviceDeleted:(NSNotification *)notice
{
    // 删除设备 重新请求 设备 场景列表
    [[P2Phandle shareP2PHandle] getRoomList];
    [[P2Phandle shareP2PHandle] getSceneList];
    [[P2Phandle shareP2PHandle] getModeList];
    
    NSDictionary *dic = notice.object;
    // 1 更新列表
    [[fileOperation sharedOperation] deleteDevice:dic];
    
    // 2 刷新数据
    NSArray *array_device = [_devices copy];
    NSArray *array_sensor = [_sensors copy];
    NSArray *array_remote = [_remotes copy];
    
    for (DeviceModel *device in array_device) {
        if (device.dev_id == [dic[@"dev_id"] integerValue]) {
            [_devices removeObject:device];
            break;
        }
    }
    //控制设备未删除
    if (array_device.count == _devices.count) {
        for (DeviceModel *device in array_sensor) {
            if (device.dev_id == [dic[@"dev_id"] integerValue]) {
                [_sensors removeObject:device];
                break;
            }
        }
    }
    
    if (array_sensor.count == _sensors.count) {
        
        for (DeviceModel *device in array_remote) {
            if (device.dev_id == [dic[@"dev_id"] integerValue]) {
                [_remotes removeObject:device];
                break;
            }
        }
    }
 
        [self.tableView reloadData];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_deviceChanged object:nil];
}

// edti device
-(void)deviceEdited:(NSNotification *)notice
{
    // 删除设备 重新请求 设备 场景列表 没有场景 因为编辑没有对场景的改变
    [[P2Phandle shareP2PHandle] getRoomList];
    [[P2Phandle shareP2PHandle] getModeList];
    
    NSDictionary *dic = notice.object;
    
   BOOL ret =  [[fileOperation sharedOperation] editeDevice:dic];
    
    if (ret) {
        
        self.dataList = nil;
        
        self.dataList = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getDevices]];
        [self createModelWithDevices:self.dataList];
     
            [self.tableView reloadData];
        
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_deviceChanged object:nil];
}
-(void)deviceListHaveUpdated
{
    //更新数据源
    self.dataList = nil;
    self.dataList = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getDevices]];
    
    [self createModelWithDevices:self.dataList];
    
    
    //刷新数据
    [self.tableView reloadData];
    
    
}

-(void )statusListUpdated:(NSNotification *)notice
{
    //更新数据源
    self.dataList = nil;
    self.dataList = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getDevices]];
    
    [self createModelWithDevices:self.dataList];
    [self.tableView reloadData];

}
#pragma mark - 设备处理
-(void )judgeParticularDevices:(DeviceModel *)device
{
    if ([device.dev_type isEqualToString:@"A010403020000"]) {
        
    }

}

#pragma mark - private

-(void )RefreshDeviceUIWithDictionary:(NSDictionary *)diction dev_mode:(NSInteger )dev_mode
{
    NSArray *arr = nil;
    NSMutableArray *mut = nil;
    NSUInteger integ = 0;
    
    DeviceModel *dev = [[fileOperation sharedOperation] getDeviceWithDev_ID:@[diction[@"dev_id"]]][0];
 
    if (dev_mode == 0) {
        
        //远程遥控
        if ([dev.dev_type isEqualToString:@"A010404020115"]) {
            arr = [_remotes copy];
            mut = _remotes;
            integ = 2;
        }else
        {
            arr = [_sensors copy];
            mut = _sensors;
            integ = 1;
        }
  
    }else if(dev_mode == 1)
    {
      arr = [_devices copy];
        mut = _devices;
        integ = 0;
    }
    
    if (arr.count != 0) {
        
       // NSUInteger section = 1;
        __block NSUInteger row = 0;
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([(DeviceModel *)obj dev_id] == [diction[@"dev_id"] integerValue]) {
//                id = 2;
//                params = "AQAAEA==";
                NSDictionary *dic = @{@"id":@(1),@"params":diction[@"params"]};
                
                ((DeviceModel *)mut[idx]).status = @[dic];
                row = idx;
                *stop = YES;
            }
        }];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:integ];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


-(void )resumeDeviceUI
{
 // 之后需要将Infrade_sensor——Z_Wave恢复
#if 0
    {
        "dev_id" = 5;
        "msg_type" = 106;
        status =     (
                      {
                          id = 9;
                          params = "CA==";
                      }
                      );
    }
#endif
    
}
#pragma mark - click event
-(void)rightBtnClicked
{
    self.hidesBottomBarWhenPushed = YES;
    LookingDeviceController *look = [[LookingDeviceController alloc] init];
    
    [self.navigationController pushViewController:look animated:YES];
}


- (MBProgressHUD *)hubView {
    if (!_hubView) {
        
        if (self.view.window) {
            MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:HUD];
            [HUD hide:YES];
            _hubView = HUD;
        }
    }
    return _hubView;
}
@end