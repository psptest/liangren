//
//  sceneViewController.m
//  security2.0
//
//  Created by Sen5 on 16/3/24.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "sceneViewController.h"
#import "AddNewSceneViewController.h"
#import "sceneEditViewController.h"

#import "myCollectionModel.h"
#import "addButton.h"
#import "myButtonItem.h"
#import "sceneViewCell.h"
#import "sceneModel.h"
#import "prefrenceHeader.h"
#import "fileOperation.h"
#import "simulatorOperation.h"
#import "UIViewController+BackBtn.h"
#import "UIViewController+MBProgressHUD.h"

#import "MBProgressHUD.h"
#import "DVSwitch.h"
#define kNumbersOfCell 0
#define kAnimatiionDuration 0
#define kMiniItemNumbers 6

@interface sceneViewController ()
@property(nonatomic,strong)MBProgressHUD *hubView;
@end

@implementation sceneViewController
{
    BOOL _editing;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
#if 0
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneDeleted:) name:kNotification_sceneDeleted object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidReadData:) name:SocketDidReadDataNotification object:nil];

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneImageSetted:) name:kNotification_sceneImageSetted object:nil];
#endif
        [self addNotifications];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[sceneViewCell class] forCellWithReuseIdentifier:@"reuse"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"reuse_back"];
#if 0
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [self.collectionView addGestureRecognizer:longGesture];
    [self setEditing:YES animated:YES];
#endif
    
    
    [self createAddBtn];
    [self createNavAppearce];
   
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}
#pragma mark - dataSource
-(void)createModels
{
    self.dataList = nil;
    self.dataList = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getScenes]];
    
}
#pragma mark - 通知管理
-(void )addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSceneUpdated:) name:kNotification_sceneListUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneTriggered:) name:kNotification_sceneTrigger object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newSceneAdded:) name:kNotification_newSceneAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scenEdited:) name:kNotification_sceneEdited object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneImageSetted:) name:kNotification_sceneImageSetted object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneDeleted:) name:kNotification_sceneDeleted object:nil];
    
}
#pragma mark - 创建视图
-(void)createNavAppearce
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Scene", nil) style:UIBarButtonItemStylePlain target:self action:nil];
}
-(void)createAddBtn
{
    addButton *add = [[addButton alloc]initWithFrame:CGRectMake(kSelfViewWidth-60, kSelfViewHeightWithoutTabBar-64, 50, 50) clickBlock:^{
        
        [self.navigationController pushViewController:[[sceneEditViewController alloc]init] animated:NO];
    }];
    add.tag = 100;
    
    [add setImg:[UIImage imageNamed:@"btn_more_scene_"]];
    [add setHightImg:[UIImage imageNamed:@"btn_more_pre_scene_"]];
    
    [self.view addSubview:add];
    [self.view bringSubviewToFront:add];
    
}
#pragma mark - collectionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataList.count) {
        
    sceneViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    
    [cell refreshUIWithModel:self.dataList[indexPath.row]];
    
    return cell;
    }else
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse_back" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        return  cell;
    }
}
-(NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataList.count % 2 == 0) {
        return  self.dataList.count +kMiniItemNumbers;
    }else
    {
        return  self.dataList.count +kMiniItemNumbers+1;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_editing) {
        
        if (indexPath.row <self.dataList.count) {
            if ([[P2Phandle shareP2PHandle] linkState] == P2PLinkConnnected) {
                
                sceneModel *scen = self.dataList[indexPath.row];
                //触发场景
                [[P2Phandle shareP2PHandle] triggerSceneWithID:[scen scene_id]];
                
                [self.hubView show:YES];
                [self.hubView hide:YES afterDelay:5];
            }else
            {
                [self showWithTime:hubAnimationTime title:kConnectedFailed];
            }
        }
    }
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
        addButton *add = (addButton *)[self.view viewWithTag:100];
 
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
                    NSMutableArray *mut =[NSMutableArray array];
                    NSMutableArray *mut_ = [NSMutableArray arrayWithCapacity:self.dataList.count];
                    for (NSInteger i = 0; i<count; i++) {
                        NSIndexPath *index =[NSIndexPath indexPathForItem:i inSection:0];
                
                        sceneViewCell *cell = (sceneViewCell *)[self.collectionView cellForItemAtIndexPath:index];
                        sceneModel *scene = self.dataList[index.row];
                        
                        if ([cell getDeleted]) {
#if 0
                            if(self.dataList.count == 1){
                                [self.dataList removeAllObjects];
                            }else
                            {
                                [self.dataList removeObjectAtIndex:i];
                            }
#endif
                            [mut_ addObject:scene];
                            [mut addObject:index];
                          
                        }
                    }
                    [self.dataList removeObjectsInArray:mut_];
                    [self.collectionView deleteItemsAtIndexPaths:mut];
                    
                   // [[P2Phandle shareP2PHandle] delete]
    
                }];
                
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alert addAction:action1];
                [alert addAction:action2];
                [self presentViewController:alert animated:YES completion:nil];
            }else
            {
                for (NSInteger i = 0; i<self.dataList.count; i++) {
                    
                    NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
                    sceneViewCell *cell = (sceneViewCell *)[self.collectionView cellForItemAtIndexPath:index];
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
        
        [UIView animateWithDuration:kAnimatiionDuration animations:^{
            add.transform = CGAffineTransformMakeRotation(180);

            swit.alpha = 1;
            swit.frame = CGRectMake(CGRectGetMidX(add.frame)-kSelfViewWidth/2.0f, CGRectGetMinY(add.frame), kSelfViewWidth/2.0f, CGRectGetHeight(add.frame)/2.0f);
            swit.center = CGPointMake(swit.center.x, CGRectGetMidY(add.frame));
        }];
        
        for (NSInteger i = 0; i<self.dataList.count; i++) {
            
            NSIndexPath *index =[NSIndexPath indexPathForItem:i inSection:0];
            
            sceneViewCell *cell = (sceneViewCell *)[self.collectionView cellForItemAtIndexPath:index];
            [cell setEditing:YES];
        }
    }
    
    _editing = YES;
    
}

#pragma mark - notification
-(void )sceneImageSetted:(NSNotification *)notice
{
    // 效率待提高
    [self createModels];
    [self.collectionView reloadData];
    
}
#if 0
-(void )socketDidReadData:(NSNotification *)notice
{
    NSDictionary *dic = notice.object;

    if ([dic[@"msg_type"] isEqualToNumber:@(301)]){
        //场景列表
        [dic writeToFile:[[fileOperation sharedOperation] getHomePath:kSceneInfo] atomically:YES];
        [self getSceneUpdated:dic];
       // [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sceneListUpdated object:dic];
        
    } else if([dic[@"msg_type"] isEqualToNumber:@(302)]){
        //新增场
        [self newSceneAdded:notice];
      //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_newSceneAdded object:dic];
    }else if ([dic[@"msg_type"] isEqualToNumber:@(303)]){
        //删除场景
        [self sceneDeleted:notice];
     //   [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sceneDeleted object:dic];
    } else if ([dic[@"msg_type"] isEqualToNumber:@(304)]){
        //编辑场景
             [self scenEdited:notice];
   //     [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sceneEdited object:dic];
    }else if ([dic[@"msg_type"] isEqualToNumber:@(305)]){
        //触发场景
        
        [self sceneTriggered:notice];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sceneTrigger object:dic];
    }
    
}
#endif

-(void)sceneTriggered:(NSNotification *)notice
{
    //接收数据 隐藏菊花
    [self.hubView hide:YES];
    [self showWithTime:hubAnimationTime title:@"Scene Triggered"];
}

-(void)getSceneUpdated:(NSNotification *)notice
{
    
    NSDictionary *diction = notice.object;
    
    [self.dataList removeAllObjects];
    
    for (NSDictionary *dic in diction[@"scenes"]) {
        sceneModel *mod = [[sceneModel alloc]initWithDictionary:dic];
        [self.dataList addObject:mod];
    }
    
    [self.collectionView reloadData];

    
}

-(void)newSceneAdded:(NSNotification *)notice
{
    NSDictionary *dic = notice.object[@"scene_info"];
  
    //跟新本地列表
   [[fileOperation sharedOperation] addNewScene:dic];
    
    sceneModel *scene = [[sceneModel alloc] initWithDictionary:dic];
   
    [self.dataList addObject:scene];
    
    [self.collectionView reloadData];
}

-(void)scenEdited:(NSNotification *)notice
{
    NSDictionary *dic = notice.object[@"scene_info"];
    
    //跟新本地列表
    [[fileOperation sharedOperation] editScene:dic];
    
    sceneModel *scene = [[sceneModel alloc] initWithDictionary:dic];
    
   __block NSInteger item = 0;
    
    [[self.dataList copy] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([(sceneModel *)obj scene_id] == scene.scene_id) {
            [self.dataList replaceObjectAtIndex:idx withObject:scene];
            item = idx;
            *stop = YES;
        }
    }];
    
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:item inSection:0]]];
}

-(void )sceneDeleted:(NSNotification *)notice
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    NSDictionary *dic = notice.object;
    
    BOOL ret = [[fileOperation sharedOperation] deleteScene:dic[@"scene_id"]];
    
    if (ret) {
        [self createModels];
        [self.collectionView reloadData];
    }
    });
}

- (MBProgressHUD *)hubView {
    if (!_hubView) {
        
        if (self.view.window) {
            MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:HUD];
            [HUD hide:YES];
            _hubView = HUD;
        }
    }
    return _hubView;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end