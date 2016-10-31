//
//  navigationButton.h
//  security2.0
//
//  Created by liuhuangshuzz on 3/24/16.
//  Copyright © 2016 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class navigationButton;

typedef void(^buttonClick)(navigationButton *);
@interface navigationButton : UIButton

-(id)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor backgroudColor:(UIColor *)backgroudColor selectedColor:(UIColor *)selectedColor withBlock:(buttonClick)click;

@end
