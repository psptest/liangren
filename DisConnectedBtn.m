//
//  DisConnectedBtn.m
//  security
//
//  Created by sen5labs on 15/10/28.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import "DisConnectedBtn.h"
#import "prefrenceHeader.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import <AudioToolbox/AudioToolbox.h>

@interface DisConnectedBtn ()

@property (nonatomic, strong) UILabel *wrongTitleLabel;
@property (nonatomic,strong) UIImageView *imgView;

@end

@implementation DisConnectedBtn

{
    DisConnectedReason _disConnectedReason;
}

+ (instancetype)disConnectedBtn {
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma mark - 界面创建
//根据wrongReson的枚举值 设置wrongTitleLabel的内容
- (void)setWithWrongSeason:(DisConnectedReason)wrongSeason{
    
    _disConnectedReason = wrongSeason;
    switch (wrongSeason) {
        case DisConnectedNoHouse:
            self.wrongTitleLabel.text = NSLocalizedString(@"No_House", nil);
            break;
        case DisConnectedFailed:
            self.wrongTitleLabel.text = NSLocalizedString(@"Network_Interruption", nil);
            break;
        case DisConnectedP2PConnectError:
        {
            self.wrongTitleLabel.text = kConnectedFailed;
            break;
        }
        case DIsConnectedReconnect:
        {
            self.wrongTitleLabel.text = NSLocalizedString(@"Connecting", nil);
            break;
        }
        case DisConnectedCheckUserIDFail:
        {
            self.wrongTitleLabel.text = NSLocalizedString(@"UserID_Fail", nil);
            break;
        }
            
        default:
            break;
    }
    
    self.reason = wrongSeason;
}

-(void )setAlarms:(NSString *)alarms
{
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    
    [app.window addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(app.window.mas_left).offset(10);
        make.right.equalTo(app.window.mas_right).offset(-10);
        make.top.equalTo(app.window.mas_top).offset(10);
        make.height.mas_equalTo(40);
    }];

    // 震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    
    [self animationWithFlag:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self animationWithFlag:YES];
    });
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self removeFromSuperview];
    });
    
    self.wrongTitleLabel.text = alarms;
}

-(DisConnectedReason )getWithWrongSeason
{
    return  _disConnectedReason;
}

- (void)button1BackGroundNormal:(UIButton *)sender {
   // self.backgroundColor = [UIColor colorWithRed:0xff/255.0 green:0xca/255.0 blue:0xcc/255.0 alpha:1.0];
}

- (void)button1BackGroundHighlighted:(UIButton *)sender {
   // self.backgroundColor = [UIColor colorWithRed:0xfc/255.0 green:0xb8/255.0 blue:0xbb/255.0 alpha:1.0];
    
   // [_delegate disConnectedBtnClicked];
}

- (void)setupUI {
    
    self.backgroundColor = kMainRedColor;
    
    [self addSubview:self.imgView];
    [self addSubview:self.wrongTitleLabel];
    //[self addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    
   // [self addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
}

- (UILabel *)wrongTitleLabel {
    if (!_wrongTitleLabel) {
        _wrongTitleLabel = ({
            UILabel * label = [[UILabel alloc] init];
            label.frame = CGRectMake(70, 5, 200, 30);
            label.center = CGPointMake(kScreenWidth/2.0f, CGRectGetMidY(label.frame));
            label.font = [UIFont systemFontOfSize:16.0];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label;
            
           
        });
        
    }
    return _wrongTitleLabel;
}

-(UIImageView *)imgView
{
    if (!_imgView) {
        
        _imgView = ({
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(30, 5, 30, 30);
        imageView.image = [UIImage imageNamed:@"wrong"];
        imageView;
        });
    }
    
    return _imgView;
}
#pragma mark - 显示或隐藏
-(void )animationWithFlag:(BOOL)flag
{
    CGFloat alpha = flag?0.0:1.0;
    CGFloat disConnectedBtnHeight = flag?0:44;
    
    CGRect disConnectedBtnframe = CGRectMake(10, 20, kScreenWidth-20, disConnectedBtnHeight);
    
    [self layoutIfNeeded];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = alpha;
        self.hidden = flag;
        self.frame = disConnectedBtnframe;
        
    } completion:^(BOOL finished) {

    }];
}
@end
