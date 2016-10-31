//
//  PasswordHandle.h
//  security
//
//  Created by sen5labs on 15/9/29.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasswordHandle : NSObject
/**
 *  是否第一次登陆
 *
 *  @return YES & NO
 */
+ (BOOL)isFirstIn;

/**
 *  是否自动登陆
 *
 *  @return YES & NO
 */
+ (BOOL)isAutoLogin;

/**
 *  判断输入的密码是否正确
 *
 *  @param inputPwd 输入的密码
 *
 *  @return YES & NO
 */
+ (BOOL)correctWithInputPwd:(NSString *)inputPwd;

/**
 *  保存密码
 *
 *  @param pwd 密码
 */
+ (void)saveWithPwd:(NSString *)pwd;

/**
 *  保存自动登陆设置
 *
 *  @param autoLogin 是否自动登陆
 */
+ (void)saveWithAutoLogin:(BOOL)autoLogin;


@end
