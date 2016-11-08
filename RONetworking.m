//
//  RONetworking.m
//  secQre
//
//  Created by Sen5 on 16/11/8.
//  Copyright © 2016年 hsl. All rights reserved.
//

#import "RONetworking.h"
#import "Reachability.h"


@implementation RONetworking

+ (void)RONetworkingGetRequestWithURL:(NSString *)url
                            parameter:(NSDictionary *)parameter
                         successBlock:(void (^)(id object))successBlock
                         failureBlock:(void (^)(id failure))failureBlock
{
    
    Reachability *reachablity = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    if ([reachablity currentReachabilityStatus] == ReachableViaWiFi || [reachablity currentReachabilityStatus] == ReachableViaWWAN)
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", nil];
        
        
        [manager GET:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            successBlock(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    else
    {
        
    }
}

@end
