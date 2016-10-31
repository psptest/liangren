//
//  UIViewController+BackBtn.m
//  security
//
//  Created by sen5labs on 15/9/30.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import "UIViewController+BackBtn.h"
@implementation UIViewController (BackBtn)

- (void)addBackBtn:(NSString *)title
{
    UIButton * leftButton = [[UIButton alloc] init];
    leftButton.frame = CGRectMake(0, 0, 20, 20);
    [leftButton setImage:[UIImage imageNamed:@"btn_back_nor"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_pre"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self
                   action:@selector(leftBtnClick:)
         forControlEvents:UIControlEventTouchUpInside];
   
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick:)];
    
    self.navigationItem.leftBarButtonItems = @[leftButtonItem,titleItem];
    
}

#pragma mark - 点击事件
- (void)leftBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
@end
