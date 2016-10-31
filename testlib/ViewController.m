//
//  ViewController.m
//  testlib
//
//  Created by APPLE on 2/2/15.
//  Copyright (c) 2015年 hsl. All rights reserved.
//
//

#import "ViewController.h"

#import "HSLSDK/inc/IPCClientNetLib.h"
#import "HSLSDK/inc/StreamPlayLib.h"
#import "HSLSearchDevice.h"
#import "cameraModel.h"
#import "memoryOperation.h"
#import "prefrenceHeader.h"
#import "UIViewController+MBProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Masonry.h"
#import "Timer_BeginWatch.h"
#import "timerCounter.h"
#import "DeviceModel.h"
#import "GTMBase64.h"
#import "AppDelegate.h"
#import "ROVedioPlayController.h"
#import "cameraOperation.h"

void STDCALL CallBack_Event(unsigned int nType, void *pUser)
{
    id pThiz = (id)pUser;
    [pThiz ProcessEvent:nType];
}

/*
 * P2P模式回调
 */
void STDCALL CallBack_P2PMode(unsigned int nType, void *pContext)
{
    id pThiz = (id)pContext;
    [pThiz ProcessP2pMode:nType];
}

/*
 * 警报消息回调
 */
void STDCALL CallBack_AlarmMessage(unsigned int nType, void *pContext)
{
    id pThiz = (id)pContext;
   // [pThiz ProcessAlarmMessage:nType];
}

/*
 * 获取参数结果回调函数
 */
void STDCALL CallBack_GetParam(unsigned int nType, const char *pszMessage, unsigned int nLen, void *pUser)
{
    id pThiz = (id)pUser;
    [pThiz ProcessGetParam:nType Data:pszMessage DataLen:nLen];
}

/*
 * 设置参数结果回调函数
 */
void STDCALL CallBack_SetParam(unsigned int nType, unsigned int nResult, void *pUser)
{
    id pThiz = (id)pUser;
    [pThiz ProcessSetParam:nType Result:nResult];
}

// 解码后的YUV420数据
void STDCALL CallBack_YUV420Data(unsigned char *pYUVData, int width, int height, void *pUserData)
{
    
    id pThiz = (id)pUserData;
    [pThiz ProcessYUV420Data:pYUVData Width:width Height:height];
}



@interface ViewController ()<HSLSearchDeviceDelegate>

{
    NSTimer *_timer;
    
    UIActivityIndicatorView *_indicator;
    int userid;
    int playid;

    UILabel *lblMsg;
    int event_type;
    
    NSString *_did;
    Timer_BeginWatch *_timeCounter;
    timerCounter *_timerCounter;
    
    kResolutionType _resolutionType;
    
    UITapGestureRecognizer *_tap;
    
    UIImageView *_backView;
}
@property(nonatomic,strong)UIButton *playBtn;
@property(nonatomic,strong)UIButton *fullBtn;
@property(nonatomic,strong)UIButton *nameBtn;

@end


@implementation ViewController

/*
 * 音视频数据回调
 */
void STDCALL CallBack_AVData(const char *pBuffer, unsigned int nBufSize, void *pUser)
{
    //    NSLog(@"data size:%d", nBufSize);
    ViewController* pThiz = (ViewController *)pUser;
    // 写入解码库解码
    // 如果程序连接x_code 则方法会崩溃到这里。。。
    x_player_inputNetFrame(pThiz->playid, pBuffer, nBufSize);
    
    Frame_Head *head = (Frame_Head*)pBuffer;
    if (head->type == 6) {
        NSLog(@"head.type=%d", head->type);
    }
    
    // record
    //[pThiz ProcessRecord:(void*)pBuffer Size:nBufSize];
}

// 压缩后的音频数据
void STDCALL CallBack_EncodeAudioData(const char *pData, int nSize, void *pUserData)
{
    id pThiz = (id)pUserData;
    [pThiz ProcessEncodeAudioData:pData Len:nSize];
}

- (void)ProcessRecord:(void*)buf Size:(int)size
{
    //int ret = [rec InputFrame:buf size:size];
    //NSLog(@"input frame to buf ret=%d", ret);
}

- (void)ProcessEncodeAudioData:(const char *)pData Len:(int)len
{
    NSLog(@"encode audio data len=%d", len);
    device_net_work_sendTalkData(userid, pData, len);
}


- (void)viewDidAppear:(BOOL)animated
{
    [self createPlayView];
}


- (instancetype)initWithDev_id:(DeviceModel *)camera isFullScreen:(BOOL)isFullScreen
{
    self = [super init];
    if (self) {
        
        _did = [[NSString alloc] initWithData:[GTMBase64 decodeString:camera.status[0][@"params"]] encoding:NSUTF8StringEncoding];
        
        _camera = camera;
        
        _isFullScreen = isFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.isPlaying = NO;
    
    // 默认流畅
    _resolutionType = kResolutionQVGA;
    
    userid = -1;
    playid = -1;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        playid = x_player_createPlayInstance(0, 0);
        
        if (playid < 0) {
            MYLog(@"x_player_createPlayInstance failed.");
            return;
        }
    });
    
    

 //   [self btnConnect];
    // 提供播放view
//    x_player_setPlayWnd(playid, (void*)RenderView);
    
    //rec = [[HSLRecord alloc]init];
    
    //[rec StartRecord:@"abc" Width:1280 Height:720 FrameRate:20];
    
   // SDevice = [[HSLSearchDevice alloc] init];
    
    [self createPlayView];
    
    // 如果不是全屏，则添加全屏按钮和 播放按钮 添加点击事件
    [self addPlayBtn];
}

-(void )createPlayView
{
    // create myglviewController
    if (_m_glView == nil) {
        
        _m_glView = [[MyGLViewController alloc] init];
        //添加子视图控制器
        [self addChildViewController:_m_glView];
        
        [self.view addSubview:_m_glView.view];
        
        if ([[cameraOperation sharedOperationHandle] hasCameraBackgoundImageWithDid:_did]) {
            NSData *data = [[cameraOperation sharedOperationHandle] getCameraBackgoundImageWithDid:_did];
            _backView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
        
    
           [self.view addSubview:_backView];
            
            [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.view);
                make.size.equalTo(self.view);
            }];
            
        }
        [self createIndicator];
    }
    
    _indicator.center = _m_glView.view.center;
    
}
//创建指示器
-(void )createIndicator
{
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    _indicator.frame = CGRectMake(0, 0, 30, 30);
    _indicator.hidesWhenStopped = YES;
    [self.view addSubview:_indicator];
    self.view.autoresizesSubviews = YES;
    
    _indicator.autoresizingMask =   UIViewAutoresizingFlexibleLeftMargin   |
    UIViewAutoresizingFlexibleWidth        |
    UIViewAutoresizingFlexibleRightMargin  |
    UIViewAutoresizingFlexibleTopMargin    |
    UIViewAutoresizingFlexibleHeight      |
    UIViewAutoresizingFlexibleBottomMargin ;
    
}

//创建控制按钮
-(void )createControls
{
    if (_playBtn != nil) {
       // [_playBtn setHidden:NO];
        [_nameBtn setHidden:NO];
        [_fullBtn setHidden:NO];
    }else
    {
        if (!_isFullScreen) {
            
     
    [self.view layoutIfNeeded];
    // create controls
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[_playBtn setImage:[UIImage imageNamed:@"btn_start_nor_"] forState:UIControlStateNormal];
    [_playBtn setImage:[UIImage imageNamed:@"btn_start_nor_"] forState:UIControlStateNormal];
    
  //  [_playBtn setImage:[UIImage imageNamed:@"btn_start_pre_"] forState:UIControlStateHighlighted];
    [_playBtn setImage:[UIImage imageNamed:@"btn_start_pre_"] forState:UIControlStateHighlighted];
    [_playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playBtn];
    
    _fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_fullBtn setImage:[UIImage imageNamed:@"btn_Full-screen_normal_"] forState:UIControlStateNormal];
    [_fullBtn setImage:[UIImage imageNamed:@"btn_Full-screen_pressedl_"] forState:UIControlStateHighlighted];
    [_fullBtn addTarget:self action:@selector(fullBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fullBtn];
    
    _nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nameBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _nameBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_nameBtn setTitle:_camera.name forState:UIControlStateNormal];
    
    [self.view addSubview:_nameBtn];
    
    // set frame
    
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);;
        make.size.mas_equalTo(CGSizeMake(height/10.0, height/10.0));
    }];
    
    [_fullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(@(0));
        make.size.mas_equalTo(CGSizeMake(height/15.0, height/15.0));
    }];
    
    [_nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.fullBtn.mas_left).offset(-5);
        make.bottom.equalTo(self.view.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(height/5.0, height/20.0));
    }];
            
    }
    
    }
}

#pragma mark - 添加计时器
-(void )addRecordingLabel
{
    _timerCounter = [[timerCounter alloc] initWithFrame:CGRectMake(20 , 20, self.view.frame.size.width, 40)];
    [self.view addSubview:_timerCounter];
    
}


- (void)dealloc
{
    // 释放解码实例
    x_player_destroyPlayInstance(playid);
    playid = -1;
    
    [super dealloc];
}

#pragma mark - 點擊事件
-(void )playBtnClick
{
    if (self.wifiReachability.currentReachabilityStatus == NotReachable) {
        
        [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Network_Interruption", nil)];
        
    }else{
        
        // hide the play btn
        [_playBtn setHidden:YES];
    
        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self btnConnect];
    });
    
    }
    
}

-(void )stopBtnClick
{
    [_indicator stopAnimating];
 
    [_playBtn setHidden:NO];
    
    dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self btnStop];
    });
    
    
    
}
-(void )fullBtnClick
{
    if (self.wifiReachability.currentReachabilityStatus == NotReachable) {
        
        [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Network_Interruption", nil)];
        
    }else{
        
        [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
        
        AppDelegate * app = [UIApplication sharedApplication].delegate;
        
        //  [UIDevice setOrientation:UIInterfaceOrientationLandscapeRight];
        
        if (self.isPlaying) {
          
            [self removePlayBtn];
            [self setupUI];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
            
        }else
        {
            ROVedioPlayController *camera = [[ROVedioPlayController alloc ]initWithDev_id:_camera  isFullScreen:YES];
            [app.window addSubview:camera.view];
            app.isFullScreen = YES;
            
        }
        
    }
}

-(void )addGesture
{
    
}

#pragma mark - 界面創建
-(void )setupUI
{
    
}
-(void )removePlayBtn
{
#if 0
    [_playBtn removeFromSuperview];
    [_fullBtn removeFromSuperview];
    [_nameBtn removeFromSuperview];
    [self.view removeGestureRecognizer:_tap];
#endif
   // [_playBtn setHidden:YES];
    [_fullBtn setHidden:YES];
    [_nameBtn setHidden:YES];
    [self.view removeGestureRecognizer:_tap];
}

-(void )addPlayBtn
{
        [self createControls];
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopBtnClick)];
    
        [self.view addGestureRecognizer:tap];
        _tap = tap;
    
}
#pragma mark - camera control
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnConnect
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_indicator startAnimating];
    });
    
    if (userid >= 0) return;
    struct __login_user_info_t info = {0};
    NSLog(@"%@",_did);
    strcpy(info.szDid, [_did UTF8String]);//hsl013801lkvbk
    strcpy(info.szUser, "admin");
    strcpy(info.szPwd, "");
    strcpy(info.szServIp, "");//192.168.1.116
    info.iServPort = 81;
    int nettype = 1;  // 0/1 tcp/p2p
    userid = device_net_work_createInstance(info, nettype);
    
    if (userid >= 0)
    {
        device_net_work_set_event_callback(userid, CallBack_Event, self);
        device_net_work_set_p2pmode_callback(userid, CallBack_P2PMode, self);
        device_net_work_set_alarmMessage_callback(userid, CallBack_AlarmMessage, self);
        device_net_work_param_callback(userid, CallBack_GetParam, CallBack_SetParam, self);
        device_net_work_start(userid);
        
       
    }
  
   // [self LANSearch];
}

- (void)btnStop
{
    if (userid >= 0) {
        device_net_work_destroyInstance(userid);
        userid = -1;
    }
    
     self.isPlaying = NO;
    //[rec StopRecord];
    
}

int sid = 80;
- (void)btnOpenVideo
{
    if (userid >= 0) {
        
        if (playid < 0) {
            MYLog(@"x_player_createPlayInstance failed.");
            return;
        }
        
        // 启动视频解码
        int ret = x_player_startPlay(playid);
        if (ret != AP_ERROR_SUCC) {
            // 释放解码实例
            x_player_destroyPlayInstance(playid);
            playid = -1;
            return;
        }
        // 注册函数接收解码后YUV数据
        x_player_RegisterVideoCallBack(playid, CallBack_YUV420Data, self);
        
        // substream 0/1/2 主/子/次码流
        device_net_work_startStreamV2(userid, sid, _resolutionType, CallBack_AVData, self);

        // 获取参数 设置播放状态等 在此操作 会导致视频开始播放出现几秒钟的黑屏，所以相关操作转移到视频数据回调的方法中
        
#if 0
        sid++;
        if (sid == 83) {
            sid = 80;
        }
#endif
        
        
    }
    
    
    // 开始录像
//    NSLog(@"record path:%@", betaCompressionDirectory);
    //    NSString *betaCompressionDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"];
//    x_player_StartRecord(playid, [betaCompressionDirectory UTF8String], 320, 180, 15);
}

- (void)btnCloseVideo
{
    if (userid >= 0) {
        // 结束实时视频请求
        device_net_work_stopStream(userid);
        x_player_stopPlay(playid);
        
        // 录像结束
        x_player_StopRecord(playid);
    }

}

/*!!!!!!!!!!!!!!请注意监听和对讲互斥!!!!!!!!!!!!!!!!!!!!*/
- (void)btnOpenSound
{
    // 打开音频解码
    if (x_player_openSound(playid) != AP_ERROR_SUCC) {
        return;
    }
    // 注册接收音频
    //x_player_RegisterAudioCallBack(playid, NULL, self);
    // 请求音频数据
    device_net_work_startAudio(userid, 1, CallBack_AVData, self);

}

     
- (void)btnCloseSound
{
    // 结束音频数据
    device_net_work_stopAudio(userid);
    // 关闭音频解码
    x_player_closeSound(playid);
    
}

- (void)btnOpenTalk
{
    if (playid < 0 || userid < 0) {
        return;
    }
    
    x_player_StartTalk(playid, CallBack_EncodeAudioData, self);
}

- (void)btnCloseTalk
{
    if (playid < 0 || userid < 0) {
        return;
    }
    x_player_StopTalk(playid);
}

- (void)btnSnapshot
{
    if (playid < 0) {
        
        return;
    }
    
    NSString *betaCompressionDirectory = [NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),_did];
    
    if (x_player_CapturePicture(playid, [betaCompressionDirectory UTF8String])) {
        UIImage *img =  [UIImage imageWithContentsOfFile:betaCompressionDirectory];
        [self saveImageToPhotos:img];
        
        MYLog(@"capture picture ok");
        
    } else {
        
        MYLog(@"capture picture failed.");
    }
}

-(void)saveImage{

}
- (void)btnGetParam
{
    
    if (userid < 0) {
        return;
    }
    
    device_net_work_get_param(userid, GET_CAMERA_PARAMS);
}

- (void)btnRecord{
    if (playid < 0 || userid < 0) {
        return;
    }
    if (playid >= 0) {
        NSString *betaCompressionDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"];
            MYLog(@"record path:%@", betaCompressionDirectory);
            x_player_StartRecord(playid, [betaCompressionDirectory UTF8String], 320, 180, 15);
    }
#if 0
    _timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1 target:self selector:@selector(memeryDetect) userInfo:nil repeats:YES];
    [_timer fire];
#endif
    
    [self addRecordingLabel];

  //  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(memeryDetect) userInfo:nil repeats:YES];
}
-(void )memeryDetect
{
    double avaible =  [[memoryOperation shareMemoryOperation] availableMemory];
    double used = [[memoryOperation shareMemoryOperation] usedMemory];
    NSLog(@"the avaible memory is %f",avaible);
    [self showWithTime:1 title:[NSString stringWithFormat:@"%f",avaible]];
    NSLog(@"the avaible memory is %f",used);
    
}

- (void)btnStopRecord{
    
    if (playid >= 0) {
        x_player_StopRecord(playid);
    }
    
    // save the vedio
     NSString *betaCompressionDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"];
 
        UISaveVideoAtPathToSavedPhotosAlbum(betaCompressionDirectory, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    // 关闭计时器
    [_timerCounter endCount];
}

- (void)btnPlayRecord{
    
    NSString *betaCompressionDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"];
    NSLog(@"record path:%@", betaCompressionDirectory);
    MPMoviePlayerViewController *MoviePlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:betaCompressionDirectory]];
    //MoviePlayerView.moviePlayer.controlStyle = MPMovieControlStyleNone;
    [self presentMoviePlayerViewControllerAnimated:MoviePlayerView];
    [MoviePlayerView.moviePlayer play];
}

//云台控制
-(void )UpMotion
{
    device_net_work_ptz(userid,PTZ_DOWN);
}

-(void )DownMotion
{
    device_net_work_ptz(userid,PTZ_UP);
}

-(void )leftMotion
{
    device_net_work_ptz(userid,PTZ_RIGHT);
}

-(void )rightMotion
{
    device_net_work_ptz(userid,PTZ_LEFT);
}

-(void )convertImage:(UIButton *)btn
{
    
    STRU_CAMERA_CONTROL paras = {0};
    paras.param = 5;
    if (btn.tag == 99) {
        paras.value = 2;
    }else if (btn.tag == 101){
        paras.value = 1;
    }else if (btn.tag == 102)
    {
        paras.value = 3;
        
    }else
    {
        paras.value = 0;
        
    }
    // paras.
    
    device_net_work_set_param(userid, SET_CAMERA_PARAMS, (const char*)&paras ,sizeof(paras));
}


//原始方向
-(void )resumeDirection
{
    STRU_CAMERA_CONTROL paras = {0};
    paras.param = 5;
    paras.value = 0;
    
    device_net_work_set_param(userid, SET_CAMERA_PARAMS, (const char*)&paras ,sizeof(paras));
    
}

//水平旋转
-(void )convertHorizontalDirection
{
    STRU_CAMERA_CONTROL paras = {0};
    paras.param = 5;
    paras.value = 2;
    
    device_net_work_set_param(userid, SET_CAMERA_PARAMS, (const char*)&paras ,sizeof(paras));
    
}

//竖直旋转
-(void )convertVerticalDirectiron
{
    STRU_CAMERA_CONTROL paras = {0};
    paras.param = 5;
    paras.value = 1;
    
    device_net_work_set_param(userid, SET_CAMERA_PARAMS, (const char*)&paras ,sizeof(paras));
    
}

//水平并且竖直旋转
-(void )convertHorAndVerDirection
{
    STRU_CAMERA_CONTROL paras = {0};
    paras.param = 5;
    paras.value = 3;
    
    device_net_work_set_param(userid, SET_CAMERA_PARAMS, (const char*)&paras ,sizeof(paras));
}


//亮度调节
-(void )changeLuminance:(UISlider *)slider
{
    CGFloat value = slider.value;
    
    STRU_CAMERA_CONTROL param = {0};
    param.param = 1;
    param.value = value;
    
    device_net_work_set_param(userid, SET_CAMERA_PARAMS, (const char*)&param ,sizeof(param));
    
}

-(void )infraredray:(UIButton *)btn
{
    STRU_CAMERA_CONTROL paras = {0};
    paras.param = 14;
    
    // paras
    
    btn.selected = !btn.selected;
    
    if(btn.selected)
    {
        paras.value = 1;
        
    }else
    {
        paras.value = 0;
    }
    device_net_work_set_param(userid, SET_CAMERA_PARAMS, (const char*)&paras ,sizeof(paras));
}

-(void )yes :(UIPanGestureRecognizer *)pan
{
    MYLog(@"here");
}

-(void )changeZhenPin:(UISegmentedControl *)control
{
    [self btnStop];
    
    if (control.selectedSegmentIndex == 0) {
        sid = 80;
    }else if (control.selectedSegmentIndex == 1)
    {
        sid = 81;
        
    }else
    {
        sid = 82;
    }
    [self btnConnect];
}

//change resolution
-(void )changeResolutionWithType:(kResolutionType)reslotion
{
    [self btnStop];
    
    switch (reslotion) {
        case kResolution720P:
            sid = 80;
            break;
        case kResolutionVGA:
           _resolutionType = kResolutionVGA;
            break;
        case kResolutionQVGA:
            _resolutionType = kResolutionQVGA;
            break;
        default:
            break;
    }
    
    [self btnConnect];
}

#pragma mark - 通知管理
-(void )reachabilityChanged:(NSNotification *)notice
{
    
    if (self.wifiReachability.currentReachabilityStatus == NotReachable) {
        
        [self stopBtnClick];
        
    }
    
#if 0
    // 判断不是很准确
    else if(self.wifiReachability.currentReachabilityStatus == ReachableViaWiFi)  {
        
        [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Change_To_WIFI", nil)];
        if (self.isPlaying) {
            [_indicator startAnimating];
        }
    }else
    {
        [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Change_To_Cell", nil)];
        if(self.isPlaying )
        {
            [_indicator startAnimating];
        }
    };

    else
    {
        [self stopBtnClick];

        if(self.isPlaying )
        {
            [_indicator startAnimating];
        }

    }
    
  #endif
}

-(void )applicationDidEnterBackground:(NSNotification *)notice
{
    
}

#pragma  mark - save image
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}


- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg = @"保存图片失败" ;
      
    }else{
       
        msg = @"保存图片成功" ;
    }
    
    MYLog(@"%@",msg);
    
}

#pragma mark - save vedio 
// 视频保存回调

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    
    MYLog(@"%@",videoPath);
    
    MYLog(@"%@",error);
    
}

#pragma mark - 事件处理
/*
 * 事件处理，若显示到控件必须转到主线程处理
 */
- (void)ProcessEvent:(int)nType
{
    
    event_type = nType;
    
    [self performSelectorOnMainThread:@selector(showEvent) withObject:nil waitUntilDone:NO];
}

- (void)ProcessP2pMode:(int)mode
{
    NSLog(@"P2P Mode = %d",mode);
}

- (void)ProcessAlarmMessage:(int)nType
{
    NSLog(@"alarm type = %d", nType);
}

- (void)ProcessGetParam:(int)nType Data:(const char*)szMsg DataLen:(int)len
{
    MYLog(@"GetParam type:%x len:%d", nType, len);
    switch (nType) {
        case GET_PARAM_NETWORK:     // 网络参数
        {
            STRU_NETWORK_PARAMS *param = (STRU_NETWORK_PARAMS*)szMsg;
            char szbuf[1024] = {0};
            sprintf(szbuf, "\nIPAddr:%s\nPort:%d\nGateway:%s\nMask:%s\n", param->ipaddr, param->port, param->gatway, param->netmask);
            MYLog(@"-------------------WIFI PARAM--------------------");
            MYLog(@"%s", szbuf);
            MYLog(@"-------------------WIFI PARAM END-----------------");
        }
            break;
        case GET_CAMERA_PARAMS:     // 网络参数
        {
            STRU_CAMERA_PARAMS *param = (STRU_CAMERA_PARAMS*)szMsg;
            
            self.flipType = param->flip;
            
            // 隐藏视图
            [self judgeFlipButtonsStatus];
            
            MYLog(@"resolution _%d",param->resolution);
            MYLog(@"brightness _%d",param->brightness);
            MYLog(@"contrast _%d",param->contrast);
            MYLog(@"hue _%d",param->hue);
            MYLog(@"flip _%d",param->flip);
            MYLog(@"saturation _%d",param->saturation);
            MYLog(@"mode _%d",param->mode);
            MYLog(@"osdEnable _%d",param->osdEnable);
            MYLog(@"enc_framerate _%d",param->enc_framerate);
            MYLog(@"sub_enc_framerate _%d",param->sub_enc_framerate);
        }
            break;
        default:
            break;
    }
}

- (void)ProcessSetParam:(int)nType Result:(int)result
{

}
#pragma mark - 视频加载成功的相关操作
-(void )hideIndicator
{
    self.isPlaying = YES;
    
    [_indicator stopAnimating];
    [_backView removeFromSuperview];
    
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
    //获取参数
    device_net_work_get_param(userid, GET_CAMERA_PARAMS);
    
    //三秒后自动截图
#if 0
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
                [self btnSnapshot];
    
            });
#endif
      });
    
}
#pragma mark - 判断左右翻转
-(void )judgeFlipButtonsStatus
{

}
- (void)ProcessYUV420Data:(Byte *)yuv420 Width:(int)width Height:(int)height
{
    if (!self.isPlaying) {
        
        [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    }
    
    [_m_glView WriteYUVFrame:yuv420 Len:width * height * 3 / 2 width:width height:height];
    
}// dalring tiffany good night


- (void)showEvent
{
    NSString *str;
    switch (event_type) {
        case NET_EVENT_CONNECTTING:
        {
            str = [NSString stringWithFormat:@"%s", "connecting..."];
        }
            break;
        case NET_EVENT_CONNECTED:
        {
            str = [NSString stringWithFormat:@"%s", "online"];
            
            //连接视频
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   
                   [self btnOpenVideo];
               });
        }
            break;
        case NET_EVENT_CONNECT_ERROR:{
            
            str = [NSString stringWithFormat:@"%s", "connect failed"];          //连接失败  显示播放按钮
            self.isPlaying = NO;
            [_indicator stopAnimating];
            [_playBtn setHidden:NO];
            
        }
            break;
        case NET_EVENT_ERROR_USER_PWD:{
            str = [NSString stringWithFormat:@"%s", "auth failed"];;          //验证失败  显示播放按钮
            self.isPlaying = NO;
            [_indicator stopAnimating];
            [_playBtn setHidden:NO];
            
        }

            break;
        case NET_EVENT_ERROR_INVALID_ID:{
             str = [NSString stringWithFormat:@"%s", "invalid id"];        //验证失败  显示播放按钮
            self.isPlaying = NO;
            [_indicator stopAnimating];
            [_playBtn setHidden:NO];
            
        }

            break;
        case NET_EVENT_P2P_NOT_ON_LINE:{
            str = [NSString stringWithFormat:@"%s", "offline"];             //设备不在线  显示播放按钮
            self.isPlaying = NO;
            [_indicator stopAnimating];
            [_playBtn setHidden:NO];
        }
            break;
        case NET_EVENT_CONNECT_TIMEOUT:
            str = [NSString stringWithFormat:@"%s", "connect timeout"];
            break;
        case NET_EVENT_DISCONNECT:
        {
            str = [NSString stringWithFormat:@"%s", "disconnect"];          //视频中断  指示器旋转
            self.isPlaying = NO;
            [_indicator startAnimating];
        }
            break;
        case NET_EVENT_CHECK_ACCOUNT:
            str = [NSString stringWithFormat:@"%s", "auth user info"];
            break;
            
        default:
            break;
    }
    
  //  lblMsg.text = str;
   // [self showWithTime:hubAnimationTime title:str];
    MYLog(@"%@",str);

    
}

@end
