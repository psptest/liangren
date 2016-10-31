//
//  AnimationDashImageView.m
//  security2.0
//
//  Created by Sen5 on 16/4/1.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "AnimationDashImageView.h"
#define kAnimationDuration 2.5f

@implementation AnimationDashImageView

+(instancetype)animationViewWithFrame:(CGRect)frame Images:(NSArray<UIImage *> *)images
{
    AnimationDashImageView *anim = [[AnimationDashImageView alloc]initWithFrame:frame Images:images];

    anim.animationImages = images;
    anim.animationDuration = kAnimationDuration;
    anim.animationRepeatCount = HUGE_VALF;
    
    return anim;
}

+(instancetype)animationViewWithImages:(NSArray<UIImage *> *)images
{
    AnimationDashImageView *anim = [[AnimationDashImageView alloc]init];
    
    anim.animationImages = images;
    anim.animationDuration = kAnimationDuration;
    anim.animationRepeatCount = HUGE_VALF;
    
    return anim;
}

-(id)initWithFrame:(CGRect)frame Images:(NSArray<UIImage *> *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animationImages = images;
        self.animationDuration = kAnimationDuration;
        self.animationRepeatCount = HUGE_VALF;
    }
    return self;
}
@end
