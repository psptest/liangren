//
//  deviceForRoomViewController.m
//  security2.0
//
//  Created by Sen5 on 16/6/22.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "deviceForRoomViewController.h"
#import "UIViewController+BackBtn.h"
#import "deviceViewController.h"
#import "fileOperation.h"
#import "roomsModel.h"
#import "DeviceModel.h"
#import "myButtonItem.h"
#import "AddNewRoomViewController.h"

@interface deviceForRoomViewController ()

@end

@implementation deviceForRoomViewController
{
    deviceViewController *_device;
    roomsModel *_room;
}

- (instancetype)initWithRoomModel:(roomsModel *)room
{
    self = [super init];
    if (self) {
        
        NSArray<DeviceModel *> *devices = [[fileOperation  sharedOperation] getAssignedDevicesWithModel:room];
        
        _device = [[deviceViewController alloc] initWithDevices:devices isSetting:YES];
        
        [self addChildViewController:_device];
        _room = room;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBtn:NSLocalizedString(@"Back", nil)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_device.view];
    
    self.navigationItem.rightBarButtonItem = [myButtonItem addPushBtnWith:[UIImage imageNamed:@"btn_more_nor"] highLightedImage:[UIImage imageNamed:@"btn_more_pressed"] selectedImage:nil frame:CGRectMake(0, 0, 20, 20) buttonClickBlock:^{
        
        AddNewRoomViewController *add = [[AddNewRoomViewController alloc]  init];
        
        [self.navigationController pushViewController:add animated:NO];
    }];
    
    [self addBackBtn:_room.room_name];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end