//
//  myCollectionViewController.h
//  security2.0
//
//  Created by Sen5 on 16/3/24.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCollectionViewFlowLayout.h"
@interface myCollectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ZWwaterFlowDelegate>

@property(nonatomic,assign)NSUInteger  itemEachLine;
@property(nonatomic,strong)UICollectionViewFlowLayout *layout;
@property(nonatomic,strong)NSMutableArray *dataList;
@property(nonatomic,strong)UICollectionView *collectionView;

-(void)createModels;

@end
