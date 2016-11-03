//
//  UIViewController+ActionSheet.m
//  security
//
//  Created by sen5labs on 15/9/30.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import "UIViewController+ActionSheet.h"

@implementation UIViewController (ActionSheet)

- (void)showWithActions:( NSArray <__kindof UIAlertAction *> * _Nonnull )actions title:( NSString * _Nullable )title {
    
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil
                                                                        message:title
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    [actions enumerateObjectsUsingBlock:^(__kindof UIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alertView addAction:obj];
    }];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

@end
