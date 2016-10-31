//
//  displayView.m
//  security2.0
//
//  Created by Sen5 on 16/3/28.
//  Copyright © 2016年 com.letianxia. All rights reserved.
// 用于首页相关信息的呈现

#import "displayView.h"
#import "AnimationDashImageView.h"

#import "Masonry.h"
#import "prefrenceHeader.h"
#import "UIColor+Hex.h"
#import "UIImageView+imageSizeOperation.h"

#define kSlideViewToBottom 11
#define kSlideViewSize CGSizeMake(30, 22)
#define kStep 10

@interface displayView ()
@property(nonatomic,weak)UIImageView *imgView;
@property(nonatomic,strong)UIView *slideView;
@property(nonatomic,strong)UIView *nextSliderView;
@property(nonatomic,assign)CGRect originalFrame;
@property(nonatomic,strong)AnimationDashImageView *anim;
@property(nonatomic,strong)NSMutableArray *imagesData;
@property(nonatomic,strong)NSMutableArray *instrusionData;

@end

@implementation displayView
{
    CGRect _oriFrame;
}

-(NSMutableArray *)instrusionData
{
    if (_instrusionData == nil) {
        _instrusionData = [[NSMutableArray alloc]init];
        
        for (NSInteger i =0; i<9; i++) {
            NSString *imageName = [NSString stringWithFormat:@"ic_dashboard_intrusion0%ld",i+1];
            UIImage *image = [UIImage imageNamed:imageName];
            [_instrusionData addObject:image];
        }
    }
    return _instrusionData;
}
-(NSMutableArray *)imagesData
{
    if (_imagesData == nil) {
        _imagesData = [[NSMutableArray alloc]init];
        
        for (NSInteger i =0; i<9; i++) {
            NSString *imageName = [NSString stringWithFormat:@"ic_dashboard_ok0%ld",i+1];
            UIImage *image = [UIImage imageNamed:imageName];
            [_imagesData addObject:image];
        }
    }
    return _imagesData;
}

-(CGRect)originalFrame
{
    _originalFrame = CGRectMake(kSelfWidth, kSelfHeight-kSlideViewSize.height, kSelfWidth/2.0f, kSlideViewSize.height);
    
    return _originalFrame;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // [self createAnimationView:kImagesOk];
        _oriFrame = frame;
        //滑动动画暂时删除
        // [self createTimer];
      //  [self createSlideView];
        self.backgroundColor = kDarkBackgroudColor;
    }
    return self;
}
#pragma mark - 创建视图
-(void)createAnimationView:(kImagesType)imagesType
{
    self.autoresizesSubviews = YES;
    self.anim = [AnimationDashImageView animationViewWithImages:self.imagesData];
    
  //   UIImage * image = [UIImageView newImageWithName:@"newBack" CGSize:CGSizeMake(self.frame.size.height*1.692, self.frame.size.height)];
   // UIColor *back_Color = [UIColor colorWithPatternImage:image];
  //  self.backgroundColor = back_Color;
    UIImage *image = [UIImage imageNamed:@"newBack"];
    self.image = image;
    
#if 0
    UIViewContentModeScaleToFill,
    UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
    UIViewContentModeScaleAspectFill,
#endif
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    if (imagesType == kImagesIntrusion) {
        self.anim = [AnimationDashImageView animationViewWithImages:self.instrusionData];
        [self layoutSubviews];
        self.backgroundColor = kMainRedColor;
    }
    
    CGFloat disHeight = CGRectGetHeight(_oriFrame);
    CGFloat disWidth = CGRectGetWidth(_oriFrame);
    //  CGFloat ratio = CGRectGetWidth(self.anim.frame)/CGRectGetHeight(self.anim.frame);
   CGFloat height = disHeight*0.4f;
  //  MYLog(@"%f",height);
    CGFloat width = height;
    
    self.anim.frame = CGRectMake(disWidth/2.0f-width/2.0, disHeight/2.0f-height/2.0f, width, height);
    
    [self addSubview:self.anim];
    
    self.anim.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.anim startAnimating];
    
}
-(void)layoutSubviews
{
   
}
-(UILabel *)getLabelWithText:(NSString *)text
{
    UILabel *PMLabel = [[UILabel alloc]init];
    PMLabel.text = text;
    PMLabel.textColor = kDarkBackgroudColor;
    return PMLabel;
}
-(UIView *)slideViewWithFrame:(CGRect)frame PM:(NSString *)PM temp:(NSString *)temp
                         humi:(NSString *)humi
{
    UIView *slide = [[UIView alloc]initWithFrame:frame];
    
    UILabel *PMLabel = [self getLabelWithText:PM];
    [slide addSubview:PMLabel];
    
    UILabel *tempLabel = [self getLabelWithText:temp];
    [slide addSubview:tempLabel];
    
    UILabel *humiLabel = [self getLabelWithText:humi];
    [slide addSubview:humiLabel];
    
    PMLabel.frame = CGRectMake(0, 0,kSlideViewSize.width,CGRectGetHeight(frame));
    
    tempLabel.frame = CGRectMake(CGRectGetWidth(frame)/2.0-kSlideViewSize.width/2.0f,0, 30, 22);
    
    humiLabel.frame = CGRectMake(CGRectGetWidth(frame)-kSlideViewSize.width, 0,30, 22);
    return slide;
}
-(void )createSlideView
{
    self.slideView = [self slideViewWithFrame:self.originalFrame PM:@"40" temp:@"23" humi:@"69"];
    [self addSubview:self.slideView];
    
    self.nextSliderView = [self slideViewWithFrame:self.originalFrame PM:@"40" temp:@"23" humi:@"69"];
    
    [self addSubview:self.nextSliderView];
    // self.slideView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    //self.nextSliderView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
}

-(void)setAnimationViewFrame:(CGRect)frame
{
    if (frame.origin.y> 0) {
        
        self.anim.frame = frame;
    }
}
#pragma mark - 创建timer动画
-(void)step
{
    CGFloat midX = CGRectGetMidX(self.slideView.frame);
    midX -= kStep;
    self.slideView.center = CGPointMake(midX,kSelfHeight-kSlideViewSize.height/2.0f);
    //如果slideViewminx<0 则nextView开始移动
    if (CGRectGetMinX(self.slideView.frame)<0) {
        self.nextSliderView.center = CGPointMake(midX+kSelfWidth, kSelfHeight-kSlideViewSize.height/2.0f);
        //如果nextView的max<0 则将slide next复归到原始位置
        if (CGRectGetMaxX(self.nextSliderView.frame)<0) {
            self.slideView.frame = self.originalFrame;
            self.nextSliderView.frame = self.originalFrame;
        }
    }
}
-(void)createTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(step) userInfo:nil repeats:YES];
    self.timer = timer;
    [self.timer fire];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"the display view s frame is %@", NSStringFromCGRect(self.frame)];
}

#pragma mark - 刷新动图
-(void)refreshAnimationViewWithTag:(kImagesType )imagesType
{
    [self.anim removeFromSuperview];
    self.anim = nil;
    // [self.anim removeFromSuperview];
    switch (imagesType) {
        case kImagesOk:
            [self createAnimationView:kImagesOk];
            break;
        case kImagesIntrusion:
            [self createAnimationView:kImagesIntrusion];
            break;
            
        default:
            break;
    }
}
-(void)refreshAnimationViewWithFrame:(CGRect)frame
{
    self.anim.frame = frame;
}

@end