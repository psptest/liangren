//
//  myCollectionViewCell.h
//  security2.0
//
//  Created by Sen5 on 16/3/24.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myCollectionModel.h"

@interface myCollectionViewCell : UICollectionViewCell

@property(nonatomic,weak)UIImageView *imgView;

@property(nonatomic,weak)UILabel *lab;

-(void)refreshUIWithModel:(myCollectionModel *)model;
//设置图片尺寸
-(void)setCellImageSize:(CGSize)imageSize;

//图片到label的高度
@property(nonatomic,assign)NSUInteger  imageToTitleDistance;

//设置label属性
-(void)setLabConfigure;

@end
