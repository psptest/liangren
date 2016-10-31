//
//  AddViewController.h
//  security2.0
//
//  Created by Sen5 on 16/3/30.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddData.h"
#import "changeCell.h"
@class  MBProgressHUD;
typedef enum : NSUInteger {
    kDevice,
    kRoom ,
    kScene,
} kType;

@interface AddViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *dataList;
@property(nonatomic,strong) id mod;
@property(nonatomic,assign )kType kType;
@property(nonatomic,strong)UITextField *text;//第一行 name修改
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MBProgressHUD *hubView;
@property(nonatomic,strong)changeCell *changeCell;

-(instancetype )initWithModel:(id )model;

//设置 相关操作界面的状态和名字等属性
-(void)setStatusAndAttributes;

//导航按钮“Done”点击事件
-(void)acthionHaveDone;

-(void)addBtnClick:(UIButton *)btn;

//更改图标
-(void )changeIcon:(UIImage *)image;

@end