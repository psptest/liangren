//
//  modeSelectController.m
//  security2.0
//
//  Created by liuhuangshuzz on 7/7/16.
//  Copyright © 2016 com.letianxia. All rights reserved.
//

#import "modeSelectController.h"
#import "UIViewController+MBProgressHUD.h"
#import "prefrenceHeader.h"
#import "selectCell.h"
#import "DeviceModel.h"
#import "securityModel.h"

@interface modeSelectController ()<selectCellDelegate>
@property(nonatomic,strong)MBProgressHUD *hubView;
@end

@implementation modeSelectController
{
    securityModel *_security;
    NSArray *_sensors;
    NSArray *_selectedArray;
    BOOL _no_motion;
}
-(id)initWithSecurityModel:(securityModel *)security
{
    self = [super init];
    
    if (self) {
        _security = security;
        _sensors = [[fileOperation sharedOperation] getSensors];
        
        if (_security.no_motion) {
            _selectedArray = nil;
            
        }else
        {
            _selectedArray = _sensors;
        }
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBtn];
 
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse_nor"];
    [self.tableView registerClass:[selectCell class] forCellReuseIdentifier:@"reuse_sel"];
   
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(HaveDone)];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modeEdited:) name:kNotification_modeEditted object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

#pragma mark - 多态
-(void )addBackBtn
{
    if (_security.sec_mode == 1) {
        [self addBackBtn:NSLocalizedString(@"Away", nil)];
    }else if (_security.sec_mode == 2)
    {
        [self addBackBtn:NSLocalizedString(@"Stay", nil)];
    }else
    {
        [self addBackBtn:NSLocalizedString(@"Disarm", nil)];
    }
}
-(NSString *)shotCuptips
{
    if (_security.sec_mode == 1) {
        
        return   NSLocalizedString(@"Open_All", nil);
        
    }else if (_security.sec_mode == 2)
    {
        return   NSLocalizedString(@"Open_All_Except_Infrared", nil);
    }else
    {
        return      NSLocalizedString(@"Open_All_Except_Some", nil);
    }
}

#pragma mark - tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else
    {
        if (_selectedArray != nil) {
            
            return _selectedArray.count;
        }else
        {
            return 0;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse_nor" forIndexPath:indexPath];
      
        
        cell.textLabel.text = [self shotCuptips];
        
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.textColor = kLightTitleColor;
        UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        swit.tintColor = kMainGreenColor;
        swit.onTintColor = kMainGreenColor;
        swit.center = CGPointMake(CGRectGetWidth(cell.frame)-30, CGRectGetMidY(cell.frame));
        cell.accessoryView = swit;
        [swit addTarget:self action:@selector(switChanged:) forControlEvents:UIControlEventValueChanged];
        
        if (_security.no_motion) {
            [swit setOn:YES];
            _selectedArray = nil;
        }else
        {
            [swit setOn:NO];
        }
        return cell;
    }else
    {
        selectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse_sel"];
        cell.delegate = self;
        
        DeviceModel *dev = _sensors[indexPath.row];
        
        for (NSNumber *dev_id in [_security dev_list]) {
            if ([dev_id integerValue] == dev.dev_id) {
               dev.isFavorate = YES;
                break;
            }
        }
        
        [cell setImage: [[fileOperation sharedOperation] getImageNameWithDevice_type:dev.dev_type device_mode:dev.mode][@"device"]];
        [cell setText:dev.name];
        [cell setSeleted:dev.isFavorate];
        
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (_security.sec_mode == 1) {
            return  [self tableHeaderViewwithTitle:NSLocalizedString(@"Select_Sensors", nil) backgroudColor:kLightBackgroudColor];
        }else if (_security.sec_mode == 2)
        {
               return  [self tableHeaderViewwithTitle:NSLocalizedString(@"Select_Sensors", nil) backgroudColor:kLightBackgroudColor];
        }else
        {
            return  [self tableHeaderViewwithTitle:NSLocalizedString(@"Select_Sensors", nil) backgroudColor:kLightBackgroudColor];
        
        }
       
    }else
    {
        return [self tableHeaderViewwithTitle:NSLocalizedString(@"Select_Sensor", nil) backgroudColor:kLightBackgroudColor];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }else
    {
    
        return 40;
    }
}

-(UIView *)tableHeaderViewwithTitle:(NSString *)title backgroudColor:(UIColor *)backgroudColor;
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSelfViewWidth, kSelfNavigationBarHeight)];
    view.backgroundColor = backgroudColor;
    UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, kSelfViewWidth, kSelfNavigationBarHeight)];
    tips.backgroundColor = [UIColor clearColor];
    tips.text =  title;
    tips.numberOfLines = 0;
    tips.lineBreakMode = NSLineBreakByWordWrapping;
    tips.font = [UIFont systemFontOfSize:10];
    tips.textColor = kLightTitleColor;
    tips.textAlignment = NSTextAlignmentLeft;
    [view addSubview:tips];
    return  view;
}

#pragma mark - delegate
-(void)haveSeletedCell:(selectCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    
    DeviceModel *device = _sensors[index.row];
    
    if ([cell getSeleted]) {
        [cell setSeleted:NO];
        device.isFavorate = NO;
        
    }else
    {
        [cell setSeleted:YES];
        device.isFavorate = YES;
    }
}

#pragma mark - click event
-(void)HaveDone
{
    if ([[P2Phandle shareP2PHandle] linkState] == P2PLinkConnnected) {
        
    NSMutableArray *dev_list = nil;
        
        if (_no_motion == 0) {
            dev_list = [self getSelectedDevices];
        }else
        {
            if (_security.sec_mode == 1) {
                //open all
                dev_list = [self getAll];
                
            }else if (_security.sec_mode == 2){
                // excect hongwai
                dev_list = [self getAllWithoutInfrared];
            }else
            {
                dev_list = [self getAllWithoutSome];
                
            }
        }
        
        [[P2Phandle shareP2PHandle] editModeWithSec_mode:_security.sec_mode no_motion:_no_motion dev_list:[dev_list copy]];
#if 0
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HubViewDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showWithTime:hubAnimationTime title:@"Security Edited Unsuccefully"];
        });
#endif

    }else
    {
        [self showWithTime:hubAnimationTime  title:kConnectedFailed];
    }
}
// 获取选择设备
-(NSMutableArray *)getSelectedDevices
{
    NSMutableArray *dev_list = [NSMutableArray arrayWithCapacity:_sensors.count];
    for (NSInteger i = 0; i< _sensors.count; i++) {
        
        DeviceModel *dev = _sensors[i];
        
        if (dev.isFavorate) {
            [dev_list addObject:@(dev.dev_id)];
        }
    }
    
    return dev_list;
}
-(NSMutableArray *)getAll
{
    NSMutableArray *dev_list = [NSMutableArray arrayWithCapacity:_sensors.count];
    for (DeviceModel *dev in _sensors) {

            [dev_list addObject:@(dev.dev_id)];
    }
    return dev_list;
    
}
-(NSMutableArray *)getAllWithoutInfrared
{
    NSMutableArray *dev_list = [NSMutableArray arrayWithCapacity:_sensors.count];
   
    for (DeviceModel *dev in _sensors) {
        if (!([dev.dev_type isEqualToString:@"A01040402000D"]||[dev.dev_type isEqualToString:@"CA04070107000"])) {
            [dev_list addObject:@(dev.dev_id)];
        }
    }
    return dev_list;
}
-(NSMutableArray *)getAllWithoutSome
{
        NSMutableArray *dev_list = [NSMutableArray arrayWithCapacity:_sensors.count];
    //A01040402002A"])A01040402000D CA04070106070
    for (DeviceModel *dev in _sensors) {
        if (!([dev.dev_type isEqualToString:@"A01040402000D"]||[dev.dev_type isEqualToString:@"CA04070107000"]||[dev.dev_type isEqualToString:@"A01040402002A"]||[dev.dev_type isEqualToString:@"A010404020015"]||[dev.dev_type isEqualToString:@"CA04070106070"])) {
            [dev_list addObject:@(dev.dev_id)];
        }
    }
    return dev_list;
}

-(void)switChanged:(UISwitch *)swith
{
    //记录选中状态 更新section界面
    if (swith.on) {
        _no_motion = YES;
        _selectedArray = nil;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }else
    {
        _no_motion = NO;
        _selectedArray = _sensors;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - notification
-(void )modeEdited:(NSNotification *)notice
{
    [self.hubView hide:YES];
    
    [self showWithTime:hubAnimationTime title:NSLocalizedString(@"Security_Edited_Suc", nil)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hubAnimationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
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


@end
