//
//  UIDevice+orientation.m
//  testlib
//
//  Created by liuhuangshuzz on 9/1/16.
//  Copyright © 2016 hsl. All rights reserved.
//

#import "UIDevice+orientation.h"

@implementation UIDevice (orientation)


+ (void)setOrientation:(UIInterfaceOrientation)orientation {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[self currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}

@end
