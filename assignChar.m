//
//  assignChar.m
//  testlib
//
//  Created by liuhuangshuzz on 9/7/16.
//  Copyright © 2016 hsl. All rights reserved.
//

#import "assignChar.h"

@implementation assignChar

+(void )assignChar:(unsigned char *)unChar WithString:(NSString *)string
{
   // const char *cstring = [string UTF8String];
    if (string.length <= sizeof(unChar)) {
        
    for(int i=0; i<string.length; i++){
        char ch = [string characterAtIndex: i];
        unChar[i] = ch;
    }
        
    }
    
    
    
}

@end
