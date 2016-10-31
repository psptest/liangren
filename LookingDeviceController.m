//
//  LookingDeviceController.m
//  security2.0
//
//  Created by Sen5 on 16/5/3.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "LookingDeviceController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIViewController+MBProgressHUD.h"
#import "initDeviceController.h"
#import "prefrenceHeader.h"
#import "fileOperation.h"
#import "simulatorOperation.h"
#import "DeviceModel.h"

const  CGFloat kLookingLabelHeight = 30.0;
const CGFloat kTipsLabelHeight = 50.0f;
const CGFloat kQueryLabelHeight = 30.0f;

@interface LookingDeviceController ()

@end

@implementation LookingDeviceController

{
    UILabel *_lookingLabel;
    //UILabel *_tipsLabel;
   // UILabel *_queryLabel;
    UIImageView *_imgView;
}

#pragma mark - 生命周期
-(void)viewDidLoad
{
    self.view.backgroundColor = kLightBackgroudColor;
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDeviceAdded:) name:kNotification_newDevieAdded object:nil];
  
    [[P2Phandle shareP2PHandle] addNewDevice];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_newDevieAdded object:nil];
}
-(void)setupUI
{
    [self addBackBtn:NSLocalizedString(@"New_Device_Add", nil)];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kSelfViewWidth, kSelfViewWidth)];
    //[UIImage imageNamed:@"add-device-1_"]
    _imgView.animationImages = @[[UIImage imageNamed:@"add-device-1_"],[UIImage imageNamed:@"add-device-2_"],[UIImage imageNamed:@"add-device-3_"],[UIImage imageNamed:@"add-device-4_"]];
   
    _imgView.animationDuration = 2.0f;
    [_imgView startAnimating];
    
    [self.view addSubview:_imgView];
    
    _lookingLabel = [[UILabel  alloc] initWithFrame:CGRectMake(0, kSelfViewHeight*2/3.0f, kSelfViewWidth, kLookingLabelHeight)];
    _lookingLabel.text = NSLocalizedString(@"Looking for your new device", nil);
    _lookingLabel.textColor = kDarkBackgroudColor;
    
    _lookingLabel.font = [UIFont systemFontOfSize:20];
    _lookingLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:_lookingLabel];
    
}
#pragma mark - notification
-(void)newDeviceAdded:(NSNotification *)notice
{
    // 播放震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [self showWithTime:2.0 title:NSLocalizedString(@"detaching New Device", nil)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end