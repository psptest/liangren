//
//  myCollectionModel.m
//  security2.0
//
//  Created by Sen5 on 16/3/25.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "myCollectionModel.h"

@implementation myCollectionModel

//model的实例化
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if ([dic.allKeys containsObject:@"image_nor"]) {
            self.img_nor = [UIImage imageNamed:dic[@"image_nor"]];
            self.img_sel = [UIImage imageNamed:dic[@"image_sel"]];
        }else
        {
            self.img = [UIImage imageNamed:dic[@"image"]];
        }
        
        self.title = dic[@"title"];
        self.isSelected = NO;
    }
    
    return self;
}

@end
