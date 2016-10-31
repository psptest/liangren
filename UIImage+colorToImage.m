//
//  UIImage+colorToImage.m
//  security2.0
//
//  Created by Sen5 on 16/6/20.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "UIImage+colorToImage.h"

@implementation UIImage (colorToImage)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size

{
    
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context,
                                       
                                       color.CGColor);
        
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return img;
        
    }
}

@end