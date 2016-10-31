//
//  UIImageView+imageSizeOperation.m
//  imageOperation
//
//  Created by liuhuangshuzz on 4/2/16.
//  Copyright © 2016 liuhuangshuzz. All rights reserved.
//

#import "UIImageView+imageSizeOperation.h"
#import <ImageIO/ImageIO.h>

@implementation UIImageView (imageSizeOperation)

+(CGSize)getImageSizeWithName:(NSString *)Name
{
    NSString *path = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:Name];
    
    return [self getImageSizeWithPath:path];
}
+(CGSize)getImageSizeWithPath:(NSString *)path
{
    NSNumber *width = @0;
    NSNumber *height = @0;
    NSURL *imageFileURL = [NSURL fileURLWithPath:path];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)imageFileURL, NULL);
    if (imageSource) {
        NSDictionary *options = @{(NSString *)kCGImageSourceShouldCache:@NO};
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource,0,(__bridge CFDictionaryRef) options);
        if (imageProperties) {
            width = (NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            height = (NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
        }
        CFRelease(imageProperties);
    }
    
    CFRelease(imageSource);
    return CGSizeMake([width floatValue], [height floatValue]);
}

//获取新尺寸的图像
+(UIImage *)newImageWithName:(NSString *)Name CGSize:(CGSize)newSize
{
    
    NSString *path = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:Name];
    
#if 0
    NSString *path = [[NSBundle mainBundle] pathForResource:Name ofType:nil];
#endif
    return [self newImageWithPath:path CGSize:newSize];
}

+(UIImage *)newImageWithName:(NSString *)Name CGRect:(CGRect )rect{
        UIImage *image = [UIImage imageNamed:@"newBack"];
      CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 0, 2482, 64));
       UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
       CGImageRelease(imageRef);
    return thumbScale;
}

+(UIImage *)newImageWithPath:(NSString *)path CGSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end