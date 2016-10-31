//
//  HouseModel.h
//  security
//
//  Created by sen5labs on 15/10/21.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseModel : NSObject <NSCoding>

// 配合 HouseModelHandle 使用  其实可以将这两个类放一起好点
@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *address;

@end
