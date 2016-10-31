//
//  ChooseHomeCell.h
//  security2.0
//
//  Created by liuhuangshuzz on 3/31/16.
//  Copyright © 2016 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HouseModel;
@class ChooseHomeCell;

@protocol chooseHomeCellDelegate <NSObject>

-(void)setHomeWithCell:(ChooseHomeCell *)cell;

@end

@interface ChooseHomeCell : UITableViewCell

@property(nonatomic,weak)id<chooseHomeCellDelegate>delegate;

-(void)refreshUIWithModel:(HouseModel *)mod;
- (void)refreshWithSelectFlag:(BOOL)flag;

@end
