//
//  securityModel.m
//  security2.0
//
//  Created by liuhuangshuzz on 7/7/16.
//  Copyright © 2016 com.letianxia. All rights reserved.
//

#import "securityModel.h"
#import "fileOperation.h"
#import "prefrenceHeader.h"

@implementation securityModel

-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.sec_mode = [dic[@"sec_mode"] integerValue];
       
        if ([dic.allKeys containsObject:@"no_motion"]) {
            self.no_motion = [dic[@"no_motion"] integerValue];
        }else
        {
            self.no_motion = [[[NSDictionary dictionaryWithContentsOfFile:[[fileOperation sharedOperation] getHomePath:kSecurityMotion]] objectForKey:[NSString stringWithFormat:@"%ld",self.sec_mode]] integerValue];
        }
        self.dev_list = dic[@"dev_list"];
    }
    return self;
}

@end
