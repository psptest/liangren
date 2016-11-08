//
//  RONetworking.h
//  secQre
//
//  Created by Sen5 on 16/11/8.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface RONetworking : NSObject


/**
 *  数据请求
 *
 *  @param urlstring URL
 *  @param parmas    请求参数
 *  @param success   请求成功的block
 *  @param fail      请求失败的block
 */
+ (void)RONetworkingGetRequestWithURL:(NSString *)url
                            parameter:(NSDictionary *)parameter
                         successBlock:(void (^)(id object))successBlock
                         failureBlock:(void (^)(id failure))failureBlock;

@end
