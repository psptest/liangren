//
//  SetHomeViewController.m
//  security2.0
//
//  Created by Sen5 on 16/5/9.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "SetHomeViewController.h"
#import "DVSwitch.h"
#import "UIViewController+ActionSheet.h"
#import "UIViewController+MBProgressHUD.h"
#import "UIViewController+BackBtn.h"
#import "NSString+Check.h"
#import "HouseModel.h"
#import "prefrenceHeader.h"
#import "HouseModelHandle.h"
#import "AppDelegate.h"

@interface SetHomeViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)HouseModel *houseModel;
@property(nonatomic,strong)NSIndexPath *index;
@property(nonatomic,strong)UIView *cover;

@property(nonatomic,assign)BOOL *isFirstSetting;
@property(nonatomic,assign)BOOL *rightPass;
@end

@implementation SetHomeViewController

-(instancetype )initWithIndex:(NSIndexPath *)index
{
    self = [super init];
    if (self) {
        
        self.index = index;
        [self createDataList];
    }
    
    return self;
}

-(instancetype )initWithHome:(HouseModel *)house
{
    self = [super init];
    if (self) {
        
        self.houseModel = house;
        _isFirstSetting = YES;
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PERMISSION object:nil];
            
        });
//
//         60s 之后  将发送连接失败通知 (安卓是说九十秒之后  会有701的数据接收  觉得 太久了 没意义)
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [self failedAdding];
//            
//        });
    }
    
    return self;
}
#pragma mark - 加载数据源
-(void)createDataList
{
    self.dataList = [[NSMutableArray alloc]init];
    
    NSArray *titleArr = @[NSLocalizedString(@"Give_Home_Name", nil)];
    NSMutableArray *data = [NSMutableArray array];
    for (NSInteger i=0; i<titleArr.count; i++) {
        
        AddData *mod = [[AddData alloc]init];
        mod.title = titleArr[i];
        mod.accessayType = kAccessayTypeArrow;
        if (i == 0) {
            mod.hasImage = YES;
            mod.image = [UIImage imageNamed:@"ic_default_rooms_"];
            mod.detail = NSLocalizedString(@"e.g.Living Room,Kitchen", nil);
            mod.accessayType = kAccessayTypeNone;
        }
        [data addObject:mod];
    }
    
    NSDictionary *cellInfo = @{@"section":@"",@"item":data};
    [self.dataList addObject:cellInfo];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
     _rightPass = NO;
 
    if (self.index) {
        
        self.houseModel = [[HouseModelHandle shareHouseHandle].houses objectAtIndex:self.index.section];
    }
    
    if (_isFirstSetting) {
        [self addTips];
        [self requestRight];
    }
    
    [self addBackBtn:self.houseModel.name];
    
    [self addNotifications];
}
#pragma mark - 创建视图
-(UIView *)tableFooterView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSelfViewWidth, kSelfViewHeight)];
    
    // 3 创建button
    UIButton *remove = [[UIButton alloc] initWithFrame:CGRectMake(15, 150, kSelfViewWidth-30, 40)];
    remove.backgroundColor = kMainRedColor;
    remove.layer.cornerRadius = 5;
    remove.clipsToBounds = YES;
    [remove setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [remove setTitle:NSLocalizedString(@"Remove_Home", nil) forState:UIControlStateNormal];
    [remove addTarget:self action:@selector(removeHome) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:remove];
    
    return backView;
}

-(void )addTips
{
    UIView *cover =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    cover.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    [app.window addSubview:cover];
   // cover.tag = 105;
    _cover = cover;
    
    UIImageView *imgView = [[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"Bootstrap_home_setting"]];
    imgView.frame = CGRectMake(0, 0, kScreenWidth*0.7, kScreenWidth*0.7*1.2);
    [cover addSubview:imgView];
    imgView.center = self.view.center;
}

-(void )requestRight
{
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
         [[P2Phandle shareP2PHandle] connectWithTimeout:10 nsDID:self.houseModel.address nsCamName:self.houseModel.name];
    });

    //添加p2p监测通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disConnected:)
                                                 name:KNotificationP2PDidDisConnected
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didConnectToP2P:)
                                                 name:KNotificationP2PDidConnected
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightPass) name:NOTIFICATION_PERMISSION object:nil];
}

-(void)setStatusAndAttributes
{
    self.text.text = self.houseModel.name;
}
#pragma mark - 点击事件
-(void)acthionHaveDone
{
    if (_isFirstSetting) {
        
        if (_rightPass) {
            
            //设置name 更新model 并回调
            self.houseModel.name = self.text.text;
            
            [[HouseModelHandle shareHouseHandle] updateWithHouse:self.houseModel];
        }else
        {
            [[P2Phandle shareP2PHandle] disConnect];
        }
    }else
    {
        //设置name 更新model 并回调
        self.houseModel.name = self.text.text;
        
        [[HouseModelHandle shareHouseHandle] updateWithHouse:self.houseModel];
    
    }
   
    //添加房子设置界面 直接返回第二级
    [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
    
    
}

#pragma mark - 通知管理
-(void)addNotifications
{
    
}

-(void )disConnected:(NSNotification *)notifice
{
    [self failedAdding];
}

-(void )didConnectToP2P:(NSNotification *)notice
{
    //发送请求
    [[P2Phandle shareP2PHandle] authenticate];

}
-(void )rightPass
{
    // 权限通过 连接成功  请求内容
    _rightPass = YES;
   
    [_cover removeFromSuperview];
   
    [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Connected_Succ", nil)];
    
    [[fileOperation sharedOperation] clearList];
    
    [[HouseModelHandle shareHouseHandle ] addWithAddress:self.houseModel.address];
    
    
    // 发送房子更换的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_homeChanged object:nil userInfo:nil];
    
  //  [_delegate AddHouseComplished];
    
}

#pragma mark -操作后台数据
-(void)removeHome
{
    [self showAlertViewWithIndexPath:self.index];
}

//删除对应房子
- (void)deleteWithIndexPath:(NSIndexPath *)indexPath {
    
    HouseModel *model = [HouseModelHandle shareHouseHandle].houses[indexPath.section];
    
    MYLog(@"model currentHouse %@ %@",model.address,[HouseModelHandle shareHouseHandle].currentHouse.address);
    //如果删除的是 当前house 则将连接断开。
    if ([[HouseModelHandle shareHouseHandle].currentHouse.address isEqualToString:model.address]) {
        
        [[P2Phandle shareP2PHandle] disConnect];
        
      //  [HouseModelHandle shareHouseHandle].currentHouse = nil;
        
        //清空列表
        [[fileOperation sharedOperation] clearList];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_roomListUpdated object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_deviceListUpdated object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_modeListUpdated object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sceneDeleted object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_FavorateDeviceListUpdated object:nil];
        
    }
    
    //删除model 关闭连接
    [[HouseModelHandle shareHouseHandle] removeWithHouse:model];
   // [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    // 删除目录下 所有房子相关图片
    [self deletePicturesWithAddress:model.address];
}

-(void )deletePicturesWithAddress:(NSString *)address
{
    NSString *path =  [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
    
        NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
        for (NSString *aPath in contentOfFolder) {
            NSString * fullPath = [path stringByAppendingPathComponent:aPath];
            MYLog(@"%@",fullPath);
            
            if ([aPath hasPrefix:address]&& [aPath hasSuffix:@"png"]) {
                
                [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
            }
            
        }
    
     NSArray *contentOfFolder_ = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    for (NSString *aPath in contentOfFolder_) {
        
        NSString * fullPath = [path stringByAppendingPathComponent:aPath];
        MYLog(@"%@",fullPath);
    }

}

- (void)showAlertViewWithIndexPath:(NSIndexPath *)indexPath {
    
    HouseModel *model = [HouseModelHandle shareHouseHandle].houses[indexPath.row];
    
    NSString * title = [NSString stringWithFormat:@"%@ \"%@\"",NSLocalizedString(@"Are you sure you want to delete", nil),model.name];
    __weak typeof(self) weakSelf = self;
    
    UIAlertAction * actionYes = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sure", nil)
                                                         style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                           [weakSelf deleteWithIndexPath:indexPath];
                                                           
                                                           //弹出控制器
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                           
                                                       }];
    
    UIAlertAction * actionNo = [UIAlertAction actionWithTitle:NSLocalizedString(@"Not_Sure", nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil];
    
    [self showWithActions:@[actionYes,actionNo] title:title];
}

#pragma mark - 点击事件
-(void )leftBtnClick:(id )sender
{
    [self popViewController];
}

-(void )touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.text endEditing:YES];
}
#pragma mark - 弹出视图
-(void )popViewController
{
    
    [_cover removeFromSuperview];
    
    
    [self showWithTime:hubAnimationTime title:NSLocalizedString(@"", nil)];
    
    if (_isFirstSetting) {
        
        if (!_rightPass) {
            
            //如果权限未通过 则将房子连接断开
            if ([[P2Phandle shareP2PHandle] linkState] == P2PLinkConnnected) {
                
                [[P2Phandle shareP2PHandle] disConnect];
                
            }
        }
        
        //添加房子设置界面 直接返回第二级
        [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

-(void )failedAdding
{
   // [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Something_Wrong_QR", nil)];
    [self popViewController];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
