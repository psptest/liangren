//
//  AddNewSceneViewController.m
//  security2.0
//
//  Created by Sen5 on 16/3/30.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "AddNewSceneViewController.h"
#import "selectDeviceControlForSceneController.h"
#import "UIViewController+MBProgressHUD.h"
#import "AddData.h"
#import "sceneModel.h"
#import "DeviceModel.h"
#import "fileOperation.h"
#import "HouseModelHandle.h"
#import "P2Phandle.h"
#import "prefrenceHeader.h"

@interface AddNewSceneViewController ()<selectDeviceControlForSceneControllerDelegate,UITextFieldDelegate>

@end

@implementation AddNewSceneViewController
{
    sceneModel *_scene;
    NSArray *_opened;
    NSArray *_closed;
}

#if 0
-(id)initWithSceneModel:(sceneModel *)scene
{
    self = [super init];
    if (self) {
        _scene = nil;
        if (scene != nil) {
            _scene = scene;
            _opened = [[fileOperation sharedOperation] getOpennedDeviceWithSceneModle:scene];
            _closed = [[fileOperation sharedOperation] getClosedDeviceWithSceneModle:scene];
        }
    }
    return self;
}
#endif
-(instancetype )initWithModel:(id)model
{
    self = [super initWithModel:model];
    if (self) {
        self.mod = nil;
        if (model != nil) {
            self.mod = model;
            _opened = [[fileOperation sharedOperation] getOpennedDeviceWithSceneModle:self.mod];
            _closed = [[fileOperation sharedOperation] getClosedDeviceWithSceneModle:self.mod];
        }
        self.kType = kScene;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
#if 0
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneEdited:) name:kNotification_sceneEdited object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneDeleted:) name:kNotification_sceneDeleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneAdded:) name:kNotification_newSceneAdded object:nil];
#endif
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidReadData:) name:SocketDidReadDataNotification object:nil];
    
    if (self.mod != nil) {
    [self addBackBtn:[self.mod scene_name]];
    }else
    {
        [self addBackBtn:NSLocalizedString(@"Add_New_Scene", nil)];
    }

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - tableView delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //父类方法
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
  
    // set the image
    if (self.mod != nil) {
        
        [self.changeCell setIcan:[self.mod scene_image]];
    }else
    {
        [self.changeCell setIcan:[UIImage imageNamed:@"ic_default_scene_nor"]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 1) {
        
        NSMutableString *mutStr = [[NSMutableString alloc] init];
        for (DeviceModel *mod in _opened) {
            [mutStr appendString:mod.name];
            [mutStr appendString:@" "];
        }
        
        cell.detailTextLabel.text = mutStr;
        cell.detailTextLabel.textColor = kMainGreenColor;
        
    }else if(indexPath.row == 2)
    {
        NSMutableString *mutStr = [[NSMutableString alloc] init];
        for (DeviceModel *mod in _closed) {
            [mutStr appendString:mod.name];
            [mutStr appendString:@" "];
        }
        
        cell.detailTextLabel.text = mutStr;
        cell.detailTextLabel.textColor = kMainGreenColor;
    }
    
    return cell;
}
#pragma mark - click event
-(void )addBtnClick:(UIButton *)btn
{
    selectDeviceControlForSceneController *select = nil;
    if (btn.tag -100 == 1) {
        
        select = [[selectDeviceControlForSceneController alloc]initWithOpendDevices:_opened closedModel:_closed selecctOpen:YES];
        
    }else if (btn.tag -100 == 2)
    {
        select = [[selectDeviceControlForSceneController alloc]initWithOpendDevices:_opened closedModel:_closed selecctOpen:NO];
    }
    
    select.delegate  = self;
    [self.navigationController pushViewController:select animated:YES];
    
}
#pragma mark - super class method
-(void)setStatusAndAttributes
{
    if (self.mod != nil) {
        self.text.text = [self.mod scene_name];
    }
}

#pragma mark - selectDeviceForSceneViewControllerDelegate
-(void)haveSeletedDevices:(NSArray *)devices isOpened:(BOOL)isOpened
{
    if (isOpened) {
        _opened = devices;
    }else
    {
        _closed = devices;
    }
    
    [self.tableView reloadData];
}
-(void)acthionHaveDone
{
    if ([[P2Phandle shareP2PHandle] linkState] == P2PLinkConnnected) {
        
    // 获取action_list
    NSArray *action_list = [[fileOperation sharedOperation] actionListWithOpenDevice:_opened closeDevice:_closed];
    
    //如果存在则 编辑 如果不存在 则创建
    if (self.mod!= nil) {
        
        [[P2Phandle shareP2PHandle] editSceneWithWithSceneID:[self.mod scene_id] sceneName:self.text.text sceneMode:0 action_list:action_list];
    }else {
        [[P2Phandle shareP2PHandle] addNewSceneWithSceneName:self.text.text mode:0 actionList:action_list];
    }
        [self.hubView show:YES];
        [self.hubView hide:YES afterDelay:HubViewDelayTime];
        
    }else
    {
        [self showWithTime:hubAnimationTime title:kConnectedFailed];
    }
}

#pragma mark - notification
-(void )socketDidReadData:(NSNotification *)notice
{
    NSDictionary *dic = notice.object;
    
    if([dic[@"msg_type"] isEqualToNumber:@(302)]){
        //新增场
        [self newSceneAdded:dic];
        
    }if ([dic[@"msg_type"] isEqualToNumber:@(303)]){
        //删除场景
        [self sceneDeleted:dic];
        
    } if ([dic[@"msg_type"] isEqualToNumber:@(304)]){
        //编辑场景
        [self sceneEdited:dic];
        
    }
}

-(void )sceneEdited:(NSDictionary *)diction
{
    [self.hubView hide:YES];
    [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Scene_Edit_Suc", nil)];
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hubAnimationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    });
}

-(void )sceneDeleted:(NSDictionary *)diction
{
    [self.hubView hide:YES];
    [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Scene_Del_Suc", nil)];
    // 五秒后 关闭
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hubAnimationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        
    });
}

-(void )newSceneAdded:(NSDictionary *)diction
{
    [self.hubView hide:YES];
    
    [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Scene_Edit_Suc", nil)];
    // 五秒后 关闭
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hubAnimationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        
    });
}

#pragma mark - change icon
-(void )changeIcon:(UIImage *)image
{
    NSString *address = [HouseModelHandle shareHouseHandle].currentHouse.address;
    NSString *key = [NSString stringWithFormat:@"%@scene_id%ld.png",address,[self.mod scene_id]];
    

    if (image != nil) {
        
        [self.changeCell setIcan:image];
        
        NSData *Img_data = UIImagePNGRepresentation(image);
        
        [Img_data writeToFile:[[fileOperation sharedOperation] getHomePath:key] atomically:YES];
        
    }else{
        
        [self.changeCell setIcan:[UIImage imageNamed:@"ic_default_scene_nor"]];
        
        //删除对应位置文件
        [[NSFileManager defaultManager] removeItemAtPath:[[fileOperation sharedOperation] getHomePath:key] error:nil];
    }
    
    // 发送通知 objcet scene_id //
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sceneImageSetted object:@{@"scene_id":@([self.mod scene_id])}];
    
}

@end