//
//  configureViewController.m
//  security2.0
//
//  Created by Sen5 on 16/4/5.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "configureViewController.h"
#import "modeSelectController.h"
#import "accessoryCell.h"
#import "UIViewController+BackBtn.h"

#import "fileOperation.h"
#import "prefrenceHeader.h"

#if 0
typedef enum : NSUInteger {
    kSelectedConfigureGoodBye = 0,
    kSelectedConfigureAtHome,
    kSelectedConfigureClear,
    
} kSelectedConfigureCell;
#endif

@interface configureViewController()<accessoryCellDelegate>

@end

@implementation configureViewController

{
    NSArray *_securities;
}
-(void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[accessoryCell class] forCellReuseIdentifier:@"reuse_accessory"];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addBackBtn:NSLocalizedString(@"Security Mode", nil)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modeEdited:) name:kNotification_modeEditted object:nil];
    }
    return self;
}

#pragma mark - talbeViewDataSource funtion
-(void)createModels
{
    
    _securities = nil;
    _securities = [[fileOperation sharedOperation] getSecurities];
    
    self.dataList = nil;
    
    self.dataList = nil;
    if (_securities.count != 0) {
         self.dataList = [NSMutableArray arrayWithArray:[[fileOperation sharedOperation] getCellInfoWithCellName:@"configure"]];
    }
    
}
-(NSString *)tips
{
    if (_securities!= nil ||_securities.count != 0) {
        
        return NSLocalizedString(@"Monitor", nil);
    }else
    {
        return  nil;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    accessoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse_accessory"];
    
    [cell setText:NSLocalizedString(self.dataList[indexPath.row][@"title"], nil)];
    [cell setImage:[UIImage imageNamed:self.dataList[indexPath.row][@"image"]]];
    [cell setType:kAccessayTypeArrow];
    [cell setDelegate:self];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - accessaryDelegate
-(void)accessoryBtnClicked:(accessoryCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    
    modeSelectController *select = [[modeSelectController alloc] initWithSecurityModel:_securities[indexPath.row]];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:select animated:YES];
    
}

#pragma mark - notification
-(void )modeEdited:(NSNotification *)notice
{
    NSDictionary *dic = notice.object;
    
    BOOL ret = [[fileOperation sharedOperation] editeMode:dic];
    
    if (ret) {
        
    [self createModels];
    [self.tableView reloadData];
    }
}


@end
