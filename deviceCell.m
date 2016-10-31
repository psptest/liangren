//
//  deviceCell.m
//  security2.0
//
//  Created by Sen5 on 16/6/27.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "deviceCell.h"
#import "DeviceModel.h"
#import "prefrenceHeader.h"
#import "fileOperation.h"
#import "Masonry.h"

@implementation deviceCell
{
    UIButton *_control;
    UILabel *_descLabel;
    DeviceModel *_deviceMod;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _control = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_control];
        [_control addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        _descLabel = [[UILabel alloc] init];
        [_descLabel setTextColor:kLightTitleColor];
        [self.contentView addSubview:_descLabel];
    }
    
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(30);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.7);
        make.width.mas_equalTo(_control.mas_height);
        
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_control.mas_right).offset(20);
        make.centerY.mas_equalTo(_control.mas_centerY);
        make.height.mas_equalTo(_control.mas_height).multipliedBy(0.5);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.5);
    }];
    
}
-(void)refreshUIWithModel:(DeviceModel *)device
{
    _deviceMod = device;
    UIImage *nor_img;
    UIImage *sel_img;
    
    NSString *dev_status =[ device.status[0][@"params"] substringToIndex:2];
    
    if (device.mode == kDeviceSensor) {
        _control.enabled = NO;
        
        if (device.status.count != 0) {
            // sensor
            if ([dev_status isEqualToString:@"AQ"]) {
                nor_img = [UIImage imageNamed:[[fileOperation sharedOperation] getImageNameWithDevice_type:device.dev_type device_mode:0][@"danger"]];
            }else if([dev_status isEqualToString:@"AA"])
            {
                nor_img = [UIImage imageNamed:[[fileOperation sharedOperation] getImageNameWithDevice_type:device.dev_type device_mode:0][@"safety"]];
            }
            // Z-wave infraded sensor
            else if([dev_status isEqualToString:@"CA"])
            {
                nor_img = [UIImage imageNamed:[[fileOperation sharedOperation] getImageNameWithDevice_type:device.dev_type device_mode:0][@"danger"]];
            }else if([dev_status isEqualToString:@"Aw"])
            {
                nor_img = [UIImage imageNamed:[[fileOperation sharedOperation] getImageNameWithDevice_type:device.dev_type device_mode:0][@"danger"]];
            }
            else
            {
                nor_img = [UIImage imageNamed:[[fileOperation sharedOperation] getImageNameWithDevice_type:device.dev_type device_mode:0][@"noWork"]];
            
            }
        }else
        {
            _control.enabled = NO;
             // 如果状态未回来 则显示未知状态
            nor_img = [UIImage imageNamed:[[fileOperation sharedOperation] getImageNameWithDevice_type:device.dev_type device_mode:0][@"noWork"]];
             sel_img = [UIImage imageNamed:[[fileOperation sharedOperation] getImageNameWithDevice_type:device.dev_type device_mode:0][@"noWork"]];

            //nor_img = [UIImage imageNamed:@"btn_unkown_status_"];
            //sel_img = [UIImage imageNamed:@"btn_unkown_status_"];
        }
    
         }
    else{
        // control
        _control.enabled = YES;
        
         if (device.status.count != 0) {
             
             nor_img = [UIImage imageNamed:[[fileOperation sharedOperation] getImageNameWithDevice_type:device.dev_type device_mode:1][@"off"]];
             sel_img = [UIImage imageNamed:[[fileOperation sharedOperation] getImageNameWithDevice_type:device.dev_type device_mode:1][@"on"]];
         
         }else
         {
             nor_img = [UIImage imageNamed:@"btn_unkown_status_"];
             sel_img = [UIImage imageNamed:@"btn_unkown_status_"];
         }
       
    
    }
    if (device.status.count != 0) {
        
    if ([dev_status isEqualToString:@"AQ"]) {
        _control.selected = YES;
    }else
    {
        _control.selected = NO;
    }
    }else
    {
#warning 状态未回来 设置为未知状态
        _control.selected = NO;
    }
    
    [_control setBackgroundImage:nor_img forState:(UIControlStateNormal)];
    [_control setBackgroundImage:sel_img forState:(UIControlStateSelected)];
    
    _descLabel.text = device.name;
    
#if 0
    switch (device.mode) {
        case kDeviceSensor:
        {
            _control.enabled = NO;//不可点击
        }
            
            break;
        case kDeviceControl:
        {
            _control.enabled = YES;//可点击状态
        }
            
            break;
        case kDeviceFull:
            
            break;
        case kDeviceUnknown:
            
            break;
            
        default:
            break;
    }
#endif
    
}

#pragma mark - 点击事件
-(void)btnClicked
{
    //  _control.selected = !_control.selected;
    //按钮点击 则执行代理方法
    [_delegate controlDevice:self];
}

-(void)setBtnSeleted:(BOOL)selected
{
    _control.selected = selected;
}
-(BOOL)getBtnSeleted
{
    return _control.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
