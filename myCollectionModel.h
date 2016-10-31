//
//  myCollectionModel.h
//  security2.0
//
//  Created by Sen5 on 16/3/25.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface myCollectionModel : NSObject

@property(nonatomic,strong)UIImage *img;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)UIImage *img_nor;
@property(nonatomic,strong)UIImage *img_sel;
@property(nonatomic,assign)BOOL isSelected;

-(instancetype )initWithDictionary:(NSDictionary *)dic;


@end
