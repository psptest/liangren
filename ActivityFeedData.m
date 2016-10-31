//
//  ActivityFeedData.m
//  security2.0
//
//  Created by Sen5 on 16/3/30.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "ActivityFeedData.h"

@implementation ActivityFeedData

-(instancetype )initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.image = dic[@"image"];
        self.title = dic[@"title"];
        self.detailTitle = dic[@"detail"];
        self.activityTime = dic[@"time"];
    }
    return self;
}
@end
