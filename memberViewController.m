//
//  memberViewController.m
//  security2.0
//
//  Created by Sen5 on 16/6/29.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "memberViewController.h"
#import "changeMemeberViewController.h"
#import "accessoryCell.h"
#import "prefrenceHeader.h"

@interface memberViewController ()<accessoryCellDelegate>

@end

@implementation memberViewController

{
    UIView *_red;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBtn:NSLocalizedString(@"Members", nil)];
    
    self.dataList = [NSDictionary dictionaryWithContentsOfFile:[[fileOperation sharedOperation] getHomePath:MEMBERINFO]][@"users"];
    
    [self.tableView registerClass:[accessoryCell class] forCellReuseIdentifier:@"reuse"];
    self.tableView.tableFooterView = [[UIView alloc] init];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
    cell.delegate = self;
    [cell setImage:[UIImage imageNamed:@"ic_default_family"]];
    [cell setText:_dataList[indexPath.row][@"identity_name"]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - acce Delegate
-(void)accessoryBtnClicked:(accessoryCell *)cell
{
    changeMemeberViewController *change = [[changeMemeberViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:change animated:YES];
}

-(NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    
    return _dataList;
}


@end
