//
//  accessoryCell.h
//  security2.0
//
//  Created by Sen5 on 16/6/22.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class accessoryCell;
@protocol accessoryCellDelegate <NSObject>
-(void)accessoryBtnClicked:(accessoryCell *)cell;
@end
typedef enum : NSUInteger {
    kAccessayTypeNone,
    kAccessayTypeAdd,
    kAccessayTypeArrow,
    kAccessaryTypeWrong,
    kAccessayTypePoint,
    kAccessaryTypeSwitch
} kCellAccessaryType;

@interface accessoryCell : UITableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ;
//设置图片 名字和类型
-(void)setType:(kCellAccessaryType )type;

-(void)setImage:(UIImage *)img ;
-(void)setText:(NSString *)text;
@property(nonatomic,weak)id <accessoryCellDelegate> delegate;
@end