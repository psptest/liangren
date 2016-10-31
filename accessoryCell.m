// g
//  accessoryCell.m
//  security2.0
//
//  Created by Sen5 on 16/6/22.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "accessoryCell.h"
#import "Masonry.h"
#import "prefrenceHeader.h"

#define kAccessayViewHeight 30

@implementation accessoryCell
{
    UIButton *_control;
    UILabel *_descLabel;
    UIButton *_accessBtn;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        _control = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_control];
        // [_control addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        _descLabel = [[UILabel alloc] init];
        [_descLabel setTextColor:kLightTitleColor];
        [self.contentView addSubview:_descLabel];
        
        _accessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_accessBtn];
       // _accessBtn.tintColor = kDarkBackgroudColor;
        _accessBtn.imageView.tintColor = kDarkBackgroudColor;
        [_accessBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.backgroundColor = [UIColor whiteColor];
        self.tintColor = [UIColor whiteColor];
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
    
    [_accessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self layoutIfNeeded];
    
    _control.layer.cornerRadius = CGRectGetWidth(_control.frame)/2.0f;
    _control.clipsToBounds = YES;
    
}

-(void)setType:(kCellAccessaryType )type
{
    
    switch (type) {
            
        case kAccessayTypeArrow:
            [_accessBtn setImage:[UIImage imageNamed:@"btn_nexta_nor"] forState:UIControlStateNormal];
            break;
        case kAccessayTypeAdd:
            [_accessBtn setImage:[UIImage imageNamed:@"add-device-1_"] forState:UIControlStateNormal];
            break;
        case kAccessaryTypeWrong:
            [_accessBtn setImage:[UIImage imageNamed:@"tab_btn_Setting_nor"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
}

-(void)setImage:(UIImage  *)img
{
   
        [_control setBackgroundImage:img forState:UIControlStateNormal];

}
-(void)setText:(NSString *)text
{
    _descLabel.text = text;
}

#pragma mark - click event
-(void)addBtnClick
{
    [_delegate accessoryBtnClicked:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end