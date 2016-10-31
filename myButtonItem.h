//
//  myButtonItem.h
//  security2.0
//
//  Created by Sen5 on 16/4/11.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^buttonClickBlock)();

@interface myButtonItem : UIBarButtonItem
+(UIBarButtonItem *)addPushBtnWith:(NSString *)title titleColor:(UIColor *)titleColor
frame:(CGRect)frame buttonClickBlock:(buttonClickBlock )buttonClickBlock;

+(UIBarButtonItem *)addPushBtnWith:(UIImage *)image highLightedImage:(UIImage *)highImage selectedImage:(UIImage *)selectedImage frame:(CGRect)frame buttonClickBlock:(buttonClickBlock )buttonClickBlock;

@end
