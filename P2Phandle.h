//  P2Phandle.h
//  security
//
//  Created by sen5labs on 15/11/25.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TimeoutHandle)();

typedef NS_ENUM(NSUInteger, P2PLinkState) {
    P2PLinkUnConnnected,        // 连接错误
    P2PLinkConnnected,          // 连接成功
    P2PLinkConnecting,          // 连接中
};

typedef NS_ENUM(NSUInteger, VideoResolutionType) {
    VideoResolution640x480 = 0x00,      // 640 x 480
    VideoResolution352x288 = 0x01,      // 352 x 288
};


typedef NS_ENUM(NSUInteger, CameraType) {
    CameraType0 = 0x00,      // 摄像头1
    CameraType1 = 0x01,      // 摄像头2
};

extern NSString * const SocketDidReadDataNotification;  /// 接收数据 通知
extern NSString * const KNotificationP2PWillConnect;    /// 将要连接
extern NSString * const KNotificationP2PDidConnected;   /// 已经连接
extern NSString * const KNotificationP2PDidDisConnected;/// 连接断开


//客户端请求命令
extern NSString * const getActionData;                  /// 请求action数据
extern NSString * const getCameraData;                  /// 请求Camera数据
extern NSString * const getHouseSecState;               /// 请求 房屋安全状态  0表示撤防状态，1表示一级防区布防，2表示二级防区(在家模式)
extern NSString * const getActionStatusData;            /// 请求 设备状态

extern NSString * const resultgetActionData;            /// 返回json数据中的key值
extern NSString * const resultgetCameraData;            /// 返回json数据中的key值
extern NSString * const resultgetHouseSecState;         /// 返回json数据中的key值
extern NSString * const resultgetActionStatusData;      /// 返回设备状态,value为xml数据

extern NSString * const switchHouseSecState;            /// 发送 房屋安全状态 key值 0，1，2
extern NSString * const resultswitchHouseSecState;      /// 设置是否成功 0 ＝ NO，1 ＝ YES；

extern NSString * const switchCamera;                   /// 选择摄像头
extern NSString * const resultswitchCamera;             /// 返回设置是否成功

extern NSString * const switchPower;                    /// 开关命令
extern NSString * const resultswitchPower;              /// 开关成功或失败  //
extern NSString * const resultswitchPowerID;            /// 返回设备id
extern NSString * const resultswitchPowerStatus;        /// 返回设备状态

extern NSString * const checkUserID;                     /// 检测deviceID
extern NSString * const resultCheckUserID;               /// 检测deviceID返回结果

@interface P2Phandle : NSObject
/** 超时操作 */
//@property (nonatomic,copy) TimeoutHandle timeoutHandle;

/** 连接状态 */
@property (nonatomic, assign,readonly) P2PLinkState linkState;

/** 视频格式 */
@property (nonatomic, assign,readonly) VideoResolutionType videoresolutionType;

/** checkUserId fail 主动断开连接*/
@property (nonatomic, assign) BOOL initivalDisConnect;

@property (nonatomic, assign) CameraType camera;
+ (instancetype)shareP2PHandle;

/**
 *  连接服务器 会卡线程 最好异步执行 这里我将read数据的操作 集成在这一方法里面了 是一个无限循环子线程
 *
 *  @param timeout   超时时间
 *  @param nsDID     一段字符串 识别作用
 *  @param nsCamName 名字 没什么作用
 *
 *  @return >=0 表示成功  <0 表示失败
 */
- (int)connectWithTimeout:(NSTimeInterval)timeout nsDID:(NSString *)nsDID nsCamName:(NSString *)nsCamName;

/**
 *  断开连接 卡主线程 异步执行
 */
- (void)disConnect;

/**
 *  因为check userid fail 主动断开连接
 */
- (void) disConnectForCheckUserIdFail;

/**
 *  向服务器发数据 具体看协议
 *
 *  @param options 为一个字典
 *
 *  @return >=0 表示成功  <0 表示失败
 */
- (int)writeWithOptions:(NSDictionary *)options;

/**
 *  启动视频
 *
 *  @return >=0 表示成功  <0 表示失败
 */
- (int)startVideo;

/**
 *  关闭视频
 */
- (void)stopVideo;

/**
 *  选择分辨率
 *
 *  @param videoResolutionType 何种分辨率
 *
 *  @return >=0 表示成功  <0 表示失败
 */
- (int)setResolutionWithVideoResolution:(VideoResolutionType)videoResolutionType;

/**
 *  切换摄像头
 *
 *  @param camera 摄像头id
 *
 *  @return >=0 表示成功  <0 表示失败
 */
- (int) SwitchCamera:(CameraType) camera;



//获取设备列表
-(int)getDeviceList;

//编辑设备
-(int)editDeviceWithDeviceID:(NSInteger)dev_id name:(NSString *)dev_name roomID:(NSInteger)room_id tableID:(NSInteger )table_id;

//删除设备
-(int)deleteDevicewithDeviceID:(NSInteger)dev_id tableID:(NSInteger)table_id;

//添加设备
-(int)addNewDevice;
//控制设备action = 0 为关 action为1 为开
-(int)ControlDeviceWithDeviceID:(NSInteger)dev_id tableID:(NSInteger)table_id action:(NSInteger )action;

//获取设备状态 及 状态列表
-(int )getDeviceStatus:(NSInteger )dev_id;
-(int )getDeviceStatusList;

//设置常用设备 及 获取常用设备
-(int )setFavorateDevicesWithUUID:(NSString *)UUID dev_list:(NSArray *)dev_list;
-(int )getFavorateDevicesWithUUID:(NSString *)UUID;


//获取房间列表
-(int)getRoomList;
//新增房间
-(int)addNewRoomWithName:(NSString *)name dev_list:(NSArray<NSDictionary *>*)dev_list;
//删除房间
-(int )deleteRoomWithRoomID:(NSInteger )room_id;
//编辑房间
-(int)editRoomWithRoodID:(NSInteger)room_id name:(NSString *)room_name deviceList:(NSArray <NSDictionary *> *)dev_list;


//获取场景列表
-(int)getSceneList;

//新增场景action_list:[{table_id:111,dev_id:111,action_id:0,action_params:"MQ=="}，......]
-(int )addNewSceneWithSceneName:(NSString *)sceneName mode:(NSInteger)mode actionList:(NSArray<NSDictionary *> *)actionList;

//删除场景
-(int )deleSceneWithSceneID:(NSInteger)scene_id;

//编辑场景
-(int )editSceneWithWithSceneID:(NSInteger )scene_id sceneName:(NSString *)scene_name sceneMode:(NSInteger )scene_mode action_list:(NSArray <NSDictionary *> *)action_list;
//触发场景
-(int )triggerSceneWithID:(NSInteger )scene_id;


//模式列表
-(int )getModeList;

//编辑模式
-(int )editModeWithSec_mode:(NSInteger )sec_mode no_motion:(NSInteger )no_motion dev_list:(NSArray *)dev_list;
//设置当前模式
-(int )setCurrentMode:(NSInteger )cur_sec_mode;




//身份验证
-(int )authenticate;

//用户列表
-(int )memberList;




@end