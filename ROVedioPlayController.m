//
//  ROVedioPlayController.m
//  secQre
//
//  Created by Sen5 on 16/10/20.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import "ROVedioPlayController.h"
#import "UIViewController+MBProgressHUD.h"
#import "AppDelegate.h"
//#import "P2Phandle.h"
//#import "PrefixHeader.pch"
#import "prefrenceHeader.h"
#import "NSDataWithCameraType.h"
#import "ViewController.h"
#import "cameraModel.h"
#import "DeviceModel.h"

#define kHubViewShowTime 1

typedef enum : NSUInteger {
    kVideoBtn = 0,              //录制按钮
    kPictureBtn,                //截图按钮
    kVoiceBtn,                  //监听按钮
    kResolutionBtn,             //分辨率按钮
    kLeftBtn,                    //水平翻转按钮
    kUpBtn                      //垂直翻转按钮
} kBtnType;

@interface ROVedioPlayController ()
{
    NSTimer * _timer;             //消失的时间
    CGRect _originalFrame;       //原始的frame
}

@property (nonatomic, assign) BOOL isShowBtnView;
@property (nonatomic, assign) BOOL isPreparePlaying;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) UIImageView *topView;          //顶部视图
@property (nonatomic, strong) UIImageView *bottomView;       //底部视图
@property (nonatomic,strong) UIButton *backBtn;               //返回按钮
@property (nonatomic, strong) UIButton *playButton;           //播放按钮

@end

@implementation ROVedioPlayController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view
    if (self.isFullScreen) {
       
        [self setupUI];
        [self addNotifications];
        
        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self btnConnect];
        });
    }
}

#pragma mark - 实例化
- (instancetype)initWithDev_id:(DeviceModel *)camera isFullScreen:(BOOL )isFullScreen
{
    self = [super initWithDev_id:camera isFullScreen:isFullScreen];
    
    if (self) {
        
    }
    
    return self;
}
#pragma mark - 添加通知
-(void )addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vedioStarting:) name:kNotification_VedioStarting object:nil];
}
#pragma mark - 全屏界面創建
- (void)setupUI {
    
    [self.navigationController.navigationBar setHidden:YES];
    [self hideTabBar];
    
    
    _originalFrame = self.view.frame;
    
    // 改变结构
    CGRect frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
    
    self.view.frame = frame;
    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    self.view.center = CGPointMake(CGRectGetMidY(frame), CGRectGetMidX(frame));
   
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    [app.window addSubview:self.view];
    
    [self.parentViewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:NSClassFromString(@"UIScrollView")]) {
            [obj bringSubviewToFront:self.view];
            
            *stop = YES;
        }
    }];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    
    [self createControlBtns];
    [self.view addGestureRecognizer:self.tapGesture];
    
    [self showPlayControlButton];
    
    // 刚开始取消视图的点击事件
   // self.bottomView.userInteractionEnabled = NO;
    
    //添加手势
    [self addGesture];
}

//界面恢复
-(void )resumeUI
{
    [self.topView removeFromSuperview];
    [self.bottomView removeFromSuperview];
    
    // remove tap
    [self.view removeGestureRecognizer:self.tapGesture];
    
    
    // change the frame
    self.view.transform = CGAffineTransformIdentity;
    self.view.frame = _originalFrame;
    
    
    [self.parentViewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:NSClassFromString(@"UIScrollView")]) {
            [obj addSubview:self.view];
            
            *stop = YES;
        }
    }];
    
    //  添加全屏按钮等
    [self addPlayBtn];
    
}


#pragma mark - events
- (void)playTapClick:(UITapGestureRecognizer *)tapGesture {
    
    if (self.isShowBtnView) {
        [self hidePlayControlButton];
    } else {
        [self showPlayControlButton];
    }
}

-(void )backBtnClick:(UIButton *)sender
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    
    AppDelegate * app = [UIApplication sharedApplication].delegate;
        
    app.isFullScreen = NO;
    
    // 判斷 如果是由camera視圖轉變frame而來 則還原視圖 否則取消視圖
    
    if ([self.parentViewController isKindOfClass:NSClassFromString(@"cameraViewController")]) {
        
        [self.navigationController.navigationBar setHidden:NO];
        [self showTabBar];
        
        // 如果自己是cameraViewController子视图控制器，证明当前视图是由camera视图变形而来 只需要对应的将试图还原即可
        [self resumeUI];
    }else
    {
        [self btnCloseVideo];
        [self btnStop];
        
        [self.view removeFromSuperview];
        [self dismissViewControllerAnimated:NO completion:nil];
        
       // _cam_view = nil;
    }
        
       // [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
        
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationFullPlayImageViewDidDisApprearance object:nil];
    
}

-(void )controlBtnClicked:(UIButton *)btn
{
    switch (btn.tag - 100) {
        case kVideoBtn:{
            // the function have not been done
            if (btn.selected) {
                [self btnStopRecord];
                [self showWithTime:kHubViewShowTime title:NSLocalizedString(@"Stop_Recording", nil)];
            }else
            {
                [self btnRecord];
                [self showWithTime:kHubViewShowTime title:NSLocalizedString(@"Start_Recording", nil)];
            }
        }
            break;
        case kPictureBtn:
        {
            [self btnSnapshot];
            [self showWithTime:kHubViewShowTime title:NSLocalizedString(@"Snap_Picture", nil)];
        }
            break;
        case kVoiceBtn:
        {
            if (btn.selected) {
                [self btnCloseSound];
                [self showWithTime:kHubViewShowTime title:NSLocalizedString(@"Stop_Listening", nil)];
            }else
            {
                [self btnOpenSound];
                [self showWithTime:kHubViewShowTime title:NSLocalizedString(@"Start_Listening", nil)];
            }
        }
            break;
        case kResolutionBtn:
        {
            
            if (btn.selected) {
                [self changeResolutionWithType:kResolutionVGA];
                [self showWithTime:kHubViewShowTime title:NSLocalizedString(@"Switch_Standard", nil)];
            }else
            {
                [self showWithTime:kHubViewShowTime title:NSLocalizedString(@"Switch_High", nil)];
                [self changeResolutionWithType:kResolutionQVGA];
            }
            
        }
            break;
        case kLeftBtn:
        {
            UIButton *verticalBtn = (UIButton *)[self.view viewWithTag:kUpBtn+100];
            
            if (btn.selected) {
                
                if (verticalBtn.selected) {
                    [self convertVerticalDirectiron];
                    
                }else
                {
                    [self resumeDirection];
                }
                
                [self showWithTime:kHubViewShowTime title:NSLocalizedString(@"Flip_Horizontal", nil)];
                
            }else
            {
                if (verticalBtn.selected) {
                    [self convertHorAndVerDirection];
                    
                }else
                {
                    [self convertHorizontalDirection];
                }
                [self showWithTime:kHubViewShowTime title:NSLocalizedString(@"Flip_Horizontal", nil)];
            }
        }
            break;
        case kUpBtn:
        {
            UIButton *horizontalBtn = (UIButton *)[self.view viewWithTag:kLeftBtn+100];
            
            if (btn.selected) {
                
                if (horizontalBtn.selected) {
                    
                    [self convertHorizontalDirection];
                    
                }else
                {
                    [self resumeDirection];
                }
                
                [self showWithTime:kHubViewShowTime title:NSLocalizedString(@"Flip_Vertical", nil)];
            }else
            {
                if (horizontalBtn.selected) {
                    
                    [self convertHorAndVerDirection];
                    
                }else
                {
                    [self convertVerticalDirectiron];
                }
                [self showWithTime:kHubViewShowTime title:NSLocalizedString(@"Flip_Vertical", nil)];
            }
        }
            break;
            
        default:
            break;
    }
    btn.selected = !btn.selected;
    
}

-(void )leftDirection
{
    [self leftMotion];
}
-(void )right
{
    [self rightMotion];
}
-(void )up
{
    [self UpMotion];
}
-(void )down
{
    [self DownMotion];
}


-(void )addGesture{
    
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftDirection)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(right)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
    
    UISwipeGestureRecognizer *up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(up)];
    up.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:up];
    
    UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(down)];
    down.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:down];
}


- (void)setupTimer {
    [self closeTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                              target:self
                                            selector:@selector(hidePlayControlButton)
                                            userInfo:nil
                                             repeats:NO];
    
}

- (void)closeTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)hidePlayControlButton {
    self.isShowBtnView = NO;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect topViewRect = self.topView.frame;
        topViewRect.origin.y = -44;
        CGRect bottomViewRect = self.bottomView.frame;
        bottomViewRect.origin.y = CGRectGetMaxX(self.view.frame);
        self.topView.frame = topViewRect;
        self.bottomView.frame = bottomViewRect;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showPlayControlButton {
    
    self.isShowBtnView = YES;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect topViewRect = self.topView.frame;
        topViewRect.origin.y = 0;
        self.topView.frame = topViewRect;
        CGRect bottomViewRect = self.bottomView.frame;
        bottomViewRect.origin.y =CGRectGetMaxX(self.view.frame) - kScreenHeight*0.1;//CGRectGetMaxY(self.frame) -
        self.bottomView.frame = bottomViewRect;
    } completion:^(BOOL finished) {
        
    }];
    
    [self setupTimer];
}

#pragma mark - notification
-(void )applicationDidEnterBackground:(NSNotification *)notice
{
    [self backBtnClick:_backBtn];
}

#pragma mark - 判断翻转按钮的选中状态
-(void )judgeFlipButtonsStatus
{
    
    // 将按钮的点击事件打开
     dispatch_async(dispatch_get_main_queue(), ^{
         
         self.bottomView.userInteractionEnabled = YES;
         
         //当前视图开始播放
         [self showPlayControlButton];
   });
    
    
    UIButton * HorizontalBtn = (UIButton *)[self.view viewWithTag:100+kLeftBtn];
    UIButton * VerticalBtn = (UIButton *)[self.view viewWithTag:100+kUpBtn];
    
    switch (self.flipType) {
            
        case kFlipOriginal:             //原始
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                HorizontalBtn.selected = NO;
                VerticalBtn.selected = NO;
            });
            
        }
            break;
        case kFlipHorizontal:           //水平
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                HorizontalBtn.selected = YES;
                VerticalBtn.selected = NO;
            });
           
        }
            break;
        case kFlipVertical:             //竖直
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                HorizontalBtn.selected = NO;
                VerticalBtn.selected = YES;
            });
           
        }
            break;
        case kFlipHorAndVer:            //水平且竖直
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                HorizontalBtn.selected = YES;
                VerticalBtn.selected = YES;
            });
           
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - getters
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playTapClick:)];
    }
    return _tapGesture;
}
-(void )createControlBtns{
    
    NSArray *img_names = @[@"btn_video_recording_nor_",@"btn_picture_nor_",@"btn_mic_off_nor_",@"btn_resolution_nor_",@"btn_radial1_nor_",@"btn_radial2_nor_"];
    
    NSArray *img_names_pre = @[@"btn_video_recording_pre_",@"btn_picture_pre_",@"btn_mic_off_pre_",@"btn_resolution_pre_",@"btn_radial1_pre_",@"btn_radial2_pre_"];
    
    for (NSInteger i = 0; i<img_names.count ; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 1) {
            [btn setImage:[UIImage imageNamed:img_names[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:img_names_pre[i]] forState:UIControlStateHighlighted];
        }else
        {
            [btn setImage:[UIImage imageNamed:img_names[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:img_names_pre[i]] forState:UIControlStateSelected];
        }
        
        CGFloat btn_x = kScreenHeight*0.2 + kScreenHeight*0.1*i;
        CGFloat btn_y = 0;
        CGFloat btn_size = kScreenHeight*0.1;
        //  CGFloat btn_size = 60;
        
        btn.tag = 100 +i;
        
        [btn addTarget:self action:@selector(controlBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setFrame:CGRectMake(btn_x, btn_y, btn_size, btn_size)];
        
        [self.bottomView addSubview:btn];
    }
}
- (UIImageView *)topView {
    if (!_topView) {
        _topView = ({
            UIImageView * view = [[UIImageView alloc] init];
            
            view.frame = CGRectMake(0, -40, kScreenHeight, 44);
            view.image = [UIImage imageNamed:@"gradualChange"];
            view.userInteractionEnabled = YES;
            [view addSubview:self.backBtn];
            view;
        });
    }
    return _topView;
}

- (UIImageView *)bottomView {
    if (!_bottomView) {
        
        _bottomView = ({
            UIImageView * view = [[UIImageView alloc] init];
            view.frame = CGRectMake(0, kScreenWidth, kScreenHeight, kScreenHeight*0.2);
            view.image = [UIImage imageWithCGImage:[UIImage imageNamed:@"gradualChange"].CGImage scale:1 orientation:UIImageOrientationDown];
            view.userInteractionEnabled = YES;
            //  view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            view;
        });
    }
    return _bottomView;
}

-(UIButton *)backBtn{
    if(!_backBtn){
        _backBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(5, 5, 30, 44);
            [btn setImage:[UIImage imageNamed:@"btn_back_nor"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"btn_back_pre"] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn;
            
        });
    }
    
    return _backBtn;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
