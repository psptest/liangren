//
//  selectRoomForDeviceViewController.m
//  security2.0
//
//  Created by Sen5 on 16/6/1.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "selectRoomForDeviceViewController.h"
#import "HouseModelHandle.h"
#import "HouseModel.h"
#import "fileOperation.h"
#import "simulatorOperation.h"
#import "roomsModel.h"
#import "DeviceModel.h"
#import "selectCell.h"
@interface selectRoomForDeviceViewController ()<selectCellDelegate>
@end
@implementation selectRoomForDeviceViewController
{
    NSMutableArray *_selectedRooms;
    DeviceModel *_device;
    selectCell *_selectedCell;
}
-(id)initWithDeviceModel:(DeviceModel *)mod
{
    self = [super init];
    if (self) {
        
        _device = mod;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[selectCell class] forCellReuseIdentifier:@"reuse"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(actionHaveDone)];
    [self addBackBtn:NSLocalizedString(@"Select_Room", nil)];
}
-(void)createModels
{
    _selectedRooms = [[NSMutableArray alloc] init];

    self.dataList = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getRooms]];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (cell == nil) {
        cell = [[selectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    cell.delegate = self;
    [cell setImageWithData:[self.dataList[indexPath.row] room_image]];
    [cell setText:[self.dataList[indexPath.row] room_name]];
    [cell setSeleted:NO];
    
    roomsModel *room = self.dataList[indexPath.row];
    
    if (room.room_id == _device.room_id) {
        [cell setSeleted: YES];
    }
    
    if ([cell getSeleted]) {
        _selectedCell = cell;
        [_selectedRooms removeAllObjects];
        [_selectedRooms addObject:room];
    }
    return cell;
}
#pragma mark - selectCellDelegate
-(void)haveSeletedCell:(selectCell *)cell
{
    if (cell != _selectedCell) {
        
    [_selectedCell setSeleted:NO];
    [cell setSeleted:YES];
    _selectedCell = cell;

    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    roomsModel *room = self.dataList[index.row];
    [_selectedRooms removeAllObjects];
    [_selectedRooms addObject:room];
    
    }else
    {
        [_selectedCell setSeleted:![_selectedCell getSeleted]];
        if ([_selectedCell getSeleted]) {
            
            NSIndexPath *index = [self.tableView indexPathForCell:cell];
            roomsModel *room = self.dataList[index.row];
           // [_selectedRooms removeAllObjects];
            [_selectedRooms addObject:room];
        }else
        {
            [_selectedRooms removeAllObjects];
        }
    }
}
-(void)actionHaveDone
{
    [self.tableView reloadData];
    //将selectionRoom传给initDeviceController
    [_delegate haveSelectedRooms:_selectedRooms];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
