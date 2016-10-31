//
//  roomListViewController.m
//  security2.0
//
//  Created by Sen5 on 16/6/29.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "roomListViewController.h"
#import "AddNewRoomViewController.h"
#import "fileOperation.h"
#import "simulatorOperation.h"
#import "prefrenceHeader.h"
#import "accessoryCell.h"
#import "roomsModel.h"

@interface roomListViewController ()<accessoryCellDelegate>

@end

@implementation roomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBtn:NSLocalizedString(@"Rooms", nil)];

    // no values no ends
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBtnClicked)];
    [self.tableView registerClass:[accessoryCell class] forCellReuseIdentifier:@"reuse"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.dataList = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getRooms]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomListUpdated:) name:kNotification_roomListUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomImageSetted:) name:kNotification_roomImageSetted object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBtnClicked)];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //#warning Incomplete implementation, return the number of rows
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    accessoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    roomsModel *room = _dataList[indexPath.row];
    cell.delegate = self;
    
    [cell setImage:room.room_image];
    
    [cell setType:kAccessayTypeArrow];
    [cell setText:[room room_name]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - accessaryCell Delegate
-(void)accessoryBtnClicked:(accessoryCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    
    roomsModel *room  = self.dataList[index.row];
   
    self.hidesBottomBarWhenPushed = YES;
    AddNewRoomViewController *add = [[AddNewRoomViewController alloc] initWithModel:room];
    
    [self.navigationController pushViewController:add animated:YES];
}
#pragma mark - 点击事件
-(void)rightBtnClicked
{
    AddNewRoomViewController  *look = [[AddNewRoomViewController alloc] initWithModel:nil];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:look animated:YES];
}

#pragma mark - Notification
-(void)roomListUpdated:(NSNotification *)notice
{
    self.dataList = nil;
    self.dataList = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getRooms]];
    [self.tableView reloadData];
}

-(void )roomImageSetted:(NSNotification *)notice
{
    self.dataList = nil;
    self.dataList = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getRooms]];
    [self.tableView reloadData];
    
}

@end
