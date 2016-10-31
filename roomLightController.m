

//
//  roomLightController.m
//  security2.0
//
//  Created by Sen5 on 16/5/4.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "roomLightController.h"

#import "prefrenceHeader.h"

@implementation roomLightController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kLightBackgroudColor;
    
    [self setupUI];
}

-(void)setupUI
{
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSelfViewWidth, kSelfViewHeight/2.0f)];
    
    img.image = [UIImage imageNamed:@"20150529200613_T2cKW.jpeg"];
    
    [self.view addSubview:img];
}

@end
