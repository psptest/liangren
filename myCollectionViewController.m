//
//  myCollectionViewController.m
//  security2.0
//
//  Created by Sen5 on 16/3/24.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "myCollectionViewController.h"
#import "myCollectionViewCell.h"
#import "myCollectionModel.h"
#import "roomsCollectionCel.h"
#import "ZWCollectionViewFlowLayout.h"

#import "prefrenceHeader.h"
#import "UIColor+Hex.h"

#define kMinimumSpacing 1

@interface myCollectionViewController ()


@end

@implementation myCollectionViewController

-(NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc]init];
        
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createFlowOut];
}
#pragma mark - datasource
-(void)createModels
{
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createModels];
    }
    return self;
}
#pragma mark - 创建collectionView
-(UICollectionViewFlowLayout *)layout
{
   UICollectionViewFlowLayout *
        layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.itemSize = CGSizeMake((CGRectGetWidth(self.view.frame)-kMinimumSpacing*(self.itemEachLine-1))/self.itemEachLine, (CGRectGetWidth(self.view.frame)-kMinimumSpacing*(self.itemEachLine-1))/self.itemEachLine);

        layout.minimumInteritemSpacing = kMinimumSpacing;
        layout.minimumLineSpacing = kMinimumSpacing;
    
        return layout;
}
-(void)createFlowOut
{
    if ([self isKindOfClass:NSClassFromString(@"roomsViewController")]) {
        ZWCollectionViewFlowLayout * layOut = [[ZWCollectionViewFlowLayout alloc] init];
        layOut.degelate =self;
         self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kSelfViewWidth, kSelfViewHeight-108) collectionViewLayout:layOut];
    }else
    {
         self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kSelfViewWidth, kSelfViewHeight-108) collectionViewLayout:self.layout];
    }
   
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#7474"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = NO;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = kRootTabBarColor;
    
    [self.collectionView registerClass:[myCollectionViewCell class] forCellWithReuseIdentifier:@"reuseID"];
}

#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    myCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseID" forIndexPath:indexPath];
    if (cell == nil) {
        
        cell = [[myCollectionViewCell alloc] init];
    }
    
    cell.imageToTitleDistance = 20;
    
    [cell refreshUIWithModel:self.dataList[indexPath.item]];
    
    //清空内容
    if (indexPath.item +1>self.dataList.count) {
        [cell refreshUIWithModel:nil];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    myCollectionViewCell *cell = (myCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    myCollectionModel *mod = self.dataList[indexPath.row];
    mod.isSelected = !mod.isSelected;
    [cell refreshUIWithModel:mod];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
