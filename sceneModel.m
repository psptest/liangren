//
//  sceneModel.m
//  security2.0
//
//  Created by Sen5 on 16/6/28.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import "sceneModel.h"
#import "fileOperation.h"
#import "HouseModelHandle.h"

@implementation sceneModel
-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
#if 0
        {
        scene_id:111,
        scene_name:'SceneA',
        select_mode:0, //设防模式 1:AWAY 2:STAY 3:DISARM
        update_time:12343234,
        action_list:[
                     {
                     dev_id:111,
                     action_id:1,
                     action_params:"AQ=="
                     }，
                     ......
                     ]
        },
#endif
        self.scene_id = [dic[@"scene_id"] integerValue];
        self.scene_name = [dic[@"scene_name"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.select_mode = [dic[@"select_mode"] integerValue];
        self.update_time = [dic[@"update_time"] integerValue];
        self.action_list = dic[@"action_list"];
        
        
        NSString *address = [HouseModelHandle shareHouseHandle].currentHouse.address;
        NSString *key = [NSString stringWithFormat:@"%@scene_id%ld.png",address,self.scene_id];
        
        NSString *path = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),key];
        
        
        

            
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            // if there is the picture at the path so set it   or set the default 
            self.scene_image = [UIImage imageWithContentsOfFile:path];
        }else
        {
            self.scene_image = [UIImage imageNamed:@"ic_default_scene_nor"];
        }
    }
    return self;
}
@end
