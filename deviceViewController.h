//
//  deviceViewController.h
//  security2.0
//
//  Created by Sen5 on 16/3/25.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "myTableViewController.h"

@interface deviceViewController : myTableViewController

- (instancetype)initWithDevices:(NSArray *)devices isSetting:(BOOL)isSetting;

@end