//
//  cameraModel.h
//  security2.0
//
//  Created by Sen5 on 16/3/24.
//  Copyright © 2016年 com.letianxia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cameraModel : NSObject

@property(nonatomic,assign)NSInteger playState;
@property(nonatomic,assign)NSInteger cameraID;
@property(nonatomic,assign)NSInteger cameraType;

@property(assign,nonatomic)BOOL isPlaying;
@property(copy,nonatomic)NSString *camera_name;
@property(copy,nonatomic)NSString *camera_did;

@end
