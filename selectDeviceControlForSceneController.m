
//
//  selectDeviceControlForSceneController.m
//  security2.0
//
//  Created by liuhuangshuzz on 7/5/16.
//  Copyright © 2016 com.letianxia. All rights reserved.
//

#import "selectDeviceControlForSceneController.h"
#import "UIViewController+BackBtn.h"
#import "selectCell.h"
#import "DeviceModel.h"
#import "sceneModel.h"
#import "fileOperation.h"

@interface selectDeviceControlForSceneController ()<selectCellDelegate>

@end

@implementation selectDeviceControlForSceneController
{
    NSArray *_devices;//已经选中的控制设备
    NSMutableArray *_others;//未选中的控制设备
    sceneModel *_sceneModel;//场景模型
    BOOL _selectOpen;//用于判断选择的是开还是关闭设备
}

-(id)initWithSceneModel:(sceneModel *)scene selectOpen:(BOOL)seletctOpen
{
    self = [super init];
    if (self) {
        _sceneModel = scene;
        _selectOpen = seletctOpen;
        NSArray * opened = [[fileOperation sharedOperation] getOpennedDeviceWithSceneModle:_sceneModel];
        NSArray *closed = [[fileOperation sharedOperation] getClosedDeviceWithSceneModle:_sceneModel];
        if (seletctOpen) {
        _devices =  opened;
        }else
        {
            _devices = closed;
        }
        
        _others = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getControls]];
 
        // getOpenned 对的是[ getDevices]方法 所以deviceModel时间属性同 所以可以直接删除打开和关闭的modle

        
        for (DeviceModel *dev in [_others copy]) {
            for (DeviceModel *devi in opened) {
                if (devi.dev_id == dev.dev_id) {
                    [_others removeObject:dev];
                    break;
                }
            }
        }
        for (DeviceModel *dev in [_others copy]) {
            for (DeviceModel *devi in closed) {
                if (devi.dev_id == dev.dev_id) {
                    [_others removeObject:dev];
                    break;
                }
            }
        }
    }
    return self;
}
-(id)initWithOpendDevices:(NSArray *)opened closedModel:(NSArray *)closed selecctOpen:(BOOL)selectOpen
{
    self = [super init];
    if (self) {
        
    if (selectOpen) {
        _devices = opened;
    }else
    {
        _devices = closed;
    }
        
    _others = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getControls]];

    // getOpenned 对的是[ getDevices]方法 所以deviceModel时间属性同 所以可以直接删除打开和关闭的modle
    for (DeviceModel *dev in [_others copy]) {
        for (DeviceModel *devi in opened) {
            if (devi.dev_id == dev.dev_id) {
                [_others removeObject:dev];
                break;
            }
        }
    }
    for (DeviceModel *dev in [_others copy]) {
        for (DeviceModel *devi in closed) {
            if (devi.dev_id == dev.dev_id) {
                [_others removeObject:dev];
                break;
            }
        }
    }
        _selectOpen = selectOpen;
          }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(selectHaveDone)];
    [self addBackBtn:NSLocalizedString(@"Back", nil)];
    
    [self.tableView registerClass:[selectCell class] forCellReuseIdentifier:@"reuse"];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _devices.count + _others.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
 
    
    cell.delegate = self;
    DeviceModel *mod = nil;

    if (indexPath.row < _devices.count) {
        mod = _devices[indexPath.row];
        [cell setSeleted:YES];
    }else
    {
        mod = _others[indexPath.row-_devices.count];
        [cell setSeleted:NO];
    }
    
    
    [cell setImage:[[fileOperation sharedOperation] getImageNameWithDevice_type:mod.dev_type device_mode:mod.mode][@"device"]];
    
    [cell setText:mod.name];
    
    return cell;
}

#pragma mark - click event
-(void)selectHaveDone
{
    NSMutableArray *mut = [NSMutableArray array];
    for (NSInteger i = 0 ;i<_devices.count ; i++) {
        
        selectCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell getSeleted]) {
            DeviceModel *dev = _devices[i];
            [mut addObject:dev];
        }
    }
    
    for (NSInteger i = 0 ;i<_others.count ; i++) {
        
        selectCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+_devices.count inSection:0]];
        if ([cell getSeleted]) {
            DeviceModel *dev = _others[i];
            [mut addObject:dev];
        }
    }
    
    [_delegate haveSeletedDevices:mut isOpened:_selectOpen];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)haveSeletedCell:(selectCell *)cell
{
    [cell setSeleted:![cell getSeleted]];
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
