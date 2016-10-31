//
//  FavoriteDeviceController.h
//  security2.0
//
//  Created by Sen5 on 16/6/29.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "ROBaseViewController.h"

@interface FavoriteDeviceController : ROBaseViewController

@property(nonatomic,strong)UICollectionView *collectionView;

//刷新数据
-(void)createDataList;

@end