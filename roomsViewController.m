//
//  roomsViewController.m
//  security2.0
//
//  Created by Sen5 on 16/3/25.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "roomsViewController.h"
#import "roomsCollectionCel.h"
#import "AddHouseVC.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "deviceForRoomViewController.h"
#import "deviceViewController.h"
#import "prefrenceHeader.h"
#import "roomsModel.h"
#import "HouseModelHandle.h"
#import "HouseModel.h"
#import "addButton.h"
#import "DVSwitch.h"
#import "socketReader.h"
#import "simulatorOperation.h"
#import "fileOperation.h"
#define kLineSpacing 10
#define kItemSpacing 10
#define kEdgeInset 10
#define kAnimationDuration 2
#define kcollectionBackgroudColor [UIColor colorWithRed:202/255.0f green:208/255.0f blue:209/255.0f alpha:1.0f]
@interface roomsViewController ()
@end
@implementation roomsViewController
{
    BOOL _editing;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[roomsCollectionCel class] forCellWithReuseIdentifier:@"reuseID"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
#if 0
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [self.collectionView addGestureRecognizer:longGesture];
    [self setEditing:YES animated:YES];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomsListHaveUpdated:) name:kNotification_roomListUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomsImageSetted:) name:kNotification_roomImageSetted object:nil];

    //根据设备的某些改变 更新room的状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeviceHaveChanged) name:kNotification_deviceChanged object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDeleted:) name:kNotification_deviceDeleted object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
    
}
#pragma mark - 数据源方法
-(void)createModels
{
#if TARGET_IPHONE_SIMULATOR
    self.dataList = [NSMutableArray arrayWithArray:[[simulatorOperation sharedOperation] getRooms]];
#elif TARGET_OS_IPHONE
    
    self.dataList = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getRooms]];
    
#endif
    
}
#pragma mark - 创建布局
-(UICollectionViewFlowLayout *)layout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = kLineSpacing;
    layout.minimumInteritemSpacing = kItemSpacing;
    layout.sectionInset = UIEdgeInsetsMake(kEdgeInset, kEdgeInset, kEdgeInset, kEdgeInset);
    layout.itemSize = CGSizeMake((CGRectGetWidth(self.view.frame)-kItemSpacing-kEdgeInset*2)/2.0f, (CGRectGetWidth(self.view.frame)-kItemSpacing-kEdgeInset*2)*2/3.0f);
    
    return layout;
}
-(BOOL )collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    //取出源item数据
    id objc = [self.dataList objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [self.dataList removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.dataList insertObject:objc atIndex:destinationIndexPath.item];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    roomsModel *room = self.dataList[indexPath.row];
    
    NSArray *devices = [[fileOperation sharedOperation] getAssignedDevicesWithModel:room];
    
    deviceViewController *select = [[deviceViewController alloc] initWithDevices:devices isSetting:NO];
    
    [self.navigationController pushViewController:select animated:YES];
}

#pragma mark - gesture
-(void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture
{
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            
            //在路径上则开始移动该路径上的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
    if (_editing == NO) {
        //弹出删除 取消界面
        
        addButton *add = [[addButton alloc] initWithFrame: CGRectMake(kSelfViewWidth-60, kSelfViewHeightWithoutTabBar-130, 50, 50) clickBlock:nil];
        
        DVSwitch *swit = [DVSwitch switchWithStringsArray:@[@"Delete",@"Cancel"] hasSliderView:NO];
        swit.frame = CGRectMake(CGRectGetMidX(add.frame), CGRectGetMinY(add.frame), 0, CGRectGetHeight(add.frame)/2.0f);
        swit.center = CGPointMake(swit.center.x, CGRectGetMidY(add.frame));
        swit.backgroundColor = kMainRedColor;
        swit.labelTextColorInsideSlider = [UIColor whiteColor];
        swit.tag = 101;
        
        [swit setPressedHandler:^(NSUInteger index) {
            if (index == 0) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delte" message:@"the selected scene will be deleted" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    NSInteger count = self.dataList.count;
                    NSMutableArray *mut = [NSMutableArray array];
                    NSMutableArray *mut_ = [NSMutableArray array];
                    for (NSInteger i = 0; i<count; i++) {
                        NSIndexPath *index =[NSIndexPath indexPathForItem:i inSection:0];
                        roomsCollectionCel *cell = (roomsCollectionCel *)[self.collectionView cellForItemAtIndexPath:index];
                        roomsModel *room = self.dataList[index.row];
                        
                        if ([cell getDeleted]) {
                            
                            [mut addObject:index];
                            [mut_ addObject:room];
                        }
                    }
                    [self.dataList removeObjectsInArray:mut_];
                    [self.collectionView deleteItemsAtIndexPaths:mut];
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:action1];
                [alert addAction:action2];
                [self presentViewController:alert animated:YES completion:nil];
            }else
            {
                for (NSInteger i = 0; i<self.dataList.count; i++) {
                    
                    NSIndexPath *index =[NSIndexPath indexPathForItem:i inSection:0];
                    roomsCollectionCel *cell = (roomsCollectionCel *)[self.collectionView cellForItemAtIndexPath:index];
                    [cell setEditing:NO];
                }
                [self.collectionView reloadData];
                
                DVSwitch *swith = (DVSwitch *)[self.view viewWithTag:101];
                [swith removeFromSuperview];
                swith = nil;
                _editing = NO;
            }
        }];
        
        [self.view addSubview:swit];
        [self.view bringSubviewToFront:add];
        swit.alpha = 0;
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            add.transform = CGAffineTransformMakeRotation(180);
            
            swit.alpha = 1;
            swit.frame = CGRectMake(CGRectGetMidX(add.frame)-kSelfViewWidth/2.0f, CGRectGetMinY(add.frame), kSelfViewWidth/2.0f, CGRectGetHeight(add.frame)/2.0f);
            swit.center = CGPointMake(swit.center.x, CGRectGetMidY(add.frame));
            
        }];
        
        for (NSInteger i = 0; i<self.dataList.count; i++) {
            
            NSIndexPath *index =[NSIndexPath indexPathForItem:i inSection:0];
            roomsCollectionCel  *cell = (roomsCollectionCel *)[self.collectionView cellForItemAtIndexPath:index];
            [cell setEditing:YES];
        }
    }
    
    _editing = YES;
}
#pragma mark - collectionView delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    roomsCollectionCel *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseID" forIndexPath:indexPath];
    
    if (indexPath.row < self.dataList.count) {
        
        [cell refreshUIWithModel:self.dataList[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - zwwaterflowdelegate
-(CGFloat)ZWwaterFlow:(ZWCollectionViewFlowLayout *)waterFlow heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPach
{
    //瀑布流高度
    roomsModel *room = self.dataList[indexPach.row];
    NSInteger dev_count = room.devices.count;
    
    NSInteger line = dev_count / kDeviceNumberEachLine;
    
    CGFloat line_height = (CGRectGetWidth(self.view.frame) - 10 *3) / kDeviceNumberEachLine;
    
    return 200.0 + line_height * line;
}


#pragma mark - notification
-(void)roomsListHaveUpdated:(NSNotification *)notice
{
    self.dataList = nil;
    self.dataList = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getRooms]];
    
    [self.collectionView reloadData];
    
    
}

-(void )DeviceHaveChanged
{
    self.dataList = nil;
    
    self.dataList = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getRooms]];
    
    [self.collectionView reloadData];
}

-(void )roomsImageSetted:(NSNotification *)notice
{
    self.dataList = nil;
    
    self.dataList = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getRooms]];
    
    [self.collectionView reloadData];
}

@end