//
//  ROParamsView.m
//  secQre
//
//  Created by Sen5 on 16/11/1.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import "ROParamsView.h"
#import <Foundation/Foundation.h>
#import "Masonry.h"
#import "prefrenceHeader.h"

@interface ROParamsView()

{
    UIImage *_img ;
    NSString *_head ;
    NSString *_contents ;
}

@end

@implementation ROParamsView

- (instancetype)initWithImage:(id )image  contents:(NSString *)contents
{
    self = [super init];
    if (self) {
        
        if ([image isKindOfClass:NSClassFromString(@"NSString")]) {
            _head = image;
        }else
        {
            _img = image;
        }
        
        _contents = contents;
        
        self.frame = CGRectMake(0, 0,kScreenWidth/3.0f, 30);
        
        [self createUI];
    }
    return self;
}

-(instancetype)initWithContents:(NSString *)contents
{
    self = [super init];
    if (self) {
        _contents = contents;
        self.frame = CGRectMake(0, 0,kScreenWidth/3.0f, 30);
        [self setBack];
        [self addOnlyContents];
    }
    
    return self;
}

-(void )createUI
{
    [self setBack];
    [self addImage];
    [self addContents];
}

-(void )setBack
{
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.7;
    self.layer.cornerRadius = 15;
    self.clipsToBounds = YES;
}

-(void )addImage
{
    if (_head) {
        //创建head
        UILabel *lab = [[UILabel alloc]init];
        lab.text = _head;
        lab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab];
        
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(self.mas_height);
    }];
        
    }else
    {
        UIImageView *img = [[UIImageView alloc]initWithImage:_img];
        [self addSubview:img];
        
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width).multipliedBy(0.3);
            make.top.equalTo(self.mas_top);
            make.height.mas_equalTo(self.mas_height);
    
        }];
        
    }
}

-(void )addContents
{
    // 创建内容
    UILabel *lab = [[UILabel alloc]init];
    lab.tag = 105;
    lab.text = _contents;
    lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width).multipliedBy(0.7);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(self.mas_height);
    }];
}

-(void )addOnlyContents
{
    // 创建内容
    UILabel *lab = [[UILabel alloc]init];
    lab.tag = 105;
    lab.text = _contents;
    lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(self.mas_height);
    }];
    
}


-(void )updateContents:(NSString *)contents
{
    UILabel *lab = [self viewWithTag:105];
    
    lab.text = contents;
    
}
@end
