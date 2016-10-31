//
//  roomsCollectionCel.m
//  security2.0
//
//  Created by Sen5 on 16/3/25.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "roomsCollectionCel.h"
#import "prefrenceHeader.h"
#import "roomsModel.h"
#import "DeviceModel.h"
#import "fileOperation.h"
#import "Masonry.h"

#define kImageSpacing 2
#define kDeviceIconSize

@interface roomsCollectionCel ()
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation roomsCollectionCel
{
    UIButton *_select;
    BOOL _isDeleted;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
   
    if (self) {
        
        _imgView = [[UIImageView alloc]init];
        _imgView.backgroundColor = kRootTabBarColor;
        
        [self.contentView addSubview:_imgView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = kLightTitleColor;
        [self.contentView addSubview:_titleLabel];
        
        self.contentView.backgroundColor = kRootTabBarColor;
    }
    return self;
}
-(void)layoutSubviews
{
    __weak __typeof(self)wSelf = self;
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(wSelf)sSelf = wSelf;
        make.left.top.right.mas_equalTo(0);
        make.height.equalTo(sSelf.contentView.mas_height).multipliedBy(0.80f);
    }];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(wSelf)sSelf = wSelf;
        make.left.right.mas_equalTo(kImageSpacing);
        make.top.equalTo(sSelf.imgView.mas_bottom).offset(1.0f);
        make.height.equalTo(sSelf.contentView.mas_height).multipliedBy(0.1);
        
    }];
    
}

-(void)refreshUIWithModel:(roomsModel *)mod
{
        
    self.imgView.image = mod.room_image;
  
    
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]&&(obj != _imgView)) {
            [obj removeFromSuperview];
        }
    }];
    
    self.titleLabel.text = mod.room_name;
    
     NSArray *devices = [[fileOperation sharedOperation] getAssignedDevicesWithModel:mod];
    NSLog(@"%@",devices);
    for (NSInteger i =0; i<devices.count; i++) {
        DeviceModel *device = devices[i]
        ;
        NSInteger row = i / kDeviceNumberEachLine ;
            NSInteger column = i % kDeviceNumberEachLine ;
            NSString *img = nil;

        img = [[fileOperation sharedOperation]getImageNameWithDevice_type:device.dev_type device_mode:device.mode][@"room"];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:img]];
        
        NSInteger size = CGRectGetWidth(self.frame)/ kDeviceNumberEachLine*1.0;
       
        imgView.frame = CGRectMake(size*column, size*row+CGRectGetHeight(self.contentView.frame)*0.9, size, size);
        
        [self.contentView addSubview:imgView];
        
        }
}

-(void)setEditing:(BOOL )isEditing
{
   
    if (isEditing) {
        
        UIButton *select = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [select setBackgroundImage:[UIImage imageNamed:@"ic_smoke_nowork_device_"] forState:UIControlStateNormal];
        
        [select setBackgroundImage:[UIImage imageNamed:@"ic_smoke_danger_device_"] forState:UIControlStateSelected];
        [self addSubview:select];
        _select = select;
        [select addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [select mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(10);
            make.width.height.mas_equalTo(30);
        }];
    }else
    {
        [_select removeFromSuperview];
        _select = nil;
    }
}
-(void)btnClick:(UIButton *)btn
{
    btn.selected = ! btn.selected;
    if (btn.selected) {
        _isDeleted = YES;
    }else
    {
        _isDeleted = NO;
    }
}
-(BOOL)getDeleted
{
    return _isDeleted;
}

@end
