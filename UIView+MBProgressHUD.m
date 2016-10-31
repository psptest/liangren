//
//  UIView+MBProgressHUD.m
//  security
//
//  Created by sen5labs on 15/10/22.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import "UIView+MBProgressHUD.h"
#import "MBProgressHUD.h"

@implementation UIView (MBProgressHUD)

- (void)showWithTime:(NSTimeInterval)time title:(NSString *)title {
    // The hud will dispable all input on the window
    if (!self) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
}

@end
