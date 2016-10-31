//
//  supportViewController.m
//  testlib
//
//  Created by Sen5 on 16/10/10.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import "supportViewController.h"
#import "prefrenceHeader.h"

@interface supportViewController ()

@end

@implementation supportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBackBtn:NSLocalizedString(@"Support", nil)];
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60)];

    label.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetHeight(self.view.frame)*5/6.0);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:24];
    label.text = [NSString stringWithFormat:@"%@ : 1.1.1",NSLocalizedString(@"Version", nil)];
    label.textColor = kMainGreenColor;
    [self.view addSubview:label];
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
