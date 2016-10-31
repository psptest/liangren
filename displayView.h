//
//  displayView.h
//  security2.0
//
//  Created by Sen5 on 16/3/28.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AnimationDashImageView;

typedef enum : NSUInteger {
    kImagesOk = 100,
    kImagesIntrusion
} kImagesType;
@interface displayView : UIImageView

@property(nonatomic,weak)NSTimer *timer;
-(void)refreshAnimationViewWithTag:(kImagesType)imagesType;
-(void)refreshAnimationViewWithFrame:(CGRect )frame;

@end
