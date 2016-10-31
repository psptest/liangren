//
//  AddNewRoomViewController.m
//  security2.0
//
//  Created by Sen5 on 16/3/30.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "AddNewRoomViewController.h"
#import "sellectDeviceForRoomController.h"
#import "UIViewController+MBProgressHUD.h"
#import "fileOperation.h"
#import "prefrenceHeader.h"

#import "DeviceModel.h"
#import "roomsModel.h"
#import "HouseModelHandle.h"
#import "AddData.h"
@interface AddNewRoomViewController ()<sellectDeviceForRoomDelegate,UITextFieldDelegate>
@end
@implementation AddNewRoomViewController
{
    roomsModel *_room;
    NSArray *_devices;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.mod == nil) {
        [self addBackBtn:NSLocalizedString(@"Add_New_Room", nil)];
    }else
    {
        [self addBackBtn:[self.mod room_name]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomListUpdated:) name:kNotification_roomListUpdated object:nil];
    
}
- (instancetype)initWithModel:(id)model
{
    self = [super initWithModel:model];
    if (self) {
        self.kType = kRoom ;
        _devices = nil;
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //父类方法
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
   
    if (self.mod != nil) {
        
     [self.changeCell setIcan:[self.mod room_image]];
    }else
    {
        [self.changeCell setIcan:[UIImage imageNamed:@"ic_default_rooms_"]];
    }
    
    if (indexPath.row == 1) {
        
        if (_devices == nil) {
            _devices = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getAssignedDevicesWithModel:self.mod]] ;
            
        }else{
            _devices = [NSMutableArray arrayWithArray:_devices];
        }
        
        NSMutableString *mutStr = [[NSMutableString alloc] init];
        
        for (DeviceModel *device in _devices) {
            [mutStr appendString:device.name];
            [mutStr appendString:@" "];
        }
        cell.detailTextLabel.text = mutStr;
        cell.detailTextLabel.textColor = kMainGreenColor;
        
    }
    return cell;
}
#pragma mark - 点击事件
-(void )addBtnClick:(UIButton *)btn
{
    NSInteger index = btn.tag - 100;
    
    if (index == 1) {
        
        sellectDeviceForRoomController *select = [[sellectDeviceForRoomController alloc] initWithRoomModel:self.mod];
        select.delegate = self;
        [self.navigationController pushViewController:select animated:YES];
    }
}
#pragma mark -
-(void)setStatusAndAttributes
{
    if (self.mod != nil) {
    self.text.text = [self.mod room_name];
    }
}

#pragma mark - seleectedDevieForRoomDelegate
-(void)haveSelectedDevices:(NSArray *)devices
{
    _devices = devices;
    
    [self.tableView reloadData];
}
#pragma mark - click event
-(void)removeRoom
{
    if ([[P2Phandle shareP2PHandle] linkState] == P2PLinkConnnected) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Room_Deleted", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sure", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self.hubView show:YES];
        [self.hubView hide:YES afterDelay:HubViewDelayTime];
        [[P2Phandle shareP2PHandle] deleteRoomWithRoomID:[self.mod room_id]];
        
    }];
    
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Not_Sure", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:act1];
    [alert addAction:act2];
    
    [self presentViewController:alert animated:YES completion:nil];
    }else
    {
        [self showWithTime:hubAnimationTime title:kConnectedFailed];
    }
}
#pragma mark - the super class method
-(void)acthionHaveDone
{
    if ([[P2Phandle shareP2PHandle] linkState]== P2PLinkConnnected) {
        [self.hubView show:YES];
        [self.hubView hide:YES afterDelay:HubViewDelayTime];
        
    //发送编辑房间的命令
    NSMutableArray *mut = [NSMutableArray array];
    
    for (DeviceModel *mod in _devices) {
        NSInteger dev_id = mod.dev_id;
        
        [mut addObject:@(dev_id)];
    }
    if (self.mod != nil) {
        
        [[P2Phandle shareP2PHandle] editRoomWithRoodID:[self.mod room_id] name:self.text.text deviceList:[mut copy]];
    }else
    {   //发送添加房间的命令
        [[P2Phandle shareP2PHandle] addNewRoomWithName:self.text.text dev_list:[mut copy]];
    }

    }else
    {
        [self showWithTime:hubAnimationTime title:kConnectedFailed];
    }
}

-(void )changeIcon:(UIImage *)image
{
    NSString *address = [HouseModelHandle shareHouseHandle].currentHouse.address;
    
    NSString *key = [NSString stringWithFormat:@"%@room_id%ld.png",address,[self.mod room_id]];
    
    if (image != nil) {
        
        [self.changeCell setIcan:image];
   
        NSData *Img_data = UIImagePNGRepresentation(image);
    
      BOOL ret = [Img_data writeToFile:[[fileOperation sharedOperation] getHomePath:key] atomically:YES];
        if (ret) {
            MYLog(@"存储成功");
        }

    }else{
        
        [self.changeCell setIcan:[UIImage imageNamed:@"ic_default_rooms_"]];
        
        //删除对应位置文件
         [[NSFileManager defaultManager] removeItemAtPath:[[fileOperation sharedOperation] getHomePath:key] error:nil];
    }
    
    // 发送通知 objcet scene_id //
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_roomImageSetted object:@{@"room_id":@([self.mod room_id])}];
    
}

#pragma mark - notificatiron
-(void )roomListUpdated:(NSNotification *)notice
{
    NSDictionary *dic = notice.object;
    
    [self.hubView hide:YES];
    
#warning  这个地方有问题
#if 0
    if ([dic[@"msg_type"] isEqualToNumber:@(203)]) {
        // 删除对应图片
         [self deletePictures];
         [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Room_Deleted_Suc", nil)];
        
    }else if ([dic[@"msg_type"] isEqualToNumber:@(202)]||[dic[@"msg_type"] isEqualToNumber:@(204)])
    {
        [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Room_Edited_Suc", nil)];
    }
#endif
    
    [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Room_Edited_Suc", nil)];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hubAnimationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(void )deletePictures
{
    NSString *address = [HouseModelHandle shareHouseHandle].currentHouse.address;
    NSString *key = [NSString stringWithFormat:@"%@room_id%ld.png",address,[self.mod room_id]];
    
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),key];
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end