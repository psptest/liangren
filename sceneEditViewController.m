//
//  sceneEditViewController.m
//  security2.0
//
//  Created by Sen5 on 16/4/11.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "sceneEditViewController.h"
#import "AddNewSceneViewController.h"
#import "changePositionViewController.h"
#import "fileOperation.h"
#import "simulatorOperation.h"
#import "sceneModel.h"

@interface sceneEditViewController ()
@end
@implementation sceneEditViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBtn:NSLocalizedString(@"Scene", nil)];
    

    [self addNotifications];

#if  0
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidReadData:) name:SocketDidReadDataNotification object:nil];
#endif
}


#pragma mark - 通知管理
-(void )addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneListUpdated:) name:kNotification_sceneListUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneDeleted:) name:kNotification_sceneDeleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneListUpdated:) name:kNotification_newSceneAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneListUpdated:) name:kNotification_sceneEdited object:nil];
}

-(void )dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - dataSource
-(void)createModels
{
    self.dataList = nil;
    self.dataList = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getScenes]];

}
#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;

    if (self.dataList.count != 0) {
        
    if (indexPath.row < self.dataList.count) {
        
        sceneModel *scene = self.dataList[indexPath.row];
        
        AddNewSceneViewController *add = [[AddNewSceneViewController alloc] initWithModel:scene];
        [self.navigationController pushViewController:add animated:YES];
        
    }else
    {
        AddNewSceneViewController *add = [[AddNewSceneViewController alloc] initWithModel:nil];
        [self.navigationController pushViewController:add animated:YES];
    }
        
    }else
    {
        AddNewSceneViewController *add = [[AddNewSceneViewController alloc] initWithModel:nil];
        [self.navigationController pushViewController:add animated:YES];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseID"];
    
    if (self.dataList.count != 0) {
        
    if (indexPath.row < self.dataList.count) {
        
        sceneModel * mode = self.dataList[indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[mode scene_name],NSLocalizedString(@"Edit", nil)];
        
    }
   else{
       
        cell.textLabel.text = NSLocalizedString(@"Add_New_Scene", nil);
    }
    
    }  else{
        cell.textLabel.text = NSLocalizedString(@"Add_New_Scene", nil);
    }
    
    cell.textLabel.textColor = kLightTitleColor;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count +1;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
    
}

-(void )newSceneAdded:(NSDictionary *)dic
{
    sceneModel *scene = [[sceneModel alloc] initWithDictionary:dic[@"scene_info"]];
    [self.dataList addObject:scene];
    [self.tableView reloadData];
}

-(void )sceneDeleted:(NSNotification *)notice
{
    NSDictionary *dic = notice.object;
    
    
    [[self.dataList copy] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([(sceneModel *)obj scene_id] == [dic[@"scene_id"] integerValue]) {
             [self.dataList removeObject:obj];
        }
    }];
   
    [self.tableView reloadData];

}

-(void )scenEdited:(NSDictionary *)dic
{
    sceneModel *scene = [[sceneModel alloc] initWithDictionary:dic[@"scene_info"]];
    
    [[self.dataList copy] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([(sceneModel *)obj scene_id] == scene.scene_id) {
            [self.dataList replaceObjectAtIndex:idx withObject:scene];
        }
    }];
    
    [self.tableView reloadData];
}
#pragma mark - 改为添加通知
#if 0
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
        [self scenEdited:dic];
        
    }
}

#endif

-(void )sceneListUpdated:(NSNotification *)notice
{
    [self createModels];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end