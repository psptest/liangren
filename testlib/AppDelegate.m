//
//  AppDelegate.m
//  security2.0
//
//  Created by Sen5 on 16/3/24.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "ROTabViewController.h"
#import "BGTask.h"
#import "BGLogation.h"

//p2p
#import "HouseModelHandle.h"
#import "PasswordHandle.h"
#import "CamObj.h"
#import "socketReader.h"
//catogory
#import "UIView+MBProgressHUD.h"
//#import "prefrenceHeader.h"
//#import "P2Phandle.h"
#import "SvUDIDTools.h"

#import "HSLSDK/inc/IPCClientNetLib.h"
#import "HSLSDK/inc/StreamPlayLib.h"

#define kGtAppId @"W1OMWSCvNY9rYVRUQ78nW4"
#define kGtAppKey @"cTSSvUbEwq5PhX3oVI7w29"
#define kGtAppSecret @"cTSSvUbEwq5PhX3oVI7w29"

@interface AppDelegate ()<CLLocationManagerDelegate>
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;
@property (strong , nonatomic) BGTask *task;
@property (strong , nonatomic) NSTimer *bgTimer;
@property (strong , nonatomic) BGLogation *bgLocation;
@property (strong , nonatomic) CLLocationManager *location;
@property(nonatomic,assign)BOOL isBackground;

@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 防止锁屏
    [UIApplication sharedApplication].idleTimerDisabled=YES;
  
    
    ROTabViewController *rootTab = [[ROTabViewController alloc] init];
    self.window.rootViewController = rootTab;

    //连接房子
    [self connectP2P];
    
    // 实例化视频播放实例
    device_net_work_init("");
    x_player_initPlayLib();
    
    //实例化消息监听器
    [socketReader sharedReader];
    
#if 0
    //暂时不用
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    // 本地通知
    [application setApplicationIconBadgeNumber:0];
    
#endif
    
#if 0
    // 暂时不用
    _task = [BGTask shareBGTask];
    UIAlertView *alert;
    

    //判断定位权限
    if([UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusDenied)
    {
        alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"应用没有不可以定位，需要在在设置/通用/后台应用刷新开启" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusRestricted)
    {
        alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不可以定位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        self.bgLocation = [[BGLogation alloc]init];
        [self.bgLocation startLocation];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(log) userInfo:nil repeats:YES];
    }
#endif
 
    
    return YES;
}



#pragma mark - p2p连接
- (void)connectP2P {
    
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            HouseModel *model = [HouseModelHandle shareHouseHandle].currentHouse;
            if (model) {
                if (model.address && ![model.address isEqualToString:@""]) {
                    [CamObj deinitAPI];
                    [CamObj initAPI];
                    int nRet = 0;
                    
#if TARGET_IPHONE_SIMULATOR//模拟器
                    
                    nRet = [[P2Phandle shareP2PHandle] connectWithTimeout:10 nsDID:@"SLIFE000003BUMUN" nsCamName:@"what"];
#elif TARGET_OS_IPHONE//真机
                    
                    nRet = [[P2Phandle shareP2PHandle] connectWithTimeout:10 nsDID:model.address nsCamName:model.name];
#endif
                    if (nRet == -1) {
                        
                        MYLog(@"链接错误 %d",nRet);
                      
                        
                    } else if (nRet < 0) {
                        
                        MYLog(@"连接错误 %d",nRet);
                        
                    }else {
                        
                    }
                }
            }
    });
    
}

-(void )check
{
    if ([[P2Phandle shareP2PHandle] linkState] == P2PLinkUnConnnected) {
        HouseModel *model = [HouseModelHandle shareHouseHandle].currentHouse;
        [[P2Phandle shareP2PHandle] connectWithTimeout:10 nsDID:model.address nsCamName:model.name];
    }
}

#pragma mark - 生命周期
- (void)applicationWillResignActive:(UIApplication *)application {
  
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {

    
    [self beingBackgroundUpdateTask];
    
    _isBackground = YES;
    
    
}
- (void)beingBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
      //  [self endBackgroundUpdateTask];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(check) userInfo:nil repeats:YES];

    }];
}

- (void)endBackgroundUpdateTask
{
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
     self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}
-(void )log
{
    //不执行任何任务
    //  MYLog(@"right");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self endBackgroundUpdateTask];
    
    _isBackground = NO;
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [CamObj initAPI];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end