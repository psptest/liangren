//
//  initDeviceController.m
//  security2.0
//
//  Created by Sen5 on 16/5/4.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "initDeviceController.h"
#import "UIViewController+MBProgressHUD.h"
#import "prefrenceHeader.h"
#import "DeviceModel.h"
#import "roomsModel.h"
#import "fileOperation.h"
#import "P2Phandle.h"

#import "selectRoomForDeviceViewController.h"
#import "MBProgressHUD.h"

const CGFloat kHeaderViewHeight  = 30;
const CGFloat kselfTipsHeight = 30.0f;
const CGFloat kLeftDistance = 15;

@interface initDeviceController ()<selecteRoomForDeviceDelegate,UITextFieldDelegate>
@end

@implementation initDeviceController
{
    DeviceModel *_mod;
    NSArray *_selectedRooms;
    NSInteger _room_id;
}

-(instancetype )initWithModel:(id)model
{
    self = [super initWithModel:model];
    if (self) {
        self.kType = kDevice ;
        _room_id = [(DeviceModel *)model room_id];
    }
    
    return self;
}
-(void )viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = [self tableHeaderViewwithTitle:nil backgroudColor:kLightBackgroudColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceEdited:) name:kNotification_deviceEditted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDeleted:) name:kNotification_deviceDeleted object:nil];
    
    [self addBackBtn:NSLocalizedString(@"Edit_Device", nil)];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIView *)tableHeaderViewwithTitle:(NSString *)title backgroudColor:(UIColor *)backgroudColor;
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSelfViewWidth, kHeaderViewHeight)];
    
    UILabel *device_type = [[UILabel alloc] initWithFrame:CGRectMake(kLeftDistance, 0, kSelfViewWidth*2/3.0f, kselfTipsHeight)];
    
    device_type.textAlignment = NSTextAlignmentLeft;
    device_type.textColor  = kDarkBackgroudColor;
    
    device_type.font = [UIFont systemFontOfSize:14];
    device_type.text = [[fileOperation sharedOperation] getDeviceNameWithDevice_type:[self.mod dev_type]];
    
    UILabel *device_status = [[UILabel alloc] initWithFrame:CGRectMake(kSelfViewWidth*2/3.0f, 0, kSelfViewWidth/3.0f, kselfTipsHeight)];
    device_status.textAlignment = NSTextAlignmentCenter;
    device_status.textColor = [UIColor lightGrayColor];
    device_status.font = [UIFont systemFontOfSize:12];
    
    UIView *bottom_line = [[UIView alloc] initWithFrame:CGRectMake(kLeftDistance, kselfTipsHeight-1, kSelfViewWidth-kLeftDistance, 1)];
    bottom_line.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1.0];
    
    [view addSubview:bottom_line];
    
    NSString *params = [[self.mod status][0][@"params"] substringToIndex:2];
    NSInteger count = [[self.mod status][0][@"params"] length];
    

    if (count == 4) {
        if ([params isEqualToString:@"AQ"]) {
            device_status.text = NSLocalizedString(@"Open", nil);
        }else if ([params isEqualToString:@"AA"])
        {
            device_status.text = NSLocalizedString(@"Closed", nil);
        }else
        {
             device_status.text = NSLocalizedString(@"Nowork", nil);
        }
    }else if (count == 8)
    {
        if ([params isEqualToString:@"AQ"])
        {
            device_status.text = NSLocalizedString(@"Danger", nil);
        }else if ([params isEqualToString:@"AA"])
        {
            device_status.text = NSLocalizedString(@"Safety", nil);
        }else
        {
            device_status.text = NSLocalizedString(@"Nowork", nil);
        }
    }else
    {
        device_status.text = @"Unknown";
    }

    [view addSubview:device_type];
    [view addSubview:device_status];
    
    return view;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //父类方法
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    [self.changeCell setIcan:[UIImage imageNamed:@"ic_default_scene_nor"]];
    
    if (indexPath.row == 1) {
        
            if (_room_id != 0) {
                roomsModel *room = [[roomsModel alloc] initWithDictionary:[[fileOperation sharedOperation] dictionWithRoom_id:_room_id]];
                
                cell.detailTextLabel.text = room.room_name;
                cell.detailTextLabel.textColor = kMainGreenColor;
                
            }else
            {
                cell.detailTextLabel.text = @"";
            }
        
    }else if (indexPath.row == 0){
        [self setStatusAndAttributes];
    }
    
    return cell;
}
-(void )addBtnClick:(UIButton *)btn
{
    self.navigationController.hidesBottomBarWhenPushed = YES;
     
    selectRoomForDeviceViewController *select = [[selectRoomForDeviceViewController alloc] initWithDeviceModel:self.mod];
   
    select.delegate = self;
    
    [self.navigationController pushViewController:select animated:YES];
}
-(void)setStatusAndAttributes
{

    self.text.text = [self.mod name];
}
#pragma mark - selectRoomForDevicedelegate
-(void)haveSelectedRooms:(NSArray *)rooms
{
    if (rooms.count != 0) {
        
        _room_id = [(roomsModel *)rooms[0] room_id];
    }else
    {
        _room_id = 0;
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)acthionHaveDone
{
    if ([[P2Phandle shareP2PHandle] linkState] == P2PLinkConnnected) {
        
        [[P2Phandle shareP2PHandle] editDeviceWithDeviceID:[self.mod dev_id] name:self.text.text roomID:_room_id tableID:1];
        [self.hubView show:YES];
        [self.hubView hide:YES afterDelay:HubViewDelayTime];
#if 0
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HubViewDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showWithTime:hubAnimationTime title:@"Device Editted Unsuccessfully"];
        });
#endif
    }else
    {
        [self showWithTime:hubAnimationTime title:kConnectedFailed];
    }
    
}

#pragma mark - notification
-(void )deviceEdited:(NSNotification *)notice
{
    [self.hubView hide:YES];
    [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Device_Edited_Suc", nil)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hubAnimationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_delegate haveChangedOk];
        [self.navigationController popViewControllerAnimated:YES];
    });
  
}

-(void )deviceDeleted:(NSNotification *)notice
{
    [self.hubView hide:YES];
    [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Device_Delet_Suc", nil)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hubAnimationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_delegate haveChangedOk];
        [self.navigationController popViewControllerAnimated:YES];
    });
}
@end