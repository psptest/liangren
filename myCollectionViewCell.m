//
//  myCollectionViewCell.m
//  security2.0
//
//  Created by Sen5 on 16/3/24.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "myCollectionViewCell.h"
#import "Masonry.h"

#import "prefrenceHeader.h"

#define kImageToTitleDistance CGRectGetHeight(self.imgView.frame)*2/3.0f
#define kMinimumTitleLength 10

@interface myCollectionViewCell()

@end

@implementation myCollectionViewCell

{
    CGSize _imageSize;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc]init];
        [self.contentView addSubview:imgView];
        self.imgView = imgView;
        
        
        UILabel *lab = [[UILabel alloc]init];
        lab.textColor = kLightTitleColor;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:lab];
        self.lab = lab;
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}
-(void)layoutSubviews
{
    __weak __typeof(self)wSelf = self;
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(wSelf)sSelf = wSelf;
        make.centerX.equalTo(sSelf.contentView.mas_centerX);
        make.centerY.equalTo(sSelf.contentView.mas_centerY).multipliedBy(0.7);
        make.height.equalTo(sSelf.contentView.mas_height).multipliedBy(0.5);
        make.width.equalTo(sSelf.contentView.mas_height).multipliedBy(0.5);
    }];
    
    [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(wSelf)sSelf = wSelf;
        make.centerX.equalTo(sSelf.contentView.mas_centerX);
        make.top.equalTo(sSelf.imgView.mas_bottom).offset(-kImageToTitleDistance);
        make.width.equalTo(sSelf.contentView.mas_width).multipliedBy(0.7);
        make.height.mas_equalTo(20);
    }];
    [self setLabConfigure];
    // 切圆
    [self layoutIfNeeded];
    self.imgView.layer.cornerRadius = CGRectGetHeight(self.imgView.frame)/2.0f;
    self.imgView.clipsToBounds = YES;
    
}

//设置图像尺寸
-(void)setCellImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
}

-(void)setLabConfigure
{
    
}

-(void)refreshUIWithModel:(myCollectionModel *)model
{
    if (model == nil) {
        //如果传入nil 则添加加号
        self.imgView.image = [UIImage imageNamed:@"btn_add_nor"];
        self.lab = nil;
    }else{
        
        if (model.img_nor) {
            if (model.isSelected) {
                self.imgView.image = model.img_sel;
            }else{
                self.imgView.image = model.img_nor;
            }
        }else
        {
            self.imgView.image = model.img;
        }
        self.lab.text = model.title;
        //如果字符数较少 则将其居中对齐
        if ([self.lab.text length] < kMinimumTitleLength) {
            self.lab.textAlignment = NSTextAlignmentCenter;
        }
    }
    
}


@end