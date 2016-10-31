//
//  AnimationDashImageView.h
//  security2.0
//
//  Created by Sen5 on 16/4/1.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationDashImageView : UIImageView

+(instancetype)animationViewWithFrame:(CGRect)frame Images:(NSArray<UIImage *>*)images;
+(instancetype)animationViewWithImages:(NSArray<UIImage *>*)images;

-(id)initWithFrame:(CGRect)frame Images:(NSArray<UIImage *>*)images;
@end
