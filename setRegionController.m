//
//  setRegionController.m
//  security2.0
//
//  Created by liuhuangshuzz on 3/31/16.
//  Copyright © 2016 com.letianxia. All rights reserved.
//

#import "setRegionController.h"
#import "UIViewController+BackBtn.h"
@interface setRegionController ()

@end

@implementation setRegionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading view.
    [self addBackBtn:@"Region Settings"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self createDataList];
    }
    return self;
}
-(void)createDataList
{
    self.dataList = [[NSMutableArray alloc]init];
    [self.dataList addObject:@""];
    NSMutableArray *data = [NSMutableArray array];
    
    for (NSInteger i=0; i<4; i++) {
        AddData *mod = [[AddData alloc]init];
        mod.accessayType = kAccessayTypePoint;
        mod.hasImage = YES;
        mod.image = @"20150529200613_T2cKW.jpeg";
        [data addObject:mod];
    }
    NSDictionary *cellInfo = @{@"section":@"",@"item":data};
    [self.dataList addObject:cellInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
