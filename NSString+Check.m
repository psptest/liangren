//
//  NSString+Check.m
//  security
//
//  Created by sen5labs on 15/10/23.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)

//检测是否为IP地址
- (BOOL)checkIP {
    
    NSString* number=@"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:self];
}

-(BOOL )isBlank
{
    if (!self || [self isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

@end
