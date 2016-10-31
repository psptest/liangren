//
//  ActivityFeedData.h
//  security2.0
//
//  Created by Sen5 on 16/3/30.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityFeedData : NSObject

@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *detailTitle;
@property(nonatomic,copy)NSString *activityTime;

-(instancetype )initWithDictionary:(NSDictionary *)dic;


@end
