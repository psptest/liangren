//
//  chooseTableViewController.h
//  security2.0
//
//  Created by liuhuangshuzz on 3/31/16.
//  Copyright © 2016 com.letianxia. All rights reserved.
//

#import "ROBaseViewController.h"

@interface chooseTableViewController : ROBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataList;

-(void)createModels;
@end
