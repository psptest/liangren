//
//  myButtonItem.m
//  security2.0
//
//  Created by Sen5 on 16/4/11.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "myButtonItem.h"

@interface myButtonItem ()
@property(nonatomic,strong)buttonClickBlock btnClick;
@end

@implementation myButtonItem
+(myButtonItem *)addPushBtnWith:(NSString *)title titleColor:(UIColor *)titleColor  frame:(CGRect)frame buttonClickBlock:(buttonClickBlock)buttonClickBlock
{
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = frame;
    [right setTitle:title forState:UIControlStateNormal];
    [right setTitleColor:titleColor forState:UIControlStateNormal];
    
    myButtonItem *rightItem = [[myButtonItem alloc]initWithCustomView:right];
    rightItem.btnClick = buttonClickBlock;
    
    [right addTarget:rightItem action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
 
    
    return rightItem;
    
}
+(myButtonItem *)addPushBtnWith:(UIImage *)image highLightedImage:(UIImage *)highImage selectedImage:(UIImage *)selectedImage frame:(CGRect)frame  buttonClickBlock:(buttonClickBlock)buttonClickBlock{
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = frame;
    if (!(image==nil)) {
        [right setImage:image forState:UIControlStateNormal];
    }
    if (!(highImage==nil)) {
        [right setImage:highImage forState:UIControlStateHighlighted];
    }
    if (!(selectedImage==nil)) {
        [right setImage:selectedImage  forState:UIControlStateSelected];
    }
    
    myButtonItem *rightItem = [[myButtonItem alloc]initWithCustomView:right];
    rightItem.btnClick = buttonClickBlock;
    
    [right addTarget:rightItem action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return  rightItem;

}
#pragma mark - 点击事件
-(void)rightBtnClick:(id)sender
{
    self.btnClick();
}
@end
