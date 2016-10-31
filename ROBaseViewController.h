//
//  ROBaseViewController.h
//  secQre
//
//  Created by Sen5 on 16/10/19.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@class MBProgressHUD;


@interface ROBaseViewController : UIViewController

@property (nonatomic) Reachability *wifiReachability;               // 监控网络

@property(nonatomic,strong)MBProgressHUD *hubView;                  //加载视图

- (void)hideTabBar;
- (void)showTabBar;
@end
