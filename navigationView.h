//
//  navigationView.h
//  security2.0
//
//  Created by liuhuangshuzz on 3/24/16.
//  Copyright © 2016 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "navigationButton.h"

@protocol navigationDelegate <NSObject>

-(void)buttonPressed:(UIButton *)btn;

@end
@interface navigationView : UIView

-(id)initWithFrame:(CGRect)frame titles:(NSArray *)titles backgoundColor:(UIColor *)backgoundColor selectedColor:(UIColor *)selectedColor titleColor:(UIColor *)titleColor selectedTitleColor:(UIColor *)seletectTitleColor;

-(void)btnClick:(navigationButton *)btn;

@property(nonatomic,weak)id<navigationDelegate>delegate;
@property(nonatomic,strong)UIButton *selectedBtn;
@end