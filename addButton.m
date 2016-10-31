//
//  addButton.m
//  security2.0
//
//  Created by Sen5 on 16/4/5.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "addButton.h"
@interface addButton ()

@property(nonatomic,copy)buttonBlock btnBlock;
@end

@implementation addButton

-(void)btnClick
{
    self.btnBlock();
}

- (instancetype)initWithFrame:(CGRect)frame clickBlock:(buttonBlock)clickBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.btnBlock = clickBlock;
#if 0
        [self setImage:[[UIImage imageNamed:@"btn_add_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
        [self setImage:[[UIImage imageNamed:@"btn_add_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateHighlighted];
#endif
        self.layer.cornerRadius = frame.size.width/2.0f;
        self.clipsToBounds = YES;
        
        [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setImg:(UIImage *)img
{
    [self setImage:img forState:UIControlStateNormal];
}
-(void)setHightImg:(UIImage *)img
{
     [self setImage:img forState:UIControlStateHighlighted];
}


@end
