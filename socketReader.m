//
//  socketReader.m
//  security2.0
//
//  Created by Sen5 on 16/6/23.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "socketReader.h"
#import "prefrenceHeader.h"
#import "fileOperation.h"
#import "DeviceModel.h"
#import "NSNotificationCenter+RONotificationCeter.h"
static socketReader *_sharedReader;
@interface socketReader()
{
    BOOL _enterBackground;
}
@end
@implementation socketReader
+ (socketReader *)sharedReader
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedReader = [[super alloc]init];
    });
    
    return _sharedReader;
}

+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedReader = [super allocWithZone:zone];
    });
    
    return _sharedReader;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addNotifications];
    }
    return self;
}

#pragma mark - 通知管理
-(void )addNotifications
{
    //添加socketDidReadDataNotification的检测者
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(socketDidReadDataNotification:)
                                                 name:SocketDidReadDataNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForegound) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)socketDidReadDataNotification:(NSNotification *)notice
{
    
    NSDictionary * dic = notice.object;
    
    MYLog(@"the reseive data is %@ ",dic);
    
    if (!_enterBackground) {
        
        //--------------------------设备信息
        
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([dic[@"msg_type"]  isEqualToNumber: @(101)]) {
                //获取设备列表
                int ret = [dic writeToFile:[[fileOperation sharedOperation] getHomePath:kDeviceInfo] atomically:YES];
                
                if (ret) {
                    
                    [[NSNotificationCenter defaultCenter ] postNotificationName:kNotification_deviceListUpdated object:nil userInfo:nil AtMainQueue:YES];
                }
                
            } else if ([dic[@"msg_type"]  isEqualToNumber: @(107)]){
                
                int ret = [[fileOperation sharedOperation] setDeviceStatusWithList:dic];
                if (ret) {
                    
                    //状态列表
                    [[NSNotificationCenter defaultCenter] postNotificationName:knotification_statusList object:dic userInfo:nil AtMainQueue:YES];
                }
            }
            
            
        });
        
     
    //开线程 处理接收的数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
  
        
     if ([dic[@"msg_type"]  isEqualToNumber: @(102)]){
        //编辑设备
        int ret = [[fileOperation sharedOperation] editeDevice:dic];
        if (ret) {
            
        [[NSNotificationCenter defaultCenter ] postNotificationName:kNotification_deviceEditted object:nil userInfo:nil AtMainQueue:YES];
        }
        
    }else if ([dic[@"msg_type"]  isEqualToNumber: @(103)]){
        
        //新增设备 直接发送新增设备的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_newDevieAdded object:dic userInfo:nil AtMainQueue:YES];
        
    } else if ([dic[@"msg_type"]  isEqualToNumber: @(104)]){
        
        //删除设备
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_deviceDeleted object:dic userInfo:nil AtMainQueue:YES];
    }
    else if ([dic[@"msg_type"]  isEqualToNumber: @(105)]){
        //控制设备 该响应只是表示盒子端已经收到控制设备请求，不表示设备状态已经改变
      //  [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_controlDevice object:dic];
    }
    else if ([dic[@"msg_type"]  isEqualToNumber: @(106)]){
        //状态改变 控制设备后  可控设备的状态也是从此而来
       int ret = [[fileOperation sharedOperation] controlDevice:dic];
        if (ret) {
       
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_controlDevice object:dic userInfo:nil AtMainQueue:YES];
        }
    }
        
    
   
                //--------------------房间信息
   
   else if ([dic[@"msg_type"] isEqualToNumber:@(201)]||[dic[@"msg_type"] isEqualToNumber:@(202)]||[dic[@"msg_type"] isEqualToNumber:@(203)]||[dic[@"msg_type"] isEqualToNumber:@(204)]){
         //获取房间列表 新增房间 删除房间 编辑房间 返回的都是房间列表
         int ret = [dic writeToFile:[[fileOperation sharedOperation] getHomePath:kRoomInfo] atomically:YES];
         
         [[fileOperation sharedOperation] addDevice_Room_id:dic];
       
       if (ret) {
           
         [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_roomListUpdated object:dic userInfo:nil AtMainQueue:YES];
       }
    
    }
        
        
        
                //---------------------场景信息
        
   else if ([dic[@"msg_type"] isEqualToNumber:@(301)]){
    //场景列表
       int ret = [dic writeToFile:[[fileOperation sharedOperation] getHomePath:kSceneInfo] atomically:YES];
       
        if (ret) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sceneListUpdated object:dic userInfo:nil AtMainQueue:YES] ;
        }
    } else if([dic[@"msg_type"] isEqualToNumber:@(302)]){
        //新增场景
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_newSceneAdded object:dic userInfo:nil AtMainQueue:YES];
        
    }else if ([dic[@"msg_type"] isEqualToNumber:@(303)]){
        //删除场景
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sceneDeleted object:dic userInfo:nil AtMainQueue:YES];
    }else if ([dic[@"msg_type"] isEqualToNumber:@(304)]){
        //编辑场景
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sceneEdited object:dic userInfo:nil AtMainQueue:YES];
    }else if ([dic[@"msg_type"] isEqualToNumber:@(305)]){
        //触发场景
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sceneTrigger object:dic userInfo:nil AtMainQueue:YES];
    }
        
        
                //----------------------模式信息
        
    else if ([dic[@"msg_type"] isEqualToNumber:@(401)]){
  
       int ret = [dic writeToFile:[[fileOperation sharedOperation] getHomePath:kSecurityInfo] atomically:YES];
        if (ret) {
            
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_modeListUpdated object:dic userInfo:nil AtMainQueue:YES];
        }
        
    } else if ([dic[@"msg_type"] isEqualToNumber:@(402)]){
        //编辑模式
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_modeEditted object:dic userInfo:nil AtMainQueue:YES];
    } else if ([dic[@"msg_type"] isEqualToNumber:@(403)]){
        //模式触发
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_modeTrigger object:dic userInfo:nil AtMainQueue:YES];
    }
        
        
                //----------------------常用设备信息
        
    else if ([dic[@"msg_type"] isEqualToNumber:@(501)]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_favorateSetted object:dic userInfo:nil AtMainQueue:YES];
    }
    
    else if ([dic[@"msg_type"] isEqualToNumber:@(502)]) {
        
        int ret = [dic writeToFile:[[fileOperation sharedOperation] getHomePath:kFavorate_Device] atomically:YES];
        
        if (ret) {
            
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_FavorateDeviceListUpdated object:dic userInfo:nil AtMainQueue:YES] ;
        }
    }
        
        
        
                //-----------------------用户信息
        
    else if ([dic[@"msg_type"] isEqualToNumber:@(606)]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PERMISSION object:dic userInfo:nil AtMainQueue:YES];
    }
    else if ([dic[@"msg_type"] isEqualToNumber:@(602)]) {
        
        [dic writeToFile:[[fileOperation sharedOperation] getHomePath:MEMBERINFO] atomically:YES];
    }
        
    });
    
    }
}

#pragma mark - 生命周期
-(void )applicationEnterBackground
{
    _enterBackground = YES;
}

-(void )applicationEnterForegound
{
    _enterBackground = NO;
}

-(void )pushLocalNotificationWithContents:(NSString *)contents
{
    // 初始化本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置通知的提醒时间
        NSDate *currentDate   = [NSDate date];
        notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
        notification.fireDate = [currentDate dateByAddingTimeInterval:1.0];
        
        // 设置重复间隔
      //  notification.repeatInterval = kCFCalendarUnitDay;
        
        // 设置提醒的文字内容
        notification.alertBody   = contents;
        
       // notification.alertAction = NSLocalizedString(@"起床了", nil);
        
        // 通知提示音 使用默认的
        notification.soundName= UILocalNotificationDefaultSoundName;
        
        // 设置应用程序右上角的提醒个数
      //  notification.applicationIconBadgeNumber++;
        
        // 设定通知的userInfo，用来标识该通知
        NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
      //  aUserInfo[kLocalNotificationID] = @"LocalNotificationID";
        notification.userInfo = aUserInfo;
        
        // 将通知添加到系统中
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

//注销观察者
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end