//
//  chooseTableViewController.m
//  security2.0
//
//  Created by liuhuangshuzz on 3/31/16.
//  Copyright © 2016 com.letianxia. All rights reserved.
//

#import "chooseTableViewController.h"
#import "cameraCell.h"
#import "ChooseHomeCell.h"
#import "prefrenceHeader.h"

#define kCellHeigh 200
const CGFloat kMargin = 5;
const CGFloat kHeaderOfSectonHeight = 2;

@implementation chooseTableViewController

-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(kMargin, 0, kSelfViewWidth-kMargin*2, kSelfViewHeight) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
   [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    if ([self isKindOfClass:NSClassFromString(@"cameraViewController")]) {
        
       // [self.tableView registerClass:[cameraCell class] forCellReuseIdentifier:@"reuseID"];
    }else
    {
        [self.tableView registerClass:[ChooseHomeCell class] forCellReuseIdentifier:@"reuseID"];
        
    }
}
-(void)createModels
{

}
- (instancetype)init
{
    self = [super init];
    if (self) {

        [self createModels];
    }
    return self;
}
#pragma mark - talbeView的代理方法


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (kSelfViewWidth-2*kMargin)*0.618;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderOfSectonHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    self.view.backgroundColor = kLightBackgroudColor;
}

-(NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
