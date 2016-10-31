//
//  AddData.h
//  security2.0
//
//  Created by Sen5 on 16/3/30.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "accessoryCell.h"
#if 0
typedef enum : NSUInteger {
    kAccessayTypeNone = 0,
    kAccessayTypeAdd,
    kAccessayTypeArrow,
    kAccessayTypePoint,
    kAccessaryTypeSwitch,
    kAccessaryTypeWrong
} theCellAccessaryType;
#endif
@interface AddData : NSObject

@property(nonatomic,assign)kCellAccessaryType accessayType;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)UIImage *image;
@property(nonatomic,copy)NSString *image_data;
@property(nonatomic,copy)NSString *detail;

@property(nonatomic,assign) BOOL hasImage;


@end