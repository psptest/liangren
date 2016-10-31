//
//  ActivityFeedViewController.m
//  security2.0
//
//  Created by Sen5 on 16/3/30.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "ActivityFeedViewController.h"
#import "ActivityFeedData.h"
#import "prefrenceHeader.h"

@interface ActivityFeedViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)UITableView *tableView;

@end

@implementation ActivityFeedViewController

-(NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}

-(void )createHeader
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSelfViewWidth, kSelfNavigationBarHeight)];
    lab.textColor = kLightTitleColor;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"Activity Feed";
    [self.view addSubview:lab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kSelfNavigationBarHeight, kSelfViewWidth, 1)];
    line.backgroundColor = kMainGreenColor;
    
    [self.view addSubview:line];
}
-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kSelfNavigationBarHeight+1, kSelfViewWidth, kSelfViewHeight-kSelfNavigationBarHeight) style:UITableViewStylePlain];
    
    tableView.dataSource = self ;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
  //  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseID"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBackBtn:@"Notification"];
    // Do any additional setup after loading the view.
    [self createHeader];
    [self createTableView];
}

#pragma mark - 实例化方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        for (NSInteger i=0; i<20; i++) {
            ActivityFeedData *data = [[ActivityFeedData alloc]initWithDictionary:@{@"image":@"20150529200613_T2cKW.jpeg",@"title":@"Kitchen Outlet",@"detail":@"Device was inactive",@"time":@"10.10pm"}];
            [self.dataList addObject:data];
        }
    }
    return self;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseID"];
    }
    ActivityFeedData *data = self.dataList[indexPath.row];
   
        cell.imageView.image = [UIImage imageNamed:data.image];
        cell.textLabel.text = data.title;
        cell.textLabel.textColor = kLightTitleColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.text = data.detailTitle;
        cell.detailTextLabel.textColor = kLightTitleColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        UILabel *desLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSelfViewWidth-50, 0, 50, 20)];
        desLabel.font = [UIFont systemFontOfSize:12];
        desLabel.text = data.activityTime;
        desLabel.textColor = kLightTitleColor;
        cell.accessoryView = desLabel;
        cell.backgroundColor = kLightBackgroudColor;
        cell.imageView.layer.cornerRadius = CGRectGetWidth(cell.imageView.frame)/2.0f;
        cell.imageView.clipsToBounds = YES;
        return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
