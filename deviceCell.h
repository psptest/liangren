//
//  deviceCell.h
//  security2.0
//
//  Created by Sen5 on 16/6/27.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviceModel;
@class deviceCell;


@protocol deviceCellDelegate <NSObject>
-(void)controlDevice:(deviceCell *)device;
@end

@interface deviceCell : UITableViewCell

@property(nonatomic,weak)id<deviceCellDelegate> delegate;

//根据DeviceModel刷新视图
-(void)refreshUIWithModel:(DeviceModel *)device;
//设置button的选中状态
-(void)setBtnSeleted:(BOOL )selected;
-(BOOL )getBtnSeleted;

@end