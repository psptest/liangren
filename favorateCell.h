//
//  favorateCell.h
//  security2.0
//
//  Created by Sen5 on 16/6/29.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "myCollectionViewCell.h"
#import "DeviceModel.h"

@interface favorateCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic,strong)UILabel *lab;

-(void)refreshUIWithModel:(DeviceModel *)model;


@end