//
//  HouseModel.m
//  security
//
//  Created by sen5labs on 15/10/21.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import "HouseModel.h"

@implementation HouseModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"actionName"];
    [aCoder encodeObject:self.address forKey:@"address"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self)
    {
        self.name = [aDecoder decodeObjectForKey:@"actionName"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
    }
    return self;
}

@end
