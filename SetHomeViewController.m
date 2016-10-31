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
#import "P2Phandle.h"
#import "fileOperation.h"

@interface SetHomeViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)HouseModel *houseModel;
@property(nonatomic,strong)NSIndexPath *index;

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
    
    self.houseModel = [[HouseModelHandle shareHouseHandle].houses objectAtIndex:self.index.section];
    
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
-(void)setStatusAndAttributes
{
    self.text.text = self.houseModel.name;
}
#pragma mark - 点击事件
-(void)acthionHaveDone
{
        //设置name 更新model 并回调
        self.houseModel.name = self.text.text;
        [[HouseModelHandle shareHouseHandle] updateWithHouse:self.houseModel];
        
        [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 通知管理
-(void)addNotifications
{
}
#pragma mark -操作后台数据
-(void)removeHome
{
    [self showAlertViewWithIndexPath:self.index];
}

//删除对应房子
- (void)deleteWithIndexPath:(NSIndexPath *)indexPath {
    HouseModel *model = [HouseModelHandle shareHouseHandle].houses[indexPath.section];
    //删除model 关闭连接
    [[HouseModelHandle shareHouseHandle] removeWithHouse:model];
    MYLog(@"model currentHouse %@ %@",model.address,[HouseModelHandle shareHouseHandle].currentHouse.address);
    //如果删除的是 当前house 则将连接断开。
    if ([[HouseModelHandle shareHouseHandle].currentHouse.address isEqualToString:model.address]) {
        [[P2Phandle shareP2PHandle] disConnect];
        [HouseModelHandle shareHouseHandle].currentHouse = nil;
        
        //清空列表
        [[fileOperation sharedOperation] clearList];
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_roomListUpdated object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_deviceListUpdated object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_modeListUpdated object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sceneDeleted object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_FavorateDeviceListUpdated object:nil];
        
    }
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

-(void )touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.text endEditing:YES];
}

@end
