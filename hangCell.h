//
//  hangCell.h
//  security2.0
//
//  Created by liuhuangshuzz on 7/7/16.
//  Copyright © 2016 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class hangCell;
@protocol hangCellDelegate <NSObject>
-(void)btnClicked:(hangCell *)hang;
@end
@interface hangCell : UITableViewCell
@property(nonatomic,weak)id<hangCellDelegate >delegate;
-(void)setRecommandString:(NSString *)recommands;
-(void)setContents:(NSArray *)contents;
@end
