//
//  NSNotificationCenter+RONotificationCeter.h
//  secQre
//
//  Created by Sen5 on 16/10/27.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (RONotificationCeter)

-(void )postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo AtMainQueue:(BOOL )mainQueue;

@end
