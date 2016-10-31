//
//  navigationButton.m
//  security2.0
//
//  Created by liuhuangshuzz on 3/24/16.
//  Copyright © 2016 com.letianxia. All rights reserved.
//

#import "navigationButton.h"

@interface navigationButton ()

//@property(nonatomic,strong)UIColor *selectedColor;
@property(nonatomic,copy)buttonClick btnClick;
@end

@implementation navigationButton

-(id)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor backgroudColor:(UIColor *)backgroudColor selectedColor:(UIColor *)selectedColor withBlock:(buttonClick)click
{
    self = [super initWithFrame:frame];
    if (self) {
        self = (navigationButton *)[UIButton buttonWithType:UIButtonTypeCustom];
        self.frame = frame;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        [self setBackgroundColor:backgroudColor];
        self.layer.cornerRadius = 5.0f;
        self.clipsToBounds = YES;
    }
    return self;
}


@end
