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

@property(nonatomic,strong)AnimationDashImageView *anim;
@property(nonatomic,strong)NSMutableArray *imagesData;
@property(nonatomic,strong)NSMutableArray *instrusionData;

@end

@implementation displayView
{
    CGRect _oriFrame;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _oriFrame = frame;
        self.backgroundColor = kDarkBackgroudColor;
        [self addParamsViews];
    }
    return self;
}
#pragma mark - 创建视图
-(void)createAnimationView:(kImagesType)imagesType
{
    self.autoresizesSubviews = YES;
    self.anim = [AnimationDashImageView animationViewWithImages:self.imagesData];
    
    self.image = [UIImage imageNamed:@"newBack"];
    
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    if (imagesType == kImagesIntrusion) {
        
        self.anim = [AnimationDashImageView animationViewWithImages:self.instrusionData];
        [self layoutSubviews];
        self.backgroundColor = kMainRedColor;
    }
    
    CGFloat disHeight = CGRectGetHeight(_oriFrame);
    CGFloat disWidth = CGRectGetWidth(_oriFrame);
    CGFloat height = disHeight*0.4f;
    CGFloat width = height;
    
    self.anim.frame = CGRectMake(disWidth/2.0f-width/2.0, disHeight/2.0f-height/2.0f, width, height);
    
    [self addSubview:self.anim];
    
  //  self.anim.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.anim startAnimating];
    
}
-(void )addParamsViews
{
    _humiView = [[ROParamsView alloc] initWithImage:[UIImage imageNamed:@"ic_humiture_nowork_device_"] contents:@"???"];
    _humiView.center = CGPointMake(CGRectGetWidth(self.bounds)*0.25-20, CGRectGetHeight(self.bounds)*(2/3.0));
    
    [self addSubview:_humiView];
    
    _tempView = [[ROParamsView alloc] initWithImage:[UIImage imageNamed:@"ic_humiture_nowork_device_"] contents:@"???"];
    _tempView.center = CGPointMake(CGRectGetWidth(self.bounds)*0.75+20, CGRectGetHeight(self.bounds)*(2/3.0));
    
    [self addSubview:_tempView];
    
    _sunyView = [[ROParamsView alloc ]initWithContents:@"Sunny"];
    _sunyView.center = CGPointMake(CGRectGetWidth(self.bounds)*0.25-10, CGRectGetHeight(self.bounds)*(1/3.0));
    
    [self addSubview:_sunyView];
    
    
    _PMView = [[ROParamsView alloc ] initWithContents:@"PM2.5 0000"];
    _PMView.center = CGPointMake(CGRectGetWidth(self.bounds)*0.75+10, CGRectGetHeight(self.bounds)*(1/3.0));
    
    [self addSubview:_PMView];
    
}
-(void)setAnimationViewFrame:(CGRect)frame
{
    if (frame.origin.y> 0) {
        
        self.anim.frame = frame;
    }
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

-(void)refreshAnimationViewWithFrame:(CGRect)frame
{
    self.anim.frame = frame;
}

@end