//
//  UIViewController+ActionSheet.h
//  security
//
//  Created by sen5labs on 15/9/30.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ActionSheet)

- (void)showWithActions:( NSArray <__kindof UIAlertAction *> * _Nonnull )actions title:( NSString * _Nullable )title NS_AVAILABLE_IOS(8_0);


@end
