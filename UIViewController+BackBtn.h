//
//  UIViewController+BackBtn.h
//  security
//
//  Created by sen5labs on 15/9/30.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^buttonClickBlock)();
@interface UIViewController (BackBtn)

- (void)addBackBtn:(NSString *)title;

- (void)leftBtnClick:(id)sender;
@end
