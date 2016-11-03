//
//  displayView.h
//  security2.0
//
//  Created by Sen5 on 16/3/28.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROParamsView.h"
@class AnimationDashImageView;

typedef enum : NSUInteger {
    kImagesOk = 100,
    kImagesIntrusion
} kImagesType;

@interface displayView : UIImageView

@property(nonatomic,strong)ROParamsView *humiView;
@property(nonatomic,strong)ROParamsView *tempView;
@property(nonatomic,strong)ROParamsView *sunyView;
@property(nonatomic,strong)ROParamsView *PMView;

-(void)refreshAnimationViewWithFrame:(CGRect )frame;

-(void)refreshAnimationViewWithTag:(kImagesType)imagesType;


@end
