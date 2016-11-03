//
//  UIViewController+MBProgressHUD.m
//  security
//
//  Created by sen5labs on 15/10/14.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import "UIViewController+MBProgressHUD.h"

@implementation UIViewController (MBProgressHUD)

- (void)showWithTime:(NSTimeInterval)time title:(NSString *)title {
    // The hud will dispable all input on the window
    if (!self.view) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = title;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:time];
    });
 
}

@end
