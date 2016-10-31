//
//  PasswordHandle.m
//  security
//
//  Created by sen5labs on 15/9/29.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import "PasswordHandle.h"

static NSString * const KeyUserDefaultPassword = @"KeyUserDefaultPassword";
static NSString * const KeyUserDefaultAutoLogin = @"KeyUserDefaultAutoLogin";

@implementation PasswordHandle

+ (BOOL)isFirstIn {
    //根据passWord判断是否为第一次登陆
    return [self password] ? NO:YES;
}

//返回key的autoLogin的布尔值
+ (BOOL)isAutoLogin {
    BOOL autoLogin = NO;
    autoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:KeyUserDefaultAutoLogin];
    return autoLogin;
}

+ (BOOL)correctWithInputPwd:(NSString *)inputPwd {
    //第一次输入密码六个零
    if ([self isFirstIn] && [inputPwd isEqualToString:@"000000"]) {
        return YES;
    }
    
    if ([inputPwd isEqualToString:[self password]]) {
        return YES;
    }
    
    return NO;
}

//存储并同步
+ (void)saveWithPwd:(NSString *)pwd {
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:KeyUserDefaultPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//存储并同步
+ (void)saveWithAutoLogin:(BOOL)autoLogin {
    NSLog(@"autoLogin = %d",autoLogin);
    [[NSUserDefaults standardUserDefaults] setBool:autoLogin forKey:KeyUserDefaultAutoLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取对应路径下存储的password
+ (NSString *)password {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KeyUserDefaultPassword];
}

@end
