//
//  sceneViewCell.h
//  security2.0
//
//  Created by Sen5 on 16/6/28.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class sceneModel;
@interface sceneViewCell : UICollectionViewCell

@property(nonatomic,weak)UIImageView *imgView;
@property(nonatomic,weak)UILabel *lab;

-(void)refreshUIWithModel:(sceneModel *)model;

//图片到label的高度
@property(nonatomic,assign)NSUInteger  imageToTitleDistance;

//设置label属性
-(void)setLabConfigure;

//设置编辑属性
-(void)setEditing:(BOOL )isEditing;
-(BOOL)getEditing;
-(BOOL)getDeleted;

@end