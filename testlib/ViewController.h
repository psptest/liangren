//
//  ViewController.h
//  testlib
//
//  Created by APPLE on 2/2/15.
//  Copyright (c) 2015年 hsl. All rights reserved.
//

#import "ROBaseViewController.h"
#import "MyGLViewController.h"

typedef enum : NSUInteger {
    kResolutionQVGA = 0,
    kResolutionVGA,
    kResolution720P,
} kResolutionType;

typedef enum : NSUInteger {
    kFlipOriginal = 0,          //原始
    kFlipVertical,              //垂直
    kFlipHorizontal,            //水平
    kFlipHorAndVer              //水平加垂直
} kFlipType;

@protocol ViewContrdollerDelegate <NSObject>

@end

@class DeviceModel;

@interface ViewController : ROBaseViewController

@property(nonatomic,strong)MyGLViewController *m_glView;

@property(nonatomic,assign) BOOL isPlaying;
@property(nonatomic,assign) BOOL isFullScreen;
@property(nonatomic,strong) DeviceModel *camera;

@property(nonatomic,assign) kFlipType flipType;

// 实例化
- (instancetype)initWithDev_id:(DeviceModel *)camera isFullScreen:(BOOL )isFullScreen;

// 添加或删除播放全屏按钮
-(void )addPlayBtn;
-(void )removePlayBtn;

-(void )stopBtnClick;

// connnect and stop the camera
- (void)btnConnect;
- (void)btnStop;

//open and close the video 
- (void)btnOpenVideo;
- (void)btnCloseVideo;

// record the video
- (void)btnRecord;
- (void)btnStopRecord;

//snap the picture
- (void)btnSnapshot;

// open the sound
- (void)btnOpenSound;
- (void)btnCloseSound;

// change the resolution
-(void )changeResolutionWithType:(kResolutionType )reslotion;

// cloud control
-(void )UpMotion;

-(void )DownMotion;

-(void )leftMotion;

-(void )rightMotion;

// image convert

//原始方向
-(void )resumeDirection;
//水平旋转
-(void )convertHorizontalDirection;

//竖直旋转
-(void )convertVerticalDirectiron;

//水平并且竖直旋转
-(void )convertHorAndVerDirection;




@end

