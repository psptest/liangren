//
//  sellectDeviceForRoomController.m
//  security2.0
//
//  Created by Sen5 on 16/6/20.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//
#import "sellectDeviceForRoomController.h"
#import "deviceViewController.h"
#import "fileOperation.h"
#import "roomsModel.h"
#import "DeviceModel.h"
#import "myButtonItem.h"
#import "AddNewRoomViewController.h"
#import "selectCell.h"
@interface sellectDeviceForRoomController ()<selectCellDelegate>
@end
@implementation sellectDeviceForRoomController
{
    roomsModel *_room;
    NSMutableArray *_selectedDevices;
    
    NSInteger _asignedDeviceCount;
}
- (instancetype)initWithRoomModel:(roomsModel *)room
{
    self = [super init];
    if (self) {
        
        _room = room;
        
        _selectedDevices = [[NSMutableArray alloc] init];
        
        NSArray<DeviceModel *> *devices = [[fileOperation  sharedOperation] getAssignedDevicesWithModel:_room];
       // NSMutableArray *mutArr = [NSMutableArray array];
        for (DeviceModel *dev in devices) {
            dev.isFavorate = YES;
        }
        NSArray<DeviceModel *> *idleDevices = [[fileOperation sharedOperation] getIdleDevices];
        NSMutableArray *mut = [NSMutableArray array];
        [mut addObjectsFromArray:devices];
        [mut addObjectsFromArray:idleDevices];
        self.dataList = mut;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(actionDone)];
    
    [self addBackBtn:NSLocalizedString(@"Select_Device", nil)];
    
    [self.tableView registerClass:[selectCell class] forCellReuseIdentifier:@"reuse"];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (cell == nil) {
        cell = [[selectCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"reuse"];
    }
    
    cell.delegate = self;
    DeviceModel *dev = self.dataList[indexPath.row];
    
    [cell setImage:[[fileOperation sharedOperation] getImageNameWithDevice_type:dev.dev_type device_mode:dev.mode][@"device"]];
    [cell setText:dev.name];
    [cell setSeleted:dev.isFavorate];
    
    return cell;
}
#pragma mark - delegate
-(void)haveSeletedCell:(selectCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    DeviceModel *dev = self.dataList[index.row];
    if ([cell getSeleted]) {
        cell.seleted = NO;
        dev.isFavorate = NO;
    }else
    {
        cell.seleted = YES;
        dev.isFavorate = YES;
    }
}
-(void)actionDone
{
    for (DeviceModel *dev in self.dataList) {
        if (dev.isFavorate) {
            [_selectedDevices addObject:dev];
        }
    
    [_delegate haveSelectedDevices:_selectedDevices];
}
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end