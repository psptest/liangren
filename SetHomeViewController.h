//
//  SetHomeViewController.h
//  security2.0
//
//  Created by Sen5 on 16/5/9.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "AddViewController.h"
@class HouseModel;

@interface SetHomeViewController : AddViewController

-(instancetype )initWithIndex:(NSIndexPath *)index;

-(instancetype )initWithHome:(HouseModel *)house;

@end
