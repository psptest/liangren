//
//  NSNotificationCenter+RONotificationCeter.m
//  secQre
//
//  Created by Sen5 on 16/10/27.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import "NSNotificationCenter+RONotificationCeter.h"

@implementation NSNotificationCenter (RONotificationCeter)


-(void )postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo AtMainQueue:(BOOL)mainQueue
{
    if (mainQueue) {
        
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [self postNotificationName:aName object:anObject userInfo:aUserInfo];
   });
        
    }else
    {
            [self postNotificationName:aName object:anObject userInfo:aUserInfo];
    }
}

@end
