//
//  RONavigationController.m
//  secQre
//
//  Created by Sen5 on 16/10/18.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import "RONavigationController.h"
#import "prefrenceHeader.h"

@interface RONavigationController ()

@end

@implementation RONavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:kMainGreenColor}];
    
    [[UINavigationBar appearance] setBarTintColor:kMainGreenColor];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
