//
//  ROTabViewController.h
//  testlib
//
//  Created by Sen5 on 16/10/11.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ROTabViewController : UITabBarController

-(void )addViewController:(NSString *)viewController hasNavigationController:(BOOL )has_nav;

@end
