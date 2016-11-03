//
//  UIImageView+imageSizeOperation.h
//  imageOperation
//
//  Created by liuhuangshuzz on 4/2/16.
//  Copyright © 2016 liuhuangshuzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (imageSizeOperation)

//获取图像尺寸
+(CGSize)getImageSizeWithName:(NSString *)Name;
+(CGSize )getImageSizeWithPath:(NSString *)path;

//获取某尺寸图像
+(UIImage *)newImageWithPath:(NSString *)path CGSize:(CGSize )newSize;
+(UIImage *)newImageWithName:(NSString *)Name CGSize:(CGSize)newSize;


@end
