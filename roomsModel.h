//
//  roomsModel.h
//  security2.0
//
//  Created by Sen5 on 16/3/25.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface roomsModel : NSObject
// these propertyis is not the important one ;
@property(nonatomic,strong)UIImage *img;

@property(nonatomic,copy) NSString *room_name;
@property(nonatomic,assign) NSInteger room_id;
@property(nonatomic,strong) NSArray *devices;// dev_list:[111,222,333]

@property(nonatomic,strong)UIImage *room_image;

-(id )initWithDictionary:(NSDictionary *)dic;

@end