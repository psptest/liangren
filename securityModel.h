//
//  securityModel.h
//  security2.0
//
//  Created by liuhuangshuzz on 7/7/16.
//  Copyright © 2016 com.letianxia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface securityModel : NSObject

@property(nonatomic,assign) NSInteger sec_mode;
@property(nonatomic,assign) NSInteger no_motion;
@property(nonatomic,strong) NSArray *dev_list;//{dev_id:111,table_id:111}

-(id)initWithDictionary:(NSDictionary *)dic;

@end
